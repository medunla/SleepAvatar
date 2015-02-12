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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];

    
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
    
    // STEP : 1 Get value
    
    NSString *sex        = [self findAvatarSex];
    NSString *set        = [self findAvatarSet];
    NSString *codeavatar = [self findCodeAvatar];
    
    NSLog(@"[Avatar] sex : %@, set : %@, codeavatar : %@", sex, set, codeavatar);
    
    
    
    
    // STEP 2 : Set image
    // avatar
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 454)];
    NSString *avatar_pic = [NSString stringWithFormat:@"avatar-%@-%@-0.png", sex, set];
    avatar.image = [UIImage imageNamed:avatar_pic];
    [self.ViewAvatar addSubview:avatar];
    
#warning lost change shirt
    
    // emotion
    UIImageView *emotion = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 454)];
    NSString *emotion_pic = [NSString stringWithFormat:@"codeavatar-%@-%@-%@.png", sex, set, codeavatar];
    emotion.image = [UIImage imageNamed:emotion_pic];
    [self.ViewAvatar addSubview:emotion];
    
    
}








// ----------------------------------------------------------------------------
//                              FIND AVATAR SEX
// ----------------------------------------------------------------------------


- (NSString*)findAvatarSex {
    
    NSString *query = @"SELECT avatar_sex FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrSex = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_sex = [self.dbManager.arrColumnNames indexOfObject:@"avatar_sex"];
    
    NSString *sex = [[arrSex objectAtIndex:0] objectAtIndex:indexOfavatar_sex];
    return sex;
}







// ----------------------------------------------------------------------------
//                              FIND AVATAR SET
// ----------------------------------------------------------------------------


- (NSString*)findAvatarSet {
    
    NSString *query = @"SELECT avatar_set FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrSet = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_set = [self.dbManager.arrColumnNames indexOfObject:@"avatar_set"];
    
    NSString *set = [[arrSet objectAtIndex:0] objectAtIndex:indexOfavatar_set];
    return set;
}







// ----------------------------------------------------------------------------
//                              FIND CODE-AVATAR
// ----------------------------------------------------------------------------


- (NSString*)findCodeAvatar {
    
    NSString *query = @"SELECT sleepData_codeavatar FROM sleepData ORDER BY sleepData_id DESC LIMIT 1";

    NSArray *arrCodeAvatar = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *codeavatar;
    
    if ([arrCodeAvatar count] == 0) {
        codeavatar = @"111";
    }
    else {
        NSInteger indexOfsleepData_codeavatar = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_codeavatar"];
        codeavatar = [[arrCodeAvatar objectAtIndex:0] objectAtIndex:indexOfsleepData_codeavatar];
    }
    return codeavatar;
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
