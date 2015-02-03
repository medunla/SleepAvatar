//
//  AvatarViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "DBManager.h"

@interface AvatarViewController : UIViewController <ECSlidingViewControllerDelegate>

- (IBAction)menuButtonTapped:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@end
