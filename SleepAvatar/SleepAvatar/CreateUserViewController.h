//
//  CreateUserViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateUserViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *ViewView;
@property (weak, nonatomic) IBOutlet UITextField *FieldName;
@property (weak, nonatomic) IBOutlet UITextField *FieldBirthday;
@property (weak, nonatomic) IBOutlet UIView *ViewKeybaordDatepicker;
@property (weak, nonatomic) IBOutlet UIButton *ButtonNext;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatepickerBirthday;

//- (IBAction)nextBtn:(id)sender;

@end
