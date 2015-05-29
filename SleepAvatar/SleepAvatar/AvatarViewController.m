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
@property (nonatomic) int avatar_id;
@property (strong,nonatomic) NSString *avatar_sex;
@property (strong,nonatomic) NSString *avatar_size;
@property (nonatomic) int avatar_skin;
@property (nonatomic) int shirt;
@property (nonatomic) int hair;
@property (strong,nonatomic) NSString *codeavatar;
@property (nonatomic, strong) NSLayoutConstraint *constraintTop;


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
    [self.ViewAvatar addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];
    
    
    // Set border
    self.ViewButtonSummarySleep.layer.cornerRadius = 2.5;
    self.ViewButtonSummarySleep.layer.masksToBounds = YES;
    
    
    // Set Show/Hide viewSummarySleep
    UISwipeGestureRecognizer *slideShowViewSummary = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showViewSummary:)];
    slideShowViewSummary.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *slideHideViewSummary = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewSummary:)];
    slideHideViewSummary.direction = UISwipeGestureRecognizerDirectionUp;
    [self.ButtonSummarySleep addGestureRecognizer:slideShowViewSummary];
    [self.ButtonSummarySleep addGestureRecognizer:slideHideViewSummary];

    
    
    
    
    // Set NSUserDefaults
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // First Setting
    if ([self.defaults objectForKey:@"statusViewSummarys"] == NULL) {
        [self.defaults setBool:YES forKey:@"statusViewSummarys"];
        [self.defaults synchronize];
    }
    
    // Set constraints
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    self.ViewSummaySleep.translatesAutoresizingMaskIntoConstraints = NO;
    
    if ([[self.defaults objectForKey:@"statusViewSummarys"] intValue] == 1) {
        [self showViewSummaryCode:0];
        NSLog(@"1");
        self.constraintTop =[NSLayoutConstraint constraintWithItem:self.ViewSummaySleep attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ViewWrapSummary attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
        [self.view addConstraint:self.constraintTop];
        [self showViewSummaryCode:0.0];
    }
    else {
        NSLog(@"2");
        self.constraintTop =[NSLayoutConstraint constraintWithItem:self.ViewSummaySleep attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.ViewWrapSummary attribute:NSLayoutAttributeTop multiplier:1.0 constant:-81.0f];
        [self.view addConstraint:self.constraintTop];
        [self hideViewSummaryCode:0.0];
        
//        self.ViewSummaySleep.backgroundColor = [UIColor clearColor];
//        [self.defaults setBool:NO forKey:@"statusViewSummarys"];
//        [self.defaults synchronize];
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self findAvatarValue];
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
    [self calculateSummarySleep];
    
    
    
    
    
    
    
    
}






// ----------------------------------------------------------------------------
//                                 SHOW AVATAR
// ----------------------------------------------------------------------------


-(void)showAvatar:(NSString*)sex size:(NSString*)size skin:(int)skin shirt:(int)shirt hair:(int)hair codeavatar:(NSString*)codeavatar {
    
    
    // body
    NSString *body_pic = [NSString stringWithFormat:@"body-%@-%@-%i.png", sex, size, skin];
    self.ImageBody.image = [UIImage imageNamed:body_pic];
    
    // shirt
    NSString *shirt_pic = [NSString stringWithFormat:@"shirt-%@-%@-%i.png", sex, size, shirt];
    self.ImageShirt.image = [UIImage imageNamed:shirt_pic];
    
    // emotion-face
    NSString *emotion_face_pic = [NSString stringWithFormat:@"emotion-face-%@-%@-%@.png", sex, size,  codeavatar];
    self.ImageEmotionFace.image = [UIImage imageNamed:emotion_face_pic];
    
    // shirt
    NSString *hair_pic = [NSString stringWithFormat:@"hair-%@-%@-%i.png", sex, size, hair];
    self.ImageHair.image = [UIImage imageNamed:hair_pic];
    
    // emotion-element
    NSString *emotion_element_pic = [NSString stringWithFormat:@"emotion-element-%@.png", codeavatar];
    self.ImageEmotionElement.image = [UIImage imageNamed:emotion_element_pic];
}








