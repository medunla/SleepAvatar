//
//  CreateAvatarSexViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAvatarSexViewController : UIViewController

@property (strong,nonatomic) NSString *user_name;
@property (strong,nonatomic) NSString *user_birthday;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSexM;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSexF;
@property (weak, nonatomic) IBOutlet UIButton *ButtonNext;


@end
