//
//  AchievementViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "AchievementViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface AchievementViewController ()

@property (strong, nonatomic) NSArray *arrAcievementDetail;

@end

@implementation AchievementViewController

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
    
    
    // Setup achievement active
    [self setupAchievementActive];
    
    // Get achievement detail
    [self getAcievementDetail];
    
    
    // Hide ViewDescript
    self.ViewDescript.alpha = 0;
    
    
    // Setup button
    [self.ach1 setTag:1];
    [self.ach1 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach1 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach2 setTag:2];
    [self.ach2 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach2 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









// ----------------------------------------------------------------------------
//                          SETUP ACHIEVEMENT ACTIVE
// ----------------------------------------------------------------------------

- (void)setupAchievementActive {
    NSArray *avatarAchievement = [self findAvatarAchievement];
    NSLog(@"avatarAchievement : %@", avatarAchievement);
    
    // Loop for setup active
    for (id obj in avatarAchievement) {
        
#warning not full
        if ([obj isEqualToString:@"1"]) {
            [self.ach1 setImage:[UIImage imageNamed:@"icon-sleep-graph-active.png"] forState:UIControlStateNormal];
        }
    }
}









// ----------------------------------------------------------------------------
//                          SETUP ACHIEVEMENT ACTIVE
// ----------------------------------------------------------------------------

- (void)getAcievementDetail {
    
    NSString *query = @"SELECT * FROM achievement";
    self.arrAcievementDetail = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

}





// ----------------------------------------------------------------------------
//                           FIND AVATAR-ACHIEVEMENT
// ----------------------------------------------------------------------------

- (NSMutableArray*)findAvatarAchievement {
    
    int avatar_id = [self findAvatarid];
    NSLog(@"[findAvatarAchievement] avatar_id : %i",avatar_id);
    
    NSMutableArray *avatarAchievement = [[NSMutableArray alloc] init];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT achievement_id FROM avatar_achievement WHERE avatar_id = %i", avatar_id];
    
    NSArray *arrAvatarAchievement = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfachievement_id = [self.dbManager.arrColumnNames indexOfObject:@"achievement_id"];
    
    NSLog(@"sql : %@, result : %@",query,arrAvatarAchievement);
    
    for (int i=0; i<[arrAvatarAchievement count]; i++) {
        NSLog(@"achievement_id : %@",[[arrAvatarAchievement objectAtIndex:i] objectAtIndex:indexOfachievement_id] );
        [avatarAchievement addObject: [[arrAvatarAchievement objectAtIndex:i] objectAtIndex:indexOfachievement_id] ];
    }

    NSLog(@"[findAvatarAchievement] End");
    return avatarAchievement;
    
}





// ----------------------------------------------------------------------------
//                              FIND AVATAR-ID
// ----------------------------------------------------------------------------


- (int)findAvatarid {
    
    int avatar_id;
    
    NSString *query = @"SELECT avatar_id FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrAvatarid = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];

    avatar_id = [ [[arrAvatarid objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];
    NSLog(@"[findAvatarid] avatar_id : %i",avatar_id);
    
    return avatar_id;
}







// ----------------------------------------------------------------------------
//                          ACHIEVEMENT BUTTON EVENT
// ----------------------------------------------------------------------------


-(void)achievementTouchDown:(UIButton *)sender {
    int achievement_id = (int)sender.tag;
    int arrObj = (int)sender.tag - 1;
    NSLog(@"achievement_id : %i, arrObj : %i", achievement_id, arrObj);
    
    NSInteger indexOfitem_id = [self.dbManager.arrColumnNames indexOfObject:@"item_id"];
    NSInteger indexOfachievement_descript = [self.dbManager.arrColumnNames indexOfObject:@"achievement_descript"];
    
    int item_id = [ [[self.arrAcievementDetail objectAtIndex:arrObj] objectAtIndex:indexOfitem_id] intValue];
    NSLog(@"item_id : %i", item_id);
    
    self.ViewDescript.alpha = 1;
//    self.ImageAchievement.image = [UIImage imageNamed:[NSString stringWithFormat:@"achievement-%i-active.png",achievement_id] ];
    self.ImageAchievement.image = [UIImage imageNamed:@"icon-sleep-graph-active.png" ];
    self.Descript.text = [[self.arrAcievementDetail objectAtIndex:arrObj] objectAtIndex:indexOfachievement_descript];
//    self.ImageReward.image = [UIImage imageNamed:[NSString stringWithFormat:@"item-%i-15.png",item_id] ];
    self.ImageReward.image = [UIImage imageNamed:@"icon-sleep-graph-active.png" ];
    
    NSLog(@"imageAch : %@", [NSString stringWithFormat:@"achievement-%i-active.png",achievement_id]);
    NSLog(@"descript : %@",self.Descript.text);
    NSLog(@"imageReward : %@", [NSString stringWithFormat:@"item-%i-15.png",item_id]);
}
-(void)achievementTouchUp:(id)sender{
    self.ViewDescript.alpha = 0;
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


- (IBAction)ButtonToAvatar:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AvatarViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)ButtonToSleepGraph:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SleepGraphListViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}
//- (IBAction)ButtonToAchievement:(id)sender {
//    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AchievementViewController"];
//    [self.slidingViewController resetTopViewAnimated:YES];
//}
- (IBAction)ButtonToStartSleep:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartSleepRecommandViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
