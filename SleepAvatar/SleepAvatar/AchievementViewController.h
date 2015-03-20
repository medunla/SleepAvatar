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


@property (weak, nonatomic) IBOutlet UIScrollView *ScrollViewAchievement;


@property (weak, nonatomic) IBOutlet UIButton *ach1;
@property (weak, nonatomic) IBOutlet UIButton *ach2;
@property (weak, nonatomic) IBOutlet UIButton *ach3;
@property (weak, nonatomic) IBOutlet UIButton *ach4;
@property (weak, nonatomic) IBOutlet UIButton *ach5;
@property (weak, nonatomic) IBOutlet UIButton *ach6;
@property (weak, nonatomic) IBOutlet UIButton *ach7;
@property (weak, nonatomic) IBOutlet UIButton *ach8;
@property (weak, nonatomic) IBOutlet UIButton *ach9;
@property (weak, nonatomic) IBOutlet UIButton *ach10;
@property (weak, nonatomic) IBOutlet UIButton *ach11;
@property (weak, nonatomic) IBOutlet UIButton *ach12;
@property (weak, nonatomic) IBOutlet UIButton *ach13;
@property (weak, nonatomic) IBOutlet UIButton *ach14;
@property (weak, nonatomic) IBOutlet UIButton *ach15;





@end
