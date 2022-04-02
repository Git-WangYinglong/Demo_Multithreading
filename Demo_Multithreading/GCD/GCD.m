//
//  GCD.m
//  Demo_Multithreading
//
//  Created by gshopper on 2022/1/5.
//

#import "GCD.h"

@interface GCD ()

@property (nonatomic, strong) dispatch_queue_t mainQueue;
@property (nonatomic, strong) dispatch_queue_t globalQueue;
@property (nonatomic, strong) dispatch_queue_t createQueue_serial;
@property (nonatomic, strong) dispatch_queue_t createQueue_concurrent;
@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation GCD

+ (instancetype)shareInstance {
    static GCD *gcd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcd = [[self alloc] init];
    });
    return gcd;
}

- (instancetype)init {
    if (self = [super init]) {
        _mainQueue = dispatch_get_main_queue();
        _globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _createQueue_serial = dispatch_queue_create("com.GCD.Demo_Multithreading", NULL);
        _createQueue_concurrent = dispatch_queue_create("com.GCD.Demo_Multithreading", DISPATCH_QUEUE_CONCURRENT);
        _group = dispatch_group_create();
    }
    return self;
}

- (void)dispatch_apply {
    //同步操作
    dispatch_apply(10, _createQueue_concurrent, ^(size_t iteration) {
        NSLog(@"dispatch_apply: %zu\t当前线程: %@", iteration, [NSThread currentThread]);
    });
    NSLog(@"主线程");
}

- (void)dispatch_group_notify {
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 1\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 2\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 3\t当前线程: %@", [NSThread currentThread]);
    });
    //不阻塞当前线程
    dispatch_group_notify(_group, _mainQueue, ^{
        NSLog(@"dispatch_group_notify: 当前线程: %@", [NSThread currentThread]);
    });
    NSLog(@"主线程");
}

- (void)dispatch_group_wait {
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 1\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 2\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_group_async(_group, _globalQueue, ^{
        NSLog(@"dispatch_group_async: 3\t当前线程: %@", [NSThread currentThread]);
    });
    //阻塞当前线程，只要属于 Dispatch Group 的处理尚未执行结束，就会一直等待，中途不能取消
    //使用 DISPATCH_TIME_NOW 达不到阻塞效果
    dispatch_group_wait(_group, DISPATCH_TIME_FOREVER);
    NSLog(@"主线程");
}

- (void)dispatch_barrier {
    dispatch_async(_createQueue_concurrent, ^{
        NSLog(@"dispatch_async: 1\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_async(_createQueue_concurrent, ^{
        NSLog(@"dispatch_async: 2\t当前线程: %@", [NSThread currentThread]);
    });
    //只对通过 dispatch_queue_create() 创建出来的 DISPATCH_QUEUE_CONCURRENT 并发队列有效
    //dispatch_barrier_sync 同理，只是会阻塞当前线程
    dispatch_barrier_async(_createQueue_concurrent, ^{
        NSLog(@"dispatch_barrier_async: 当前线程: %@", [NSThread currentThread]);
    });
    dispatch_async(_createQueue_concurrent, ^{
        NSLog(@"dispatch_async: 3\t当前线程: %@", [NSThread currentThread]);
    });
    dispatch_async(_createQueue_concurrent, ^{
        NSLog(@"dispatch_async: 4\t当前线程: %@", [NSThread currentThread]);
    });
    NSLog(@"主线程");
}

- (void)dispatch_semaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2); //最大并发数为2
    __block int count = 0;
    dispatch_async(_globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //信号量 <=0 时等待
            count++;
            sleep(1);
            dispatch_semaphore_signal(semaphore); //信号量加1
            NSLog(@"dispatch_semaphore: %d\t%@", count, [NSThread currentThread]);
        }
    });
    dispatch_async(_globalQueue, ^{
        for (int i = 0; i < 10; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            count++;
            sleep(1);
            dispatch_semaphore_signal(semaphore);
            NSLog(@"dispatch_semaphore: %d\t%@", count, [NSThread currentThread]);
        }
    });
}

@end
