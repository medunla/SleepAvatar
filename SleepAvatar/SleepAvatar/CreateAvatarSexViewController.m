//
//  CreateAvatarSexViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "CreateAvatarSexViewController.h"
#import "CreateAvatarWearViewController.h"

@interface CreateAvatarSexViewController ()

@property (strong,nonatomic) NSString *avatar_sex;

@end

@implementation CreateAvatarSexViewController

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
    
    NSLog(@"name : %@, birth : %@",self.user_name,self.user_birthday);
    
    // Set border
    self.ButtonSexM.layer.cornerRadius = 5;
    self.ButtonSexM.layer.masksToBounds = YES;
    self.ButtonSexF.layer.cornerRadius = 5;
    self.ButtonSexF.layer.masksToBounds = YES;
    self.ButtonNext.layer.cornerRadius = 5;
    self.ButtonNext.layer.masksToBounds = YES;
    
    // Setting defalut sex
    self.avatar_sex = @"m";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








// ----------------------------------------------------------------------------
//                                 CHOOSE SEX
// ----------------------------------------------------------------------------

- (IBAction)btnSexM:(id)sender {
    self.avatar_sex = @"m";
    [self.ButtonSexM setBackgroundImage:[UIImage imageNamed:@"illust-choose-sex-m-active.png"] forState:UIControlStateNormal];
    [self.ButtonSexF setBackgroundImage:[UIImage imageNamed:@"illust-choose-sex-f.png"] forState:UIControlStateNormal];
    
}
- (IBAction)btnSexF:(id)sender {
    self.avatar_sex = @"f";
    [self.ButtonSexM setBackgroundImage:[UIImage imageNamed:@"illust-choose-sex-m.png"] forState:UIControlStateNormal];
    [self.ButtonSexF setBackgroundImage:[UIImage imageNamed:@"illust-choose-sex-f-active.png"] forState:UIControlStateNormal];
}









// ----------------------------------------------------------------------------
//                              PREPARE-FOR-SEGUE
// ----------------------------------------------------------------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [ [segue identifier] isEqualToString:@"CreateAvatarSexSegue"] ){
        
        CreateAvatarWearViewController *mvc = [segue destinationViewController];
        mvc.user_name = self.user_name;
        mvc.user_birthday = self.user_birthday;
        mvc.avatar_sex = self.avatar_sex;
        
    }
}

@end
