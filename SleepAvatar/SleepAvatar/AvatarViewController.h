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

@property (weak, nonatomic) IBOutlet UIImageView *ImageBody;
@property (weak, nonatomic) IBOutlet UIImageView *ImageShirt;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionFace;
@property (weak, nonatomic) IBOutlet UIImageView *ImageHair;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionElement;


@property (weak, nonatomic) IBOutlet UIView *ViewSummaySleep;
@property (weak, nonatomic) IBOutlet UILabel *labelQuality;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelLatency;
@property (weak, nonatomic) IBOutlet UIView *ViewButtonSummarySleep;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSummarySleep;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UIView *ViewWrapSummary;


@end
