//
//  AppDelegate.m
//  Demo_Multithreading
//
//  Created by gshopper on 2022/1/5.
//

#import "AppDelegate.h"

#import "BaseNavigationController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[ViewController new]];
    
    return YES;
}

@end
