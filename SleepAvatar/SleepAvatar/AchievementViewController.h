//
//  AchievementViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "DBManager.h"

@interface AchievementViewController : UIViewController <ECSlidingViewControllerDelegate>

- (IBAction)menuButtonTapped:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UIView *ViewDescript;
@property (weak, nonatomic) IBOutlet UIImageView *ImageAchievement;
@property (weak, nonatomic) IBOutlet UITextView *Descript;
@property (weak, nonatomic) IBOutlet UIImageView *ImageReward;


@property (weak, nonatomic) IBOutlet UIButton *ach1;
@property (weak, nonatomic) IBOutlet UIButton *ach2;

@end
