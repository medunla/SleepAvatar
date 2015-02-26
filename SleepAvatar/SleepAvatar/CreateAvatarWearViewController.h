//
//  CreateAvatarWearViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CreateAvatarWearViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;

@property (strong,nonatomic) NSString *user_name;
@property (strong,nonatomic) NSString *user_birthday;
@property (nonatomic) int user_id;
@property (nonatomic) int avatar_id;
@property (strong,nonatomic) NSString *avatar_sex;
@property (strong,nonatomic) NSString *avatar_size;
@property (nonatomic) int avatar_skin;
@property (nonatomic) int shirt_id;
@property (nonatomic) int shirt;
@property (nonatomic) int hair_id;
@property (nonatomic) int hair;
@property (strong,nonatomic) NSString *codeavatar;


@property (weak, nonatomic) IBOutlet UIButton *buttonDone;


@property (weak, nonatomic) IBOutlet UIImageView *ImageBody;
@property (weak, nonatomic) IBOutlet UIImageView *ImageShirt;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionFace;
@property (weak, nonatomic) IBOutlet UIImageView *ImageHair;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionElement;


@property (weak, nonatomic) IBOutlet UIView *ViewItem;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem1;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem4;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem5;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem6;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem7;
@property (weak, nonatomic) IBOutlet UIButton *ButtonItem8;

@property (weak, nonatomic) IBOutlet UILabel *LabelType;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTypeLeft;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTypeRight;



@end
