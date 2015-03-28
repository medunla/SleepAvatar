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


@property (weak, nonatomic) IBOutlet UIImageView *ImageViewGear1;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewGear2;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewGear3;
@property (nonatomic) int countTimeAddData;

@end
