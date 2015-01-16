//
//  AppDelegate.h
//  SleepAvatar
//
//  Created by panupatnew on 1/15/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;
@property (strong, nonatomic) CMMotionManager *motionmanager;
@property (strong, nonatomic) NSArray *arrCheckSleepList;

@end
