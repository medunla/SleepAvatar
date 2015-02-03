//
//  StartSleepDetectViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface StartSleepDetectViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrSleepBehavior;

@end