// ----------------------------------------------------------------------------
//                              FIND AVATAR VALUE
// ----------------------------------------------------------------------------

- (void)findAvatarValue {
    
    // Id, Sex, Size, Skin
    NSString *query = @"SELECT * FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    NSArray *arrAvatar = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];
    NSInteger indexOfavatar_sex = [self.dbManager.arrColumnNames indexOfObject:@"avatar_sex"];
    NSInteger indexOfavatar_size = [self.dbManager.arrColumnNames indexOfObject:@"avatar_size"];
    NSInteger indexOfavatar_skin = [self.dbManager.arrColumnNames indexOfObject:@"avatar_skin"];
    
    self.avatar_id = [[[arrAvatar objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];
    self.avatar_sex = [[arrAvatar objectAtIndex:0] objectAtIndex:indexOfavatar_sex];
    self.avatar_size = [[arrAvatar objectAtIndex:0] objectAtIndex:indexOfavatar_size];
    self.avatar_skin = [[[arrAvatar objectAtIndex:0] objectAtIndex:indexOfavatar_skin] intValue];
    
    
    
    
    
    // Shirt
    query = [NSString stringWithFormat:@"SELECT * FROM decoration_item INNER JOIN item ON decoration_item.item_id = item.item_id WHERE decoration_item.avatar_id =%i AND decoration_item.decoration_status = 1 AND item.item_type='shirt'",self.avatar_id];
    NSArray *arrShirt = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfitem_picture = [self.dbManager.arrColumnNames indexOfObject:@"item_picture"];

    NSString *shirt_picture = [[arrShirt objectAtIndex:0] objectAtIndex:indexOfitem_picture];
    NSArray *shirt_picture_explode = [shirt_picture componentsSeparatedByString: @"-"];
    NSArray *shirt_picture_explode2 = [[shirt_picture_explode objectAtIndex:3] componentsSeparatedByString: @"."];
    
    self.shirt = [[shirt_picture_explode2 objectAtIndex:0] intValue];
//    self.shirt = 3;
    
    
    
    // Hair
    query = [NSString stringWithFormat:@"SELECT * FROM decoration_item INNER JOIN item ON decoration_item.item_id = item.item_id WHERE decoration_item.avatar_id =%i AND decoration_item.decoration_status = 1 AND item.item_type='hair'",self.avatar_id];
    NSArray *arrHair = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
//    NSInteger indexOfitem_picture = [self.dbManager.arrColumnNames indexOfObject:@"item_picture"];
    
    NSString *hair_picture = [[arrHair objectAtIndex:0] objectAtIndex:indexOfitem_picture];
    NSArray *hair_picture_explode = [hair_picture componentsSeparatedByString: @"-"];
    NSArray *hair_picture_explode2 = [[hair_picture_explode objectAtIndex:3] componentsSeparatedByString: @"."];
    
    self.hair = [[hair_picture_explode2 objectAtIndex:0] intValue];
    
//    self.hair = 2;
    
    
    
    
    // Codeavatar
    query = @"SELECT sleepData_codeavatar FROM sleepData ORDER BY sleepData_id DESC LIMIT 1";
    
    NSArray *arrCodeAvatar = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([arrCodeAvatar count] == 0) {
        self.codeavatar = @"1";
    }
    else {
        NSInteger indexOfsleepData_codeavatar = [self.dbManager.arrColumnNames indexOfObject:@"sleepData_codeavatar"];
        self.codeavatar = [[arrCodeAvatar objectAtIndex:0] objectAtIndex:indexOfsleepData_codeavatar];
        
        
        // 1
        if      ([self.codeavatar isEqualToString:@"111"]) { self.codeavatar = @"1"; }
        else if ([self.codeavatar isEqualToString:@"112"]) { self.codeavatar = @"1"; }
        else if ([self.codeavatar isEqualToString:@"113"]) { self.codeavatar = @"1"; }
        else if ([self.codeavatar isEqualToString:@"121"]) { self.codeavatar = @"1"; }
        else if ([self.codeavatar isEqualToString:@"131"]) { self.codeavatar = @"1"; }
        
        //2
        else if ([self.codeavatar isEqualToString:@"122"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"123"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"132"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"133"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"222"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"223"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"232"]) { self.codeavatar = @"2"; }
        else if ([self.codeavatar isEqualToString:@"233"]) { self.codeavatar = @"2"; }
        
        //3
        else if ([self.codeavatar isEqualToString:@"211"]) { self.codeavatar = @"3"; }
        else if ([self.codeavatar isEqualToString:@"212"]) { self.codeavatar = @"3"; }
        else if ([self.codeavatar isEqualToString:@"213"]) { self.codeavatar = @"3"; }
        else if ([self.codeavatar isEqualToString:@"221"]) { self.codeavatar = @"3"; }
        else if ([self.codeavatar isEqualToString:@"231"]) { self.codeavatar = @"3"; }
        
        //4
        else if ([self.codeavatar isEqualToString:@"311"]) { self.codeavatar = @"4"; }
        else if ([self.codeavatar isEqualToString:@"312"]) { self.codeavatar = @"4"; }
        else if ([self.codeavatar isEqualToString:@"321"]) { self.codeavatar = @"4"; }
        else if ([self.codeavatar isEqualToString:@"322"]) { self.codeavatar = @"4"; }
        
        //5
        else if ([self.codeavatar isEqualToString:@"331"]) { self.codeavatar = @"5"; }
        else if ([self.codeavatar isEqualToString:@"332"]) { self.codeavatar = @"5"; }
        else if ([self.codeavatar isEqualToString:@"313"]) { self.codeavatar = @"5"; }
        else if ([self.codeavatar isEqualToString:@"323"]) { self.codeavatar = @"5"; }
        else if ([self.codeavatar isEqualToString:@"333"]) { self.codeavatar = @"5"; }
        
        //6
        else if ([self.codeavatar isEqualToString:@"411"]) { self.codeavatar = @"6"; }
        else if ([self.codeavatar isEqualToString:@"421"]) { self.codeavatar = @"6"; }
        else if ([self.codeavatar isEqualToString:@"412"]) { self.codeavatar = @"6"; }
        else if ([self.codeavatar isEqualToString:@"422"]) { self.codeavatar = @"6"; }
        
        //7
        else if ([self.codeavatar isEqualToString:@"431"]) { self.codeavatar = @"7"; }
        else if ([self.codeavatar isEqualToString:@"432"]) { self.codeavatar = @"7"; }
        else if ([self.codeavatar isEqualToString:@"413"]) { self.codeavatar = @"7"; }
        else if ([self.codeavatar isEqualToString:@"423"]) { self.codeavatar = @"7"; }
        else if ([self.codeavatar isEqualToString:@"433"]) { self.codeavatar = @"7"; }
        else { self.codeavatar = @"7"; }
    }
    
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










// ----------------------------------------------------------------------------
//                            CALCULATE VIEW-SUMMARY
// ----------------------------------------------------------------------------
- (void)calculateSummarySleep {

    // STEP 1 : Get information sleepData
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM sleepData WHERE Avatar_id = %d",self.avatar_id];
    NSArray *arrSleepData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    
    // STEP 2 : Caluclate information
    int quality  = 0;
    int duration = 0;
    int latency  = 0;
    NSString *quality_  = @"0%";
    NSString *duration_ = @"0 min";
    NSString *latency_  = @"0 min";
    
    if (arrSleepData.count > 0) {
        for (id data in arrSleepData) {
            quality  += [[data objectAtIndex:6] integerValue];
            duration += [[data objectAtIndex:7] integerValue];
            latency  += [[data objectAtIndex:5] integerValue];
        }
        NSLog(@"Sum quality: %d",quality);
        NSLog(@"Sum duration: %d",duration);
        NSLog(@"Sum latency: %d",latency);
        
        
        // Avg
        quality  = quality/arrSleepData.count;
        duration = duration/arrSleepData.count;
        latency  = latency/arrSleepData.count;
        
        NSLog(@"Avg quality: %d",quality);
        NSLog(@"Avg duration: %d",duration);
        NSLog(@"Avg latency: %d",latency);
        
        
        // Set value in text
        // quailty
        quality_ = [NSString stringWithFormat:@"%d%%",quality];
        // duration
        if (duration>=60) {
            duration_ = [NSString stringWithFormat:@"%dh %dmin",duration/60,duration-((duration/60)*60) ];
        }
        else {
            duration_ = [NSString stringWithFormat:@"%d min",duration];
        }
        // latency
        if (latency>=60) {
            latency_ = [NSString stringWithFormat:@"%dh %dmin",latency/60,latency-((latency/60)*60) ];
        }
        else {
            latency_ = [NSString stringWithFormat:@"%d min",latency];
        }
        
    }
    
    
    
    // STEP 3 : Set value into label
    self.labelQuality.text  = quality_;
    self.labelDuration.text = duration_;
    self.labelLatency.text  = latency_;
    
}









// ----------------------------------------------------------------------------
//                            SHOW/HIDE VIEW-SUMMARY
// ----------------------------------------------------------------------------

- (IBAction)ButtonSummary:(id)sender {
    NSLog(@"Click : %i",[[self.defaults objectForKey:@"statusViewSummarys"] intValue]);
    
    if ([[self.defaults objectForKey:@"statusViewSummarys"] intValue] == 0) {
        self.constraintTop.constant = 0.0f;
        [self showViewSummaryCode:0.25];
    }
    else {
        self.constraintTop.constant = -81.0f;
        [self hideViewSummaryCode:0.25];
    }
    
}

-(void)showViewSummary:(UISwipeGestureRecognizer *)gestureRecognizer{
    self.constraintTop.constant = 0.0f;
    [self showViewSummaryCode:0.25];
}
-(void)hideViewSummary:(UISwipeGestureRecognizer *)gestureRecognizer{
    self.constraintTop.constant = -81.0f;
    [self hideViewSummaryCode:0.25];
    
}

-(void)showViewSummaryCode:(NSTimeInterval)duration {
//    for(NSLayoutConstraint *constraint in self.ViewWrapSummary.constraints)
//    {
//        if(constraint.firstAttribute == NSLayoutAttributeTop) {
//            constraint.constant = 0;
//        }
//    }
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
//                         [self.ViewSummaySleep setFrame:CGRectMake(0, 0, 320, 106)];
                         self.ViewSummaySleep.backgroundColor = [UIColor colorWithRed:(26/255.0) green:(32/255.0) blue:(44/255.0) alpha:0.8];
                     }];
    [self.defaults setBool:YES forKey:@"statusViewSummarys"];
    [self.defaults synchronize];
    
}
-(void)hideViewSummaryCode:(NSTimeInterval)duration {
//    for(NSLayoutConstraint *constraint in self.ViewWrapSummary.constraints)
//    {
//        if(constraint.firstAttribute == NSLayoutAttributeTop) {
//            constraint.constant = 0;
//        }
//    }
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
//                         [self.ViewSummaySleep setFrame:CGRectMake(0, -81, 320, 106)];
                         self.ViewSummaySleep.backgroundColor = [UIColor clearColor];
                     }];
    [self.defaults setBool:NO forKey:@"statusViewSummarys"];
    [self.defaults synchronize];
    
}


@end
