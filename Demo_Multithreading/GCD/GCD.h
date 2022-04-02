//
//  GCD.h
//  Demo_Multithreading
//
//  Created by gshopper on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCD : NSObject

+ (instancetype)shareInstance;

- (void)dispatch_apply;

- (void)dispatch_group_notify;

- (void)dispatch_group_wait;

- (void)dispatch_barrier;

- (void)dispatch_semaphore;

@end

NS_ASSUME_NONNULL_END
