//
//  AvatarViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "AvatarViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface AvatarViewController ()
@property (weak, nonatomic) IBOutlet UIView *ViewAvatar;

@end

@implementation AvatarViewController

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
    
    // LeftMenu
    self.slidingViewController.delegate = nil;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sql"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showAvatar];
}






// ----------------------------------------------------------------------------
//                                 SHOW AVATAR
// ----------------------------------------------------------------------------


- (void)showAvatar {
    
    // STEP 1 : Query db
    NSString *query = @"SELECT sleepData_codeavatar FROM sleepData ORDER BY sleepData_id DESC LIMIT 1";
    
    if (self.arrSleepData != nil) {
        self.arrSleepData = nil;
    }
    self.arrSleepData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"count:%i",[self.arrSleepData count]);
    
    
    
    // STEP : 2 Get value
    
    NSString *sex;
    NSString *codeavatar;
    
    #warning sex not dynamic
    sex = @"f";
    if ([self.arrSleepData count] == 0) {
        codeavatar = @"111";
    }
    else {
        NSInteger indexOfsleepData_codeavatar = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_codeavatar"];
        codeavatar = [[self.arrSleepData objectAtIndex:0] objectAtIndex:indexOfsleepData_codeavatar];
    }
    NSLog(@"sex : %@,codeavatar : %@",sex,codeavatar);
    
    // Fix not has image avatar
    codeavatar = @"111";
    NSLog(@"Set new codeavatar for show -> %@", codeavatar);
    
    
    
    
    // STEP 3 : Set image
    // avatar
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 454)];
    NSString *avatar_pic = [NSString stringWithFormat:@"avatar-%@-0.png",sex];
    avatar.image = [UIImage imageNamed:avatar_pic];
    [self.ViewAvatar addSubview:avatar];
    
    // emotion
    UIImageView *emotion = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 454)];
    NSString *emotion_pic = [NSString stringWithFormat:@"codeavatar-%@-%@.png", sex, codeavatar];
    emotion.image = [UIImage imageNamed:emotion_pic];
    [self.ViewAvatar addSubview:emotion];
    
    
}








// ----------------------------------------------------------------------------
//                               BUTTON LEFT-MENU
// ----------------------------------------------------------------------------


- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}







// ----------------------------------------------------------------------------
//                                 TABBAR MENU
// ----------------------------------------------------------------------------


//- (IBAction)ButtonToAvatar:(id)sender {
//    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AvatarViewController"];
//    self.slidingViewController resetTopViewAnimated:YES];
//}
- (IBAction)ButtonToSleepGraph:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SleepGraphListViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)ButtonToAchievement:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AchievementViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)ButtonToStartSleep:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartSleepRecommandViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}


@end
