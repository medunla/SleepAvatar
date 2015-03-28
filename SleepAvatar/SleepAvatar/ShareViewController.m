//
//  ShareViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/27/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "ShareViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];
    
    [self findAvatarValue];
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
    [self calculateSummarySleep];

    
    
    // Set border
    self.ButtonShareOutlet.layer.cornerRadius = 5;
    self.ButtonShareOutlet.layer.masksToBounds = YES;
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//                         CALCULATE VIEW-SUMMARY & Date
// ----------------------------------------------------------------------------
- (void)calculateSummarySleep {
    
    // STEP 1 : Get information sleepData
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM sleepData WHERE Avatar_id = %d ORDER BY sleepData_id DESC LIMIT 1",self.avatar_id];
    NSArray *arrSleepData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    
    // STEP 2 : Caluclate information
    int quality  = 0;
    int duration = 0;
    int latency  = 0;
    NSString *quality_  = @"0%";
    NSString *duration_ = @"0 min";
    NSString *latency_  = @"0 min";
    NSString *date      = @"";
    NSArray *arrDate;
    
    if (arrSleepData.count > 0) {
        for (id data in arrSleepData) {
            quality  += [[data objectAtIndex:6] integerValue];
            duration += [[data objectAtIndex:7] integerValue];
            latency  += [[data objectAtIndex:5] integerValue];
            date      = [data objectAtIndex:2];
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
        // date
        arrDate = [date componentsSeparatedByString: @" "];
        date = [NSString stringWithFormat:@"%@ %@, %@",
                [arrDate objectAtIndex:0],
                [[arrDate objectAtIndex:1] substringWithRange:NSMakeRange(0,3)],
                [arrDate objectAtIndex:2]];
    }
    
    
    
    // STEP 3 : Set value into label
    self.labelQuality.text  = quality_;
    self.labelDuration.text = duration_;
    self.labelLatency.text  = latency_;
    self.labelDate.text     = date;
    
}










// ----------------------------------------------------------------------------
//                                BUTTON SHARE
// ----------------------------------------------------------------------------

- (IBAction)ButtonShare:(id)sender {
    
    // STEP 1 : Capture photo
    [self.ImageViewShare addSubview:self.ImageBody];
    [self.ImageViewShare addSubview:self.ImageShirt];
    [self.ImageViewShare addSubview:self.ImageEmotionFace];
    [self.ImageViewShare addSubview:self.ImageHair];
    [self.ImageViewShare addSubview:self.ImageEmotionElement];
    [self.ImageViewShare addSubview:self.ViewSummary];
    [self.ImageViewShare addSubview:self.ViewDate];
    
    UIImage *imageShare = [self createImage:self.ImageViewShare];
    
    
    // STEP 2 : Share
    SLComposeViewController * fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
//    [fbSheetOBJ setInitialText:@"#SleepAvatar"];
    [fbSheetOBJ addImage:imageShare];
    
    [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    
    [fbSheetOBJ setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result)
         {
             case SLComposeViewControllerResultCancelled:
             {
                 NSLog(@"Facebook Share Photo :: Calcelled");
             }
                 break;
             case SLComposeViewControllerResultDone:
             {
                 NSLog(@"Facebook Share Photo :: Success");
                 [self.navigationController popViewControllerAnimated:YES];
             }
                 break;
             default:
                 break;
         }
     }];
    
    
    
    
}










// ----------------------------------------------------------------------------
//                               CAPTURE IMAGE
// ----------------------------------------------------------------------------

-(UIImage *)createImage:(UIImageView *)imageView
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:context];
    UIImage *imgs = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgs;
}










// ----------------------------------------------------------------------------
//                               BUTTON LEFT-MENU
// ----------------------------------------------------------------------------


- (IBAction)menuButtonTapped:(id)sender {
    ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
