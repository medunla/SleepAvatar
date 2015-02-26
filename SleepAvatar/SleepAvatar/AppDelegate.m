//
//  AppDelegate.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "AppDelegate.h"
#import "StartSleepDetectViewController.h"
#import "CreateUserViewController.h"

@interface AppDelegate()

@property (strong,nonatomic) StartSleepDetectViewController *st;

@end

@implementation AppDelegate

- (CMMotionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.motionmanager = [[CMMotionManager alloc] init];
    });
    return self.motionmanager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"enter bg mode");
    
    if (self.arrCheckSleepList == nil) {
        NSLog(@"arr = nil");
    }
    else {
        NSLog(@"sleepListCount2 = %lu",(unsigned long)self.arrCheckSleepList.count);
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"become active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end