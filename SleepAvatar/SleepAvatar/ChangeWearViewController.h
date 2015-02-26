//
//  ChangeWearViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/26/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ChangeWearViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic) int user_id;
@property (nonatomic) int avatar_id;
@property (strong,nonatomic) NSString *avatar_sex;
@property (strong,nonatomic) NSString *avatar_size;
@property (nonatomic) int avatar_skin;
@property (nonatomic) int shirt_id;
@property (nonatomic) int shirt_id_temp;
@property (nonatomic) int shirt;
@property (nonatomic) int hair_id;
@property (nonatomic) int hair_id_temp;
@property (nonatomic) int hair;
@property (strong,nonatomic) NSString *avatarType;


@property (weak, nonatomic) IBOutlet UIButton *buttonDone;


@property (weak, nonatomic) IBOutlet UIImageView *ImageBody;
@property (weak, nonatomic) IBOutlet UIImageView *ImageShirt;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEmotionFace;
@property (weak, nonatomic) IBOutlet UIImageView *ImageHair;


@property (weak, nonatomic) IBOutlet UIView *ViewItem;

@property (weak, nonatomic) IBOutlet UILabel *LabelType;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTypeLeft;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTypeRight;

@end
