//
//  SleepGraphListViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "SleepGraphListViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "AppDelegate.h"
#import "SleepGraphListTableViewCell.h"
#import "SleepGraphDetailViewController.h"

@interface SleepGraphListViewController ()

@end

@implementation SleepGraphListViewController

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
    
    // Make self the delegate and datasource of the table view.
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor colorWithRed:(26/255.0) green:(32/255.0) blue:(44/255.0) alpha:1.0];
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];
    
    // Load the data.
    [self findAvatarid];
    [self loadData];
    
    // Check receive achievement
    self.checkRequirementAgain = NO;
    [self checkRequirementAchievement];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







// ----------------------------------------------------------------------------
//                                 LOAD DATA
// ----------------------------------------------------------------------------


- (void)findAvatarid {
    NSString *query = @"SELECT avatar_id, avatar_sex FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    NSArray *data = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];
    NSInteger indexOfavatar_sex = [self.dbManager.arrColumnNames indexOfObject:@"avatar_sex"];
    
    self.avatar_id = [[[data objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];
    NSLog(@"avatar_id : %d",self.avatar_id);
    
    self.avatar_sex = [[data objectAtIndex:0] objectAtIndex:indexOfavatar_sex];
    NSLog(@"avatar_sex : %@",self.avatar_sex);
    
    
    
//    NSLog(@"%@",data);
}










// ----------------------------------------------------------------------------
//                                 LOAD DATA
// ----------------------------------------------------------------------------


- (void)loadData {
    
    // sleepData
    NSString *query  = [NSString stringWithFormat:@"SELECT * FROM sleepData WHERE Avatar_id=%d ORDER BY sleepData_id DESC",self.avatar_id];
//    NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM sleepData WHERE Avatar_id=%d ORDER BY sleepData_id DESC",self.avatar_id];
    
    
    if (self.arrSleepData != nil) {
        self.arrSleepData = nil;
    }
    self.arrSleepData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.table reloadData];
    
    NSLog(@"Count sleepdata %lu", (unsigned long)[self.arrSleepData count]);

    
}











// ----------------------------------------------------------------------------
//                                  TABLE CELL
// ----------------------------------------------------------------------------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 68)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:(26/255.0) green:(32/255.0) blue:(44/255.0) alpha:0.5];
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(25, 31, tableView.frame.size.width - 25, 17);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17.0];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
//    if (self.arrSleepData.count > 0) {
//        NSInteger indexOfsleepData_date = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_date"];
//        NSString *sleepData_date = [[self.arrSleepData objectAtIndex:0] objectAtIndex:indexOfsleepData_date];
//        NSArray* arrSleepData_date = [sleepData_date componentsSeparatedByString: @" "];
//        
//        headerLabel.text = [NSString stringWithFormat:@"%@, %@", [arrSleepData_date objectAtIndex:1], [arrSleepData_date objectAtIndex:2]];
//    }
//    else {
//        headerLabel.text = @"March, 2015";
//    }
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [objDateformat setDateFormat:@"MMMM, yyyy"];
    if (self.arrSleepData.count>0) {
        headerLabel.text = [objDateformat stringFromDate:[NSDate date]];
    }
    else {
        headerLabel.text = @"No data about sleep.";
    }
    
    
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrSleepData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SleepGraphListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SleepGraphListCell" forIndexPath:indexPath];
    cell.layer.borderWidth = 0;
    
    
    // STEP 1 : Get value
    
    // Explode date ---------------------------------------------
    NSString *sleepData_date = [[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:2];
    NSArray *arrSleepData_date = [sleepData_date componentsSeparatedByString: @" "];
    
    // Calculate duration from (min) -> (h)(min) ---------------------------------------------
    int durationFull = [  [[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:7]  intValue];
    NSString *duration;
    if (durationFull>=60) {
        int durationHour = durationFull/60;
        int durationMin = durationFull-(durationHour*60);
        duration = [NSString stringWithFormat:@"%dh %dmin",durationHour,durationMin];
    }
    else {
        duration = [NSString stringWithFormat:@"%dmin",durationFull];
    }
    
    // Quality ---------------------------------------------
    int quality = [[[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:6] intValue];
    
    
    
    
    // STEP 2 : Set View & label
    
    cell.ViewDay.layer.cornerRadius = 5;
    cell.ViewDay.layer.masksToBounds = YES;
    if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Mon"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(244/255.0) green:(208/255.0) blue:(63/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Tue"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(224/255.0) green:(130/255.0) blue:(131/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Wed"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(46/255.0) green:(204/255.0) blue:(113/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Thu"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(243/255.0) green:(156/255.0) blue:(18/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Fri"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(147/255.0) blue:(224/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Sat"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(145/255.0) green:(61/255.0) blue:(136/255.0) alpha:1.0];
    }
    else if ( [[arrSleepData_date objectAtIndex: 3]  isEqual: @"Sun"] ) {
        cell.ViewDay.backgroundColor = [UIColor colorWithRed:(231/255.0) green:(76/255.0) blue:(60/255.0) alpha:1.0];
    }
    else {
        cell.ViewDay.backgroundColor = [UIColor whiteColor];
    }
    
    cell.labelDay.text = [NSString stringWithFormat:@"%@",[arrSleepData_date objectAtIndex: 3] ];
    cell.labelDate.text = [NSString stringWithFormat:@"%@ %@",[arrSleepData_date objectAtIndex: 0] ,[arrSleepData_date objectAtIndex: 1] ];
    cell.labelDuration.text = duration;
    cell.labelQuality.text = [NSString stringWithFormat:@"%i%%",quality];
    if (quality >= 80) {
        cell.labelQuality.textColor = [UIColor colorWithRed:0 green:(130/255.0) blue:(200/255.0) alpha:1.0];
    }
    else if (quality >= 50) {
        cell.labelQuality.textColor = [UIColor colorWithRed:(46/255.0) green:(204/255.0) blue:(113/255.0) alpha:1.0];
    }
    else if (quality >= 0) {
        cell.labelQuality.textColor = [UIColor colorWithRed:(231/255.0) green:(76/255.0) blue:(60/255.0) alpha:1.0];
    }
    else {
        cell.labelQuality.textColor = [UIColor whiteColor];
    }
    
    return cell;
}








// ----------------------------------------------------------------------------
//                               PREPARE SEGUE
// ----------------------------------------------------------------------------


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [ [segue identifier] isEqualToString:@"sleepGraphDetailSegue"] ){
        
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        SleepGraphDetailViewController *mvc = [segue destinationViewController];
        mvc.arrSleepData = [self.arrSleepData objectAtIndex:indexPath.row];
        NSLog(@"Send arrSleepData");
        
        
    }
    
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
//- (IBAction)ButtonToSleepGraph:(id)sender {
//    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SleepGraphListViewController"];
//    [self.slidingViewController resetTopViewAnimated:YES];
//}
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













// ----------------------------------------------------------------------------
//                          CHECK RECEIVE ACHIEVEMENT
// ----------------------------------------------------------------------------

-(void)checkRequirementAchievement {
    NSLog(@"[checkRequirementAchievement :1] Start");
    
    // STEP 1 : Get sleep data
    NSLog(@"arrSleepData : %@", self.arrSleepData);
    
    
    
    
    // STEP 2 : Get avatar_achievement
    NSString *query = [NSString stringWithFormat:@"SELECT achievement_id FROM avatar_achievement WHERE avatar_id=%d",self.avatar_id];
    self.arrAvatarAchievement = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"arrAvatarAchievement : %@", self.arrAvatarAchievement);
    
    
    
    
    // STEP 3 : Check requirement
    if (self.arrSleepData.count > 0) {
        
        BOOL show = NO;
        
        // #1 Quality better 80% in once
        NSLog(@"Check requirement #1");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 80 && show == NO) {
            show = [self checkReceiveAchievement:1];
        }
        
        // #2 Qualuty better 50% in once
        NSLog(@"Check requirement #2");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] < 80 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 50 &&
            show == NO) {
            show = [self checkReceiveAchievement:2];
        }
        
        // #3 Qualuty better 30% in once
        NSLog(@"Check requirement #3");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] < 50 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 30 &&
            show == NO) {
            show = [self checkReceiveAchievement:3];
        }
        
        // #4 Qualuty better 80% continue two days
        NSLog(@"Check requirement #4");
        if (self.arrSleepData.count>=2) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:6] integerValue] >= 80 &&
                show == NO) {
                show = [self checkReceiveAchievement:4];
            }
        }
        
        // #5 Qualuty better 80% continue a week
        NSLog(@"Check requirement #5");
        if (self.arrSleepData.count>=7) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:2] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:3] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:4] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:5] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:6] objectAtIndex:6] integerValue] >= 80 &&
                show == NO) {
                show = [self checkReceiveAchievement:5];
            }
        }
        
        // #6 Qualuty better 80% continue two weeks
        NSLog(@"Check requirement #6");
        if (self.arrSleepData.count>=14) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:2] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:3] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:4] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:5] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:6] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:7] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:8] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:9] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:10] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:11] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:12] objectAtIndex:6] integerValue] >= 80 &&
                [[[self.arrSleepData objectAtIndex:13] objectAtIndex:6] integerValue] >= 80 &&
                show == NO) {
                show = [self checkReceiveAchievement:6];
            }
        }
        
        // #7 Latency less than or equal 15min in once
        NSLog(@"Check requirement #7");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 15 && show == NO) {
            show = [self checkReceiveAchievement:7];
        }
        
        // #8 Latency less than or equal 30min in once
        NSLog(@"Check requirement #8");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] > 15 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 30 &&
            show == NO) {
            show = [self checkReceiveAchievement:8];
        }
        
        // #9 Latency less than or equal 60min in once
        NSLog(@"Check requirement #9");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] > 30 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 60 &&
            show == NO) {
            show = [self checkReceiveAchievement:9];
        }
        
        // #10 Latency less than or equal 15min continue two days
        NSLog(@"Check requirement #10");
        if (self.arrSleepData.count>=2) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:5] integerValue] <= 15 &&
                show == NO) {
                show = [self checkReceiveAchievement:10];
            }
        }
        
        // #11 Latency less than or equal 15min continue a week
        NSLog(@"Check requirement #11");
        if (self.arrSleepData.count>=7) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:2] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:3] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:4] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:5] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:6] objectAtIndex:5] integerValue] <= 15 &&
                show == NO) {
                show = [self checkReceiveAchievement:11];
            }
        }
        
        // #12 Latency less than or equal 15min continue two weeks
        NSLog(@"Check requirement #12");
        if (self.arrSleepData.count>=14) {
            if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:1] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:2] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:3] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:4] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:5] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:6] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:7] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:8] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:9] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:10] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:11] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:12] objectAtIndex:5] integerValue] <= 15 &&
                [[[self.arrSleepData objectAtIndex:13] objectAtIndex:5] integerValue] <= 15 &&
                show == NO) {
                show = [self checkReceiveAchievement:12];
            }
        }
        
        // #13 Duration more than or equal 8h in once
        NSLog(@"Check requirement #13");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:7] integerValue] >= 480 && show == NO) {
            show = [self checkReceiveAchievement:13];
        }
        
        // #14 Duration more than or equal 7h in once
        NSLog(@"Check requirement #14");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:7] integerValue] < 480 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:7] integerValue] >= 420 &&
            show == NO) {
            show = [self checkReceiveAchievement:14];
        }
        
        // #15 Duration more than or equal 6h in once
        NSLog(@"Check requirement #15");
        if ([[[self.arrSleepData objectAtIndex:0] objectAtIndex:7] integerValue] < 420 &&
            [[[self.arrSleepData objectAtIndex:0] objectAtIndex:7] integerValue] >= 360 &&
            show == NO) {
            show = [self checkReceiveAchievement:15];
        }
        
        
        
        
        
        
        
        
        

        
        NSLog(@"show :%d",show);
        
        
        
        // Check requirement achievement again
        NSLog(@"checkRequirementAgain :%d",self.checkRequirementAgain);
        if (show == YES) {
            self.checkRequirementAgain = YES;
        }
        NSLog(@"checkRequirementAgain :%d",self.checkRequirementAgain);
        
    }
    
    NSLog(@"[checkRequirementAchievement :1] End");

}
-(BOOL)checkReceiveAchievement:(int)achievement_id {
    NSLog(@"[checkReceiveAchievement :2] Start");
    
    // STEP 1 : Get avatar_achievement
    NSLog(@"arrAvatarAchievement : %@", self.arrAvatarAchievement);
    
    
    // STEP 2 : Check received
    BOOL checkRepeat = false;
    if (self.arrAvatarAchievement.count > 0) {
        
        
        for (id achievement_id_object in self.arrAvatarAchievement) {
            int ac_id = [[achievement_id_object objectAtIndex:0] intValue];
            if (ac_id == achievement_id) {
                checkRepeat = true;
                NSLog(@"Achievement id%d received.",achievement_id);
            }
        }
    }
    
    
    // STEP 3 : Alert for receive achievement
    if (checkRepeat == false) {
        NSLog(@"Achievement id%d not received.",achievement_id);
        [self showAlertReceiveAchievement:achievement_id];
        NSLog(@"[checkReceiveAchievement :2] END");
        return YES;
    }
    else {
        NSLog(@"[checkReceiveAchievement :2] END");
        return NO;
    }
    
    
    
}
-(void)showAlertReceiveAchievement:(int)achievement_id {
    NSLog(@"[showAlertReceiveAchievement :3] Start");
    
    // STEP 1 : Get information achievement
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM achievement WHERE achievement_id=%d",achievement_id];
    NSArray *arrAchievement = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"arrAchievement : %@",arrAchievement);
    
    
    
    // STEP 2 : Get information item
    NSString *image_reward = @"thumbnail.png";
    if ([self.avatar_sex isEqualToString:@"m"]) {
        self.item_id = (int)[[[arrAchievement objectAtIndex:0] objectAtIndex:1] integerValue];
    }
    else {
        self.item_id = (int)[[[arrAchievement objectAtIndex:0] objectAtIndex:5] integerValue];
    }
    
    if (self.item_id != 0) {
        query = [NSString stringWithFormat:@"SELECT item_thumbnail FROM item WHERE item_id=%d",self.item_id];
        NSArray *arrItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSLog(@"arrItem : %@",arrItem);
        image_reward = [[arrItem objectAtIndex:0] objectAtIndex:0];
    }
    

    
    
    
    // STEP 3 : CreateView
    // Create View
    self.ViewReceiveAchievement = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 280, 230)];
    self.ViewReceiveAchievement.backgroundColor = [UIColor colorWithRed:(49/255.0) green:(64/255.0) blue:(71/255.0) alpha:1.0];
    self.ViewReceiveAchievement.alpha = 0;
    
    // Head text
    UILabel *headText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
    headText.text = @"Achievement unlocked";
    headText.textAlignment = NSTextAlignmentCenter;
    headText.textColor = [UIColor whiteColor];
    headText.backgroundColor = [UIColor colorWithRed:0 green:(130/255.0) blue:(200/255.0) alpha:1.0];
    [headText setFont: [UIFont systemFontOfSize:17 ]];
    
    // Picture achievement
    UIImageView *imageAchievement = [[UIImageView alloc] initWithFrame:CGRectMake(20, 75, 60, 60)];
    NSString *imageAchievementName = [NSString stringWithFormat:@"achievement-%d-active.png",achievement_id];
    imageAchievement.image = [UIImage imageNamed:imageAchievementName];
    
    // Description achievement
    UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(88, 69, 172, 71)];
    description.text = [[arrAchievement objectAtIndex:0] objectAtIndex:3];
    description.textColor = [UIColor whiteColor];
    description.backgroundColor = [UIColor clearColor];
    description.editable = NO;
    [description setFont: [UIFont systemFontOfSize:14 ]];
    
    // Text reward
    UILabel *textReward = [[UILabel alloc] initWithFrame:CGRectMake(93, 138, 70, 21)];
    textReward.text = @"Reward :";
    if(self.item_id == 0) {
        textReward.text = @"Reward : -";  
    }
    textReward.textColor = [UIColor whiteColor];
    [textReward setFont: [UIFont systemFontOfSize:14 ]];
    
    // Picture reward
    UIImageView *imageReward = [[UIImageView alloc] initWithFrame:CGRectMake(158, 141, 15, 15)];
    imageReward.image = [UIImage imageNamed:image_reward];
    
    
    // Get reward button
    UIButton *getRewardButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 179, 260, 40)];
    getRewardButton.backgroundColor = [UIColor colorWithRed:(132/255.0) green:(132/255.0) blue:(132/255.0) alpha:1];
    NSString *titleGetReward = @"Get reward";
    if(self.item_id == 0) {
        titleGetReward = @"Get achievement";
    }
    [getRewardButton setTitle:titleGetReward forState:UIControlStateNormal];
    [getRewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getRewardButton addTarget:self action:@selector(getReward:) forControlEvents:UIControlEventTouchUpInside];
    getRewardButton.tag = achievement_id;
    getRewardButton.layer.cornerRadius = 5;
    getRewardButton.layer.masksToBounds = YES;
    
    
    
    [self.ViewReceiveAchievement addSubview:headText];
    [self.ViewReceiveAchievement addSubview:imageAchievement];
    [self.ViewReceiveAchievement addSubview:description];
    [self.ViewReceiveAchievement addSubview:textReward];
    [self.ViewReceiveAchievement addSubview:imageReward];
    [self.ViewReceiveAchievement addSubview:getRewardButton];
    [self.view addSubview:self.ViewReceiveAchievement];
    
    [UIView animateWithDuration:1
                     animations:^{
                         self.ViewReceiveAchievement.alpha = 1;
                     }];
    
    NSLog(@"[showAlertReceiveAchievement :3] End");
}
- (void)getReward:(UIButton *)sender {
    NSLog(@"[getReward :4] Start");
    NSLog(@"achievement_id : %d",(int)sender.tag);
    
    // STEP 1 : Add acievement received in table avatar_achievement
    NSString *query = [NSString stringWithFormat:@"INSERT INTO avatar_achievement (avatar_id, achievement_id) VALUES(%i, %i)", self.avatar_id, (int)sender.tag];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[InsertAvatarAchievement] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"[InsertAvatarAchievement] Could not execute the query.");
    }
    
    
    // STEP 2 : Add item reward in table decoration_item
    
    // Check repeat item in decoration_item
    if (self.item_id != 0) {
        
    
        query = [NSString stringWithFormat:@"SELECT * FROM decoration_item WHERE avatar_id=%d AND item_id=%d",self.avatar_id, self.item_id];
        NSArray *arrDecorationItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSLog(@"arrDecorationItem : %@",arrDecorationItem);
    
        // If not repeat go to add item in decoration_item
        if (arrDecorationItem.count == 0) {
        
            NSLog(@"Not repeat item in decoration_item.");
        
        
            query = [NSString stringWithFormat:@"INSERT INTO decoration_item (avatar_id, item_id, decoration_status) VALUES(%i, %i, 0)", self.avatar_id, self.item_id];
            [self.dbManager executeQuery:query];
        
            if (self.dbManager.affectedRows != 0) {
                NSLog(@"[InsertDecorationItem] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            }
            else{
                NSLog(@"[InsertAvatarAchievement] Could not execute the query.");
            }
        }
        else {
            NSLog(@"Repeat item in decoration_item");
        }
    
    }
    
    // STEP 3 : Hide ViewReceiveAchievement
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.ViewReceiveAchievement.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         NSLog(@"hide view");
                         
                         // Clear subviews
                         NSArray *viewsToRemove = [self.ViewReceiveAchievement subviews];
                         for (UIView *v in viewsToRemove) {
                             [v removeFromSuperview];
                         }
                         
                         // Check requirement again
                         if (self.checkRequirementAgain == YES) {
                             NSLog(@"Repeat check again");
                             self.checkRequirementAgain = NO;
                             [self checkRequirementAchievement];
                         }
                         
                     }];
    
    NSLog(@"[getReward :4] End");
}




@end
