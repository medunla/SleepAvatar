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
//    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//    [objDateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [objDateformat setDateFormat:@"yyyy-MMMM-dd"];
//    NSString *strTime = [objDateformat stringFromDate:[NSDate date]];
//    NSDate *date = [objDateformat dateFromString:strTime];
//
//    NSLog(@"strTime :%@",strTime);
//    NSLog(@"date :%@",date);
//    NSLog(@"date in datepicker:%@",self.DatepickerBirthday.date);
//    [self.DatepickerBirthday setDate:date];
//    NSLog(@"%@",date);
    
//    NSLocale *us = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    [cal setLocale:us];
//    [self.DatepickerBirthday setLocale:us];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateStyle = NSDateFormatterFullStyle;
//    formatter.timeStyle = NSDateFormatterFullStyle;
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:];
//    
//    NSString *str = [formatter stringFromDate: [NSDate date]];
//    NSLog( @"date: %@" , str);
    
//    NSDate *date = [formatter dateFromString: str];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
//    NSLog( @"date: %@" , date);
    
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
//    NSArray *arroutputDate = [strDate componentsSeparatedByString: @" "];
//    NSLog(@"%@",[arroutputDate objectAtIndex:1]);
//    NSArray *arroutputDate2 = [[arroutputDate objectAtIndex:1] componentsSeparatedByString: @":"];
//    NSLog(@"%d",[[arroutputDate2 objectAtIndex:0] integerValue]);
//    if () {
//        <#statements#>
//    }
    [self.DatepickerBirthday setDate:outputDate];
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
}
- (IBAction)btnFieldBirthday:(id)sender {
    self.move = -107;
    [self showKeyboardDatepicker];
}
- (IBAction)btnDatapickerBirthdayFinish:(id)sender {
    [self hideKeyboardDatepicker];
    [self viewMoveDown];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.FieldName resignFirstResponder];
    [self hideKeyboardDatepicker];
    [self viewMoveDown];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
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
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, self.move, 320, 568)];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, self.move, 320, 460)];
                         }];
    }
    
}
- (void)viewMoveDown
{
    if ( [[UIScreen mainScreen] bounds].size.height == 568 ) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, 0, 320, 568)];
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.ViewView setFrame:CGRectMake(0, 0, 320, 460)];
                         }];
    }
}












// ----------------------------------------------------------------------------
//                             KEYBOARD DATE-PICKER
// ----------------------------------------------------------------------------

-(void)showKeyboardDatepicker {
    self.ViewKeybaordDatepicker.hidden = NO;
}
-(void)hideKeyboardDatepicker {
    self.ViewKeybaordDatepicker.hidden = YES;
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
