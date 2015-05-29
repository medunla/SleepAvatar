//
//  CreateUserViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "CreateUserViewController.h"
#import "CreateAvatarSexViewController.h"
#import "ECSlidingViewController.h"

@interface CreateUserViewController ()

@property (nonatomic) int move;
@property (nonatomic, strong) NSLayoutConstraint *constraintTop;
@property (nonatomic, strong) NSLayoutConstraint *constraintViewViewTop;

@end

@implementation CreateUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    // Set border
    self.FieldName.layer.cornerRadius = 5;
    self.FieldName.layer.masksToBounds = YES;
    self.FieldBirthday.layer.cornerRadius = 5;
    self.FieldBirthday.layer.masksToBounds = YES;
    self.ButtonNext.layer.cornerRadius = 5;
    self.ButtonNext.layer.masksToBounds = YES;
    
    // Delegate textfield
    self.FieldName.delegate = self;
    self.FieldBirthday.delegate = self;
    
    // Set data from datapicker into textfield
    [self.DatepickerBirthday addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *tomorrow = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]]];
    NSLog(@"strDate :%@",strDate);
    NSLog(@"tomorrow :%@",tomorrow);
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate* outputDate = [dateFormatter2 dateFromString:strDate];
    NSLog(@"%@", outputDate);
    
    [self.DatepickerBirthday setDate:outputDate];
    
    
    
    // Set constraints
    self.ViewView.translatesAutoresizingMaskIntoConstraints = NO;
    self.constraintViewViewTop =[NSLayoutConstraint constraintWithItem:self.ViewView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:self.constraintViewViewTop];
    
    self.ViewKeybaordDatepicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.constraintTop =[NSLayoutConstraint constraintWithItem:self.ViewKeybaordDatepicker attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:568];
    [self.view addConstraint:self.constraintTop];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}









// ----------------------------------------------------------------------------
//                         DATE CHANGE INTO TEXTFIELD
// ----------------------------------------------------------------------------

-(void)dateChanged:(id)sender {
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *date = [NSString stringWithFormat:@"%@",datePicker.date];
    NSArray* arrDate = [date componentsSeparatedByString: @" "];
    NSLog(@"Date changed: %@", [arrDate objectAtIndex:0]);

    self.FieldBirthday.text = [arrDate objectAtIndex:0];
}










// ----------------------------------------------------------------------------
//                             KEYBOARD SHOW/HIDE
// ----------------------------------------------------------------------------

- (IBAction)btnFieldName:(id)sender {
    self.move = -69;
    self.constraintViewViewTop.constant = -106.0f;
}
- (IBAction)btnFieldBirthday:(id)sender {
    self.move = -107;
    self.constraintViewViewTop.constant = -107.0f;
    self.constraintTop.constant = 352.0f;
    [self showKeyboardDatepicker];
}
- (IBAction)btnDatapickerBirthdayFinish:(id)sender {
    self.constraintViewViewTop.constant = 0.0f;
    self.constraintTop.constant = 568.0f;
    
    [self hideKeyboardDatepicker];
    [self viewMoveDown];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.constraintViewViewTop.constant = 0.0f;
    self.constraintTop.constant = 568.0f;
    
    [self.FieldName resignFirstResponder];
    [self hideKeyboardDatepicker];
    [self viewMoveDown];
    
    if ( [[UIScreen mainScreen] bounds].size.height == 480 ) {
        if (self.FieldName.text.length>0 && self.FieldBirthday.text.length>0) {
            [self performSegueWithIdentifier:@"CreateUserSegue" sender:nil];
        }
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    self.constraintViewViewTop.constant = 0.0f;
    
    [self.FieldName resignFirstResponder];
    [self viewMoveDown];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.FieldBirthday){
        [self.FieldBirthday resignFirstResponder];
    }
    [self viewMoveup];
}
- (void)viewMoveup
{
    NSLog(@"up");
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        NSLog(@"up2");
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view layoutIfNeeded];
//                             [self.ViewView setFrame:CGRectMake(0, self.move, 320, 568)];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, (self.move-88), 320, 460)];
                         }];
    }
    
}
- (void)viewMoveDown
{
    NSLog(@"down");
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        NSLog(@"down2");    
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view layoutIfNeeded];
//                             [self.ViewView setFrame:CGRectMake(0, 0, 320, 568)];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, -200, 320, 460)];
                         }];
    }
}












// ----------------------------------------------------------------------------
//                             KEYBOARD DATE-PICKER
// ----------------------------------------------------------------------------

-(void)showKeyboardDatepicker {
    
    NSLog(@"show");
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        [UIView animateWithDuration:0.25
                         animations:^{
//                             [self.ViewKeybaordDatepicker setFrame:CGRectMake(0, 352, 320, 216)];
                             [self.view layoutIfNeeded];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewKeybaordDatepicker setFrame:CGRectMake(0, 264, 320, 216)];
                         }];
    }
}
-(void)hideKeyboardDatepicker {
    NSLog(@"hide");
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view layoutIfNeeded];
//                             [self.ViewKeybaordDatepicker setFrame:CGRectMake(0, 568, 320, 216)];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewKeybaordDatepicker setFrame:CGRectMake(0, 480, 320, 216)];
                         }];
    }
}








// ----------------------------------------------------------------------------
//                              PREPARE-FOR-SEGUE
// ----------------------------------------------------------------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [ [segue identifier] isEqualToString:@"CreateUserSegue"] ){
        
        CreateAvatarSexViewController *mvc = [segue destinationViewController];
        mvc.user_name = self.FieldName.text;
        mvc.user_birthday = self.FieldBirthday.text;
        
    }
}


@end
