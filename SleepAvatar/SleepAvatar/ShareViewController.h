//
//  ShareViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/27/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ECSlidingViewController.h"

@interface ShareViewController : UIViewController

- (IBAction)menuButtonTapped:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UIView *ViewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBody;
@property (weak, nonatomic) IBOutlet UIImageView *ImageShirt;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionFace;
@property (weak, nonatomic) IBOutlet UIImageView *ImageHair;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionElement;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewShare;

@property (nonatomic) int avatar_id;
@property (strong,nonatomic) NSString *avatar_sex;
@property (strong,nonatomic) NSString *avatar_size;
@property (nonatomic) int avatar_skin;
@property (nonatomic) int shirt;
@property (nonatomic) int hair;
@property (strong,nonatomic) NSString *codeavatar;

@property (weak, nonatomic) IBOutlet UIView *ViewSummary;
@property (weak, nonatomic) IBOutlet UILabel *labelQuality;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelLatency;

@property (weak, nonatomic) IBOutlet UIView *ViewDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;



@property (weak, nonatomic) IBOutlet UIButton *ButtonShareOutlet;

- (IBAction)ButtonShare:(id)sender;

@end
