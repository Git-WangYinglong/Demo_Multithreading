//
//  ViewController.m
//  Demo_Multithreading
//
//  Created by gshopper on 2022/1/5.
//

#import "ViewController.h"

#import "GCD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self test_dispatch_semaphore];
}

- (void)test_dispatch_apply {
    [[GCD shareInstance] dispatch_apply];
}

- (void)test_dispatch_group_notify {
    [[GCD shareInstance] dispatch_group_notify];
}

- (void)test_dispatch_group_wait {
    [[GCD shareInstance] dispatch_group_wait];
}

- (void)test_dispatch_barrier {
    [[GCD shareInstance] dispatch_barrier];
}

- (void)test_dispatch_semaphore {
    [[GCD shareInstance] dispatch_semaphore];
}

@end
