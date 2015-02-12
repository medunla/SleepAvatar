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
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// ----------------------------------------------------------------------------
//                                 LOAD DATA
// ----------------------------------------------------------------------------


- (void)loadData {
    
    NSString *query = @"SELECT * FROM sleepData ORDER BY sleepData_id DESC";
    
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
    
    NSInteger indexOfsleepData_date = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_date"];
    NSString *sleepData_date = [[self.arrSleepData objectAtIndex:0] objectAtIndex:indexOfsleepData_date];
    NSArray* arrSleepData_date = [sleepData_date componentsSeparatedByString: @" "];
    
    headerLabel.text = [NSString stringWithFormat:@"%@, %@", [arrSleepData_date objectAtIndex:1], [arrSleepData_date objectAtIndex:2]];
    
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
    
    NSInteger indexOfsleepData_date = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_date"];
    NSInteger indexOfsleepData_duration = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_duration"];
    NSInteger indexOfsleepData_quality = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_quality"];
    
    // Explode date ---------------------------------------------
    NSString *sleepData_date = [[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:indexOfsleepData_date];
    NSArray* arrSleepData_date = [sleepData_date componentsSeparatedByString: @" "];
    
    // Calculate duration from (min) -> (h)(min) ---------------------------------------------
    int durationFull = [  [[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:indexOfsleepData_duration]  intValue];
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
    int quality = [[[self.arrSleepData objectAtIndex:indexPath.row] objectAtIndex:indexOfsleepData_quality] intValue];
    
    
    
    
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

@end
