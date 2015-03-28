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
    [self.ach3 setTag:3];
    [self.ach3 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach3 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach4 setTag:4];
    [self.ach4 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach4 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach5 setTag:5];
    [self.ach5 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach5 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach6 setTag:6];
    [self.ach6 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach6 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach7 setTag:7];
    [self.ach7 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach7 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach8 setTag:8];
    [self.ach8 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach8 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach9 setTag:9];
    [self.ach9 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach9 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach10 setTag:10];
    [self.ach10 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach10 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach11 setTag:11];
    [self.ach11 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach11 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach12 setTag:12];
    [self.ach12 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach12 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach13 setTag:13];
    [self.ach13 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach13 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach14 setTag:14];
    [self.ach14 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach14 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.ach15 setTag:15];
    [self.ach15 addTarget:self action:@selector(achievementTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.ach15 addTarget:self action:@selector(achievementTouchUp:) forControlEvents:UIControlEventTouchUpInside];
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

        if ([obj isEqualToString:@"1"]) {
            [self.ach1 setImage:[UIImage imageNamed:@"achievement-1-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"2"]) {
            [self.ach2 setImage:[UIImage imageNamed:@"achievement-2-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"3"]) {
            [self.ach3 setImage:[UIImage imageNamed:@"achievement-3-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"4"]) {
            [self.ach4 setImage:[UIImage imageNamed:@"achievement-4-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"5"]) {
            [self.ach5 setImage:[UIImage imageNamed:@"achievement-5-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"6"]) {
            [self.ach6 setImage:[UIImage imageNamed:@"achievement-6-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"7"]) {
            [self.ach7 setImage:[UIImage imageNamed:@"achievement-7-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"8"]) {
            [self.ach8 setImage:[UIImage imageNamed:@"achievement-8-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"9"]) {
            [self.ach9 setImage:[UIImage imageNamed:@"achievement-9-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"10"]) {
            [self.ach10 setImage:[UIImage imageNamed:@"achievement-10-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"11"]) {
            [self.ach11 setImage:[UIImage imageNamed:@"achievement-11-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"12"]) {
            [self.ach12 setImage:[UIImage imageNamed:@"achievement-12-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"13"]) {
            [self.ach13 setImage:[UIImage imageNamed:@"achievement-13-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"14"]) {
            [self.ach14 setImage:[UIImage imageNamed:@"achievement-14-active.png"] forState:UIControlStateNormal];
        }
        if ([obj isEqualToString:@"15"]) {
            [self.ach15 setImage:[UIImage imageNamed:@"achievement-15-active.png"] forState:UIControlStateNormal];
        }
    }
}









// ----------------------------------------------------------------------------
//                          SETUP ACHIEVEMENT ACTIVE
// ----------------------------------------------------------------------------

- (void)getAcievementDetail {
    
    NSString *query = @"SELECT * FROM achievement";
    self.arrAcievementDetail = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"arrAchievement : %@",self.arrAcievementDetail);

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
    
    NSString *query = @"SELECT avatar_id, avatar_sex FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrAvatarid = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];
    NSInteger indexOfavatar_sex = [self.dbManager.arrColumnNames indexOfObject:@"avatar_sex"];

    avatar_id = [ [[arrAvatarid objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];
    NSLog(@"[findAvatarid] avatar_id : %i",avatar_id);
    
    self.avatar_sex = [[arrAvatarid objectAtIndex:0] objectAtIndex:indexOfavatar_sex];
    NSLog(@"[findAvatarid] avatar_sex : %@",self.avatar_sex);
    
    return avatar_id;
}







// ----------------------------------------------------------------------------
//                          ACHIEVEMENT BUTTON EVENT
// ----------------------------------------------------------------------------


-(void)achievementTouchDown:(UIButton *)sender {
    
    // STEP 1 : Set achievement_id
    int achievement_id = (int)sender.tag;
    int arrObj = (int)sender.tag - 1;
    NSLog(@"achievement_id : %i, arrObj : %i", achievement_id, arrObj);
    
    // STEP 2 : Find item_id(reward), achievement_descript
    int item_id = 0;
    if ([self.avatar_sex isEqualToString:@"m"]) {
        item_id = [ [[self.arrAcievementDetail objectAtIndex:arrObj] objectAtIndex:1] intValue];
    }
    else {
        item_id = [ [[self.arrAcievementDetail objectAtIndex:arrObj] objectAtIndex:5] intValue];
    }
    NSLog(@"item_id : %i", item_id);
    
    
    // STEP 3 : Find item_thumbnail from item_id
    NSString *item_thumbnail;
    NSString *text_reward = @"Reward:      x 1";
    if(item_id!=0) {
        NSString *query = [NSString stringWithFormat:@"SELECT item_thumbnail FROM item WHERE item_id = %d",item_id];
        
        NSArray *arrItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSInteger indexOfitem_thumbnail = [self.dbManager.arrColumnNames indexOfObject:@"item_thumbnail"];
        
        item_thumbnail = [[arrItem objectAtIndex:0] objectAtIndex:indexOfitem_thumbnail];
        
    }
    else {
        item_thumbnail = @"thumbnail.png";
        text_reward    = @"Reward: -";
    }
    
    NSLog(@"item_thumbnail : %@",item_thumbnail);
    
    
    
    
    // STEP 4 : Show ViewDescript
    self.ImageAchievement.image = [UIImage imageNamed:[NSString stringWithFormat:@"achievement-%i-active.png",achievement_id] ];
    self.Descript.text = [[self.arrAcievementDetail objectAtIndex:arrObj] objectAtIndex:3];
    self.ImageReward.image = [UIImage imageNamed:item_thumbnail ];
    self.labelReward.text  = text_reward;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.ViewDescript.alpha = 1;
                     }];

    
    NSLog(@"imageAch : %@", [NSString stringWithFormat:@"achievement-%i-active.png",achievement_id]);
    NSLog(@"descript : %@",self.Descript.text);
    NSLog(@"imageReward : %@", [NSString stringWithFormat:@"item-%i-15.png",item_id]);
}
-(void)achievementTouchUp:(id)sender{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.ViewDescript.alpha = 0;
                     }];
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
