//
//  CreateAvatarWearViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/22/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "CreateAvatarWearViewController.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface CreateAvatarWearViewController ()

@property (strong,nonatomic) NSString *avatarType;

@end

@implementation CreateAvatarWearViewController

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
    
    NSLog(@"name : %@, birth : %@, sex : %@",self.user_name,self.user_birthday,self.avatar_sex);
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];
    
    // Set defalut
    self.user_id = 1;
    self.avatar_id = 1;
    self.avatar_size = @"s";
    self.avatar_skin = 1;
    self.shirt = 1;
    self.hair = 1;
    self.codeavatar = @"111";
    self.avatarType = @"Skin color";
    
    
    // ShowAvatar
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
    
    // Set item thumbnail
    [self setItemThumbnail];
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
    NSLog(@"sex : %@, size : %@, skin : %i, shirt : %i, hair : %i, codeavatar : %@",self.avatar_sex,self.avatar_size,self.avatar_skin,self.shirt,self.hair,self.codeavatar);
    
    
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
//                              BUTTON-ITEM-CLICK
// ----------------------------------------------------------------------------


- (IBAction)ButtonItemClick1:(id)sender {
    if ([self.avatarType isEqualToString:@"Skin color"]) {
        self.avatar_skin = 1;
    }
    else if ([self.avatarType isEqualToString:@"Shirt"]) {
        self.shirt = 1;
    }
    else if ([self.avatarType isEqualToString:@"Hair"]) {
        self.hair = 1;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick2:(id)sender {
    if ([self.avatarType isEqualToString:@"Skin color"]) {
        self.avatar_skin = 2;
    }
    else if ([self.avatarType isEqualToString:@"Shirt"]) {
        self.shirt = 2;
    }
    else if ([self.avatarType isEqualToString:@"Hair"]) {
        self.hair = 2;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick3:(id)sender {
    if ([self.avatarType isEqualToString:@"Shirt"]) {
        self.shirt = 3;
    }
    else if ([self.avatarType isEqualToString:@"Hair"]) {
        self.hair = 3;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick4:(id)sender {
    if ([self.avatarType isEqualToString:@"Shirt"]) {
        self.shirt = 4;
    }
    else if ([self.avatarType isEqualToString:@"Hair"]) {
        self.hair = 4;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick5:(id)sender {
    if ([self.avatarType isEqualToString:@"Shirt"] && [self.avatar_sex isEqualToString:@"f"]) {
        self.shirt = 5;
    }
    else if ([self.avatarType isEqualToString:@"Hair"] && [self.avatar_sex isEqualToString:@"m"]) {
        self.hair = 5;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick6:(id)sender {
    if ([self.avatarType isEqualToString:@"Shirt"] && [self.avatar_sex isEqualToString:@"f"]) {
        self.shirt = 6;
    }
    else if ([self.avatarType isEqualToString:@"Hair"] && [self.avatar_sex isEqualToString:@"m"]) {
        self.hair = 6;
    }
    
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair codeavatar:self.codeavatar];
}
- (IBAction)ButtonItemClick7:(id)sender {
}
- (IBAction)ButtonItemClick8:(id)sender {
}










// ----------------------------------------------------------------------------
//                              SET ITEM-THUMBNAIL
// ----------------------------------------------------------------------------

-(void)setItemThumbnail {
    
    // Male
    if ([self.avatar_sex isEqualToString:@"m"]) {
        
        if ([self.avatarType isEqualToString:@"Skin color"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-skin-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-skin-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
        }
        else if ([self.avatarType isEqualToString:@"Shirt"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-m-s-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-m-s-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-m-s-3.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-m-s-4.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
        }
        else if ([self.avatarType isEqualToString:@"Hair"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-3.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-4.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-5.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-m-s-6.png"] forState:UIControlStateNormal];
        }
        
    }
    
    // Female
    else {
        if ([self.avatarType isEqualToString:@"Skin color"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-skin-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-skin-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
        }
        else if ([self.avatarType isEqualToString:@"Shirt"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-3.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-4.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-5.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail-shirt-f-s-6.png"] forState:UIControlStateNormal];
        }
        else if ([self.avatarType isEqualToString:@"Hair"]) {
            
            [self.ButtonItem1 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-f-s-1.png"] forState:UIControlStateNormal];
            [self.ButtonItem2 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-f-s-2.png"] forState:UIControlStateNormal];
            [self.ButtonItem3 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-f-s-3.png"] forState:UIControlStateNormal];
            [self.ButtonItem4 setBackgroundImage:[UIImage imageNamed:@"thumbnail-hair-f-s-4.png"] forState:UIControlStateNormal];
            [self.ButtonItem5 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
            [self.ButtonItem6 setBackgroundImage:[UIImage imageNamed:@"thumbnail.png"] forState:UIControlStateNormal];
        }
    }
    
}









// ----------------------------------------------------------------------------
//                              CHANGE AVATAR-TYPE
// ----------------------------------------------------------------------------

- (IBAction)ButtonChangeTypeLeft:(id)sender {
    if ([self.avatarType isEqualToString:@"Skin color"]) {
        self.LabelType.text = @"Hair";
        self.avatarType = @"Hair";
    }
    else if([self.avatarType isEqualToString:@"Shirt"]) {
        self.LabelType.text = @"Skin color";
        self.avatarType = @"Skin color";
    }
    else if([self.avatarType isEqualToString:@"Hair"]) {
        self.LabelType.text = @"Shirt";
        self.avatarType = @"Shirt";
    }
    [self setItemThumbnail];
}
- (IBAction)ButtonChangeTypeRight:(id)sender {
    if ([self.avatarType isEqualToString:@"Skin color"]) {
        self.LabelType.text = @"Shirt";
        self.avatarType = @"Shirt";
    }
    else if([self.avatarType isEqualToString:@"Shirt"]) {
        self.LabelType.text = @"Hair";
        self.avatarType = @"Hair";
    }
    else if([self.avatarType isEqualToString:@"Hair"]) {
        self.LabelType.text = @"Skin color";
        self.avatarType = @"Skin color";
    }
    [self setItemThumbnail];
}








// ----------------------------------------------------------------------------
//                                  FINISH BUTTON
// ----------------------------------------------------------------------------

- (IBAction)ButtonFinishCreate:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Create avatar"
                                                   message: @"Are you sure for create this avatar?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Pressed button OK
    if (buttonIndex == 1) {
        
        
        
        // STEP 0 : Find shirt_id
        NSString *query = [NSString stringWithFormat:@"SELECT item_id FROM item WHERE item_picture='shirt-%@-%@-%d.png'",self.avatar_sex, self.avatar_size, self.shirt];
        NSArray *arrShirt = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        NSInteger indexOfitem_id = [self.dbManager.arrColumnNames indexOfObject:@"item_id"];
        self.shirt_id = [[[arrShirt objectAtIndex:0] objectAtIndex:indexOfitem_id] intValue];
        
        NSLog(@"Shirt_id : %d",self.shirt_id);
        
        
        
        
        query = [NSString stringWithFormat:@"SELECT item_id FROM item WHERE item_picture='hair-%@-%@-%d.png'",self.avatar_sex, self.avatar_size, self.hair];
        NSArray *arrHair = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
//        NSInteger indexOfitem_id = [self.dbManager.arrColumnNames indexOfObject:@"item_id"];
        self.hair_id = [[[arrHair objectAtIndex:0] objectAtIndex:indexOfitem_id] intValue];
        
        NSLog(@"Hair_id : %d",self.hair_id);
        
        

        
        
        
        
        // STEP 1 : Create User
        query = [NSString stringWithFormat:@"INSERT INTO user (user_name, user_birthday) VALUES ('%@', '%@')", self.user_name, self.user_birthday];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[CreateUser] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[CreateUser]Could not execute the query.");
        }
        
        
        
        // STEP 2 : Create Avatar
        query = [NSString stringWithFormat:@"INSERT INTO avatar (user_id, avatar_sex, avatar_size, avatar_skin) VALUES (%d, '%@', '%@', '%d')", self.user_id, self.avatar_sex, self.avatar_size, self.avatar_skin];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[CreateAvatar] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[CreateAvatar]Could not execute the query.");
        }
        
        
        // STEP 3 : Create decoration_item[Shirt]
        query = [NSString stringWithFormat:@"INSERT INTO decoration_item (avatar_id, item_id, decoration_status) VALUES (%d, %d, 1)", self.avatar_id, self.shirt_id];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[CreateDecorationItemShirt] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[CreateDecorationItemShirt]Could not execute the query.");
        }
        
        
        
        // STEP 4 : Create decoration_item[Hair]
        query = [NSString stringWithFormat:@"INSERT INTO decoration_item (avatar_id, item_id, decoration_status) VALUES (%d, %d, 1)", self.avatar_id, self.hair_id];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[CreateDecorationItemHair] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[CreateDecorationItemHair]Could not execute the query.");
        }
        
        
        ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
}

@end
