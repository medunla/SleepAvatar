//
//  ChangeWearViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/26/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "ChangeWearViewController.h"
#import "ECSlidingViewController.h"

@interface ChangeWearViewController ()

@end

@implementation ChangeWearViewController

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
    
    // Set defalut
    self.avatarType = @"Shirt";
    
    
    // ShowAvatar
    [self findAvatarValue];
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair];
    
    // Set item thumbnail
    [self setItemThumbnail];
    
    NSLog(@"height item : %d", (int)self.ViewItem.frame.size.height);
    
    
    for(UIView *subView in self.ViewItem.subviews)
    {
        NSLog(@"subview : %@",subView);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









// ----------------------------------------------------------------------------
//                                 SHOW AVATAR
// ----------------------------------------------------------------------------


-(void)showAvatar:(NSString*)sex size:(NSString*)size skin:(int)skin shirt:(int)shirt hair:(int)hair {
    
    
    // body
    NSString *body_pic = [NSString stringWithFormat:@"body-%@-%@-%i.png", sex, size, skin];
    self.ImageBody.image = [UIImage imageNamed:body_pic];
    
    // shirt
    NSString *shirt_pic = [NSString stringWithFormat:@"shirt-%@-%@-%i.png", sex, size, shirt];
    self.ImageShirt.image = [UIImage imageNamed:shirt_pic];
    
    // emotion-face
    NSString *emotion_face_pic = [NSString stringWithFormat:@"emotion-face-%@-%@-1.png", sex, size];
    self.ImageEmotionFace.image = [UIImage imageNamed:emotion_face_pic];
    
    // shirt
    NSString *hair_pic = [NSString stringWithFormat:@"hair-%@-%@-%i.png", sex, size, hair];
    self.ImageHair.image = [UIImage imageNamed:hair_pic];
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
    
    NSInteger indexOfitem_id = [self.dbManager.arrColumnNames indexOfObject:@"item_id"];
    NSInteger indexOfitem_picture = [self.dbManager.arrColumnNames indexOfObject:@"item_picture"];
    
    NSString *shirt_picture = [[arrShirt objectAtIndex:0] objectAtIndex:indexOfitem_picture];
    NSArray *shirt_picture_explode = [shirt_picture componentsSeparatedByString: @"-"];
    NSArray *shirt_picture_explode2 = [[shirt_picture_explode objectAtIndex:3] componentsSeparatedByString: @"."];
    
    self.shirt = [[shirt_picture_explode2 objectAtIndex:0] intValue];
    self.shirt_id = [[[arrShirt objectAtIndex:0] objectAtIndex:indexOfitem_id] intValue];
    self.shirt_id_temp = self.shirt_id;
    
    NSLog(@"Shirt : %d, Item_id : %d",self.shirt,self.shirt_id);
    
    
    // Hair
    query = [NSString stringWithFormat:@"SELECT * FROM decoration_item INNER JOIN item ON decoration_item.item_id = item.item_id WHERE decoration_item.avatar_id =%i AND decoration_item.decoration_status = 1 AND item.item_type='hair'",self.avatar_id];
    NSArray *arrHair = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //    NSInteger indexOfitem_picture = [self.dbManager.arrColumnNames indexOfObject:@"item_picture"];
    
    NSString *hair_picture = [[arrHair objectAtIndex:0] objectAtIndex:indexOfitem_picture];
    NSArray *hair_picture_explode = [hair_picture componentsSeparatedByString: @"-"];
    NSArray *hair_picture_explode2 = [[hair_picture_explode objectAtIndex:3] componentsSeparatedByString: @"."];
    
    self.hair = [[hair_picture_explode2 objectAtIndex:0] intValue];
    self.hair_id = [[[arrHair objectAtIndex:0] objectAtIndex:indexOfitem_id] intValue];
    self.hair_id_temp = self.hair_id;
    
    NSLog(@"Hair : %d, Item_id : %d",self.hair,self.hair_id);

    
}








// ----------------------------------------------------------------------------
//                              CHANGE AVATAR-TYPE
// ----------------------------------------------------------------------------

- (IBAction)ButtonChangeTypeLeft:(id)sender {
    if([self.avatarType isEqualToString:@"Shirt"]) {
        self.LabelType.text = @"Hair";
        self.avatarType = @"Hair";
    }
    else if([self.avatarType isEqualToString:@"Hair"]) {
        self.LabelType.text = @"Shirt";
        self.avatarType = @"Shirt";
    }
    [self setItemThumbnail];
}
- (IBAction)ButtonChangeTypeRight:(id)sender {
    if([self.avatarType isEqualToString:@"Shirt"]) {
        self.LabelType.text = @"Hair";
        self.avatarType = @"Hair";
    }
    else if([self.avatarType isEqualToString:@"Hair"]) {
        self.LabelType.text = @"Shirt";
        self.avatarType = @"Shirt";
    }
    [self setItemThumbnail];
}









// ----------------------------------------------------------------------------
//                              SET ITEM-THUMBNAIL
// ----------------------------------------------------------------------------

-(void)setItemThumbnail {
    NSLog(@"setItemThumbnail");
    
    
    // STEP 0 : Clear old button
    NSArray *viewsToRemove = [self.ViewItem subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    
    
    
    // STEP 1 : Convert avatarType
    NSString *type = @"";
    if ([self.avatarType isEqualToString:@"Shirt"]) {
        type = @"shirt";
    }
    else if([self.avatarType isEqualToString:@"Hair"]) {
        type = @"hair";
    }
    

    
    // STEP 2 : Get item_id from type
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM decoration_item INNER JOIN item ON decoration_item.item_id = item.item_id WHERE decoration_item.avatar_id =%i AND item.item_type='%@'",self.avatar_id,type];
    NSArray *arrItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfitem_id = [self.dbManager.arrColumnNames indexOfObject:@"item_id"];
    NSInteger indexOfitem_thumbnail = [self.dbManager.arrColumnNames indexOfObject:@"item_thumbnail"];
    NSInteger indexOfdecoration_status = [self.dbManager.arrColumnNames indexOfObject:@"decoration_status"];
    
    NSLog(@"count : %d",(int)arrItem.count);
    NSLog(@"%@",arrItem);
    
    NSLog(@"=======");
    
    int item_id = 0;
    NSString *item_thumbnail = @"";
    int decoration_status = 0;
    for (int i=0; i<arrItem.count; i++) {
        
        // Get item_id, item_picture, decoration_status
        item_id = [[[arrItem objectAtIndex:i] objectAtIndex:indexOfitem_id] intValue];
        item_thumbnail = [[arrItem objectAtIndex:i] objectAtIndex:indexOfitem_thumbnail];
        decoration_status = [[[arrItem objectAtIndex:i] objectAtIndex:indexOfdecoration_status] intValue];
        
        
        NSLog(@"item_id : %d, item_thumbnal : %@, decoration_status : %d",item_id,item_thumbnail,decoration_status);
        
        // Create Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(ButtonItemClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:item_thumbnail] forState:UIControlStateNormal];
        button.frame = CGRectMake(80*(i%4), (80*(i/4)), 79, 79);
//        button.frame = CGRectMake(0, 408, 79, 79);
        NSLog(@"height item : %d, %d - %d, %d",(int)self.ViewItem.frame.origin.x,(int)self.ViewItem.frame.origin.y, (int)self.ViewItem.frame.size.width,(int)self.ViewItem.frame.size.height);
        NSLog(@"button position : %d, %d - %d, %d", (int)button.frame.origin.x,(int)button.frame.origin.y, (int)button.frame.size.width,(int)button.frame.size.height);
        [button setTag:item_id];
        button.alpha = 1;
        if (decoration_status == 1) {
            button.alpha = 0.5;
        }
        [self.ViewItem addSubview:button];
        
        
    }
    
    
    
    // STEP 3 : Set content size
    if (arrItem.count>8) {
        NSLog(@"set contentsize");
        NSLog(@"count item: %d",(int)arrItem.count);
        int round_int       = (int)arrItem.count/4;
        double round_double = arrItem.count/4.0;
        
        NSLog(@"roundint: %d",round_int);
        NSLog(@"rounddouble: %f",round_double);
        
        if (round_double>round_int) {
            round_int++;
            NSLog(@"roundint++ = %d",round_int);
        }
        NSLog(@"size:%d",80*round_int);
        
#warning height view item
        for(NSLayoutConstraint *constraint in self.ViewItem.constraints)
        {
            if(constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 80*round_int;
            }
        }
        NSLog(@"height item : %d, %d - %d, %d",(int)self.ViewItem.frame.origin.x,(int)self.ViewItem.frame.origin.y, (int)self.ViewItem.frame.size.width,(int)self.ViewItem.frame.size.height);
        
    }
    else {
        for(NSLayoutConstraint *constraint in self.ViewItem.constraints)
        {
            if(constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 160;
            }
        }
    }
    
}





// ----------------------------------------------------------------------------
//                              BUTTON ITEM-CLICK
// ----------------------------------------------------------------------------


-(void)ButtonItemClick:(UIButton *)sender {
    int item_id = (int)sender.tag;
    
    // STEP 1 : Find item_picture, item_type
    NSString *query = [NSString stringWithFormat:@"SELECT item_picture,item_type FROM item WHERE item_id = %d",item_id];
    NSArray *arrItem = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfitem_picture = [self.dbManager.arrColumnNames indexOfObject:@"item_picture"];
    NSInteger indexOfitem_type = [self.dbManager.arrColumnNames indexOfObject:@"item_type"];
    
    NSString *item_picture = [[arrItem objectAtIndex:0] objectAtIndex:indexOfitem_picture];
    NSArray *item_picture_explode = [item_picture componentsSeparatedByString: @"-"];
    NSArray *item_picture_explode2 = [[item_picture_explode objectAtIndex:3] componentsSeparatedByString: @"."];
    NSString *item_type = [[arrItem objectAtIndex:0] objectAtIndex:indexOfitem_type];
    
    NSLog(@"item_id : %d, item_picture : %@, item_type : %@, item_picture_explode : %@",item_id, item_picture,item_type, [item_picture_explode2 objectAtIndex:0]);
    
    
    
    // STEP 2 : Set in avatar
    if ([item_type isEqualToString:@"shirt"]) {
        self.shirt = [[item_picture_explode2 objectAtIndex:0] intValue];
        self.shirt_id = item_id;
    }
    else if ([item_type isEqualToString:@"hair"]) {
        self.hair = [[item_picture_explode2 objectAtIndex:0] intValue];
        self.hair_id = item_id;
    }
    [self showAvatar:self.avatar_sex size:self.avatar_size skin:self.avatar_skin shirt:self.shirt hair:self.hair];
    
    
    // STEP 3 : Change opacity
    
    // Set opacity = 1 all item
    NSArray *subview = [self.ViewItem subviews];
    for (UIView *v in subview) {
        v.alpha = 1;
    }
    // Set opacity = 0.5 in click button
    sender.alpha = 0.5;
    
    
}








// ----------------------------------------------------------------------------
//                                  FINISH BUTTON
// ----------------------------------------------------------------------------

- (IBAction)ButtonFinishCreate:(id)sender {
    
    // Update Decoration_item in db
    NSString *query;
    
    
    // Shirt
    if (self.shirt_id_temp != self.shirt_id) {
        
        // STEP 1 : change decoration_status old item to 0(false)
        query = [NSString stringWithFormat:@"UPDATE decoration_item SET decoration_status = 0 WHERE avatar_id = %d AND item_id = %d", self.avatar_id, self.shirt_id_temp];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[changeWearShirtOld] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[changeWearShirtOld]Could not execute the query.");
        }
        
        
        
        // STEP 2 : change decoration_status new item to 1(true)
        query = [NSString stringWithFormat:@"UPDATE decoration_item SET decoration_status = 1 WHERE avatar_id = %d AND item_id = %d", self.avatar_id, self.shirt_id];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[changeWearShirtNew] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[changeWearShirtNew]Could not execute the query.");
        }
        
    }
    
    // Hair
    if (self.hair_id_temp != self.hair_id) {
        
        // STEP 1 : change decoration_status old item to 0(false)
        query = [NSString stringWithFormat:@"UPDATE decoration_item SET decoration_status = 0 WHERE avatar_id = %d AND item_id = %d", self.avatar_id, self.hair_id_temp];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[changeWearHairOld] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[changeWearHairOld]Could not execute the query.");
        }
        
        
        
        // STEP 2 : change decoration_status new item to 1(true)
        query = [NSString stringWithFormat:@"UPDATE decoration_item SET decoration_status = 1 WHERE avatar_id = %d AND item_id = %d", self.avatar_id, self.hair_id];
        NSLog(@"sql : %@",query);
        [self.dbManager executeQuery:query];
        
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"[changeWearHairNew] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"[changeWearHairNew]Could not execute the query.");
        }
        
    }
    
    
    
    ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}



- (IBAction)ButtonBack:(id)sender {
    ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:vc animated:YES completion:nil];
}







- (IBAction)addWear:(id)sender {
    NSString* query = [NSString stringWithFormat:@"INSERT INTO decoration_item (avatar_id, item_id, decoration_status) VALUES(%i, 18, 0)", self.avatar_id];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[InsertDecorationItem] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"[InsertDecorationItem] Could not execute the query.");
    }
    
    query = [NSString stringWithFormat:@"INSERT INTO decoration_item (avatar_id, item_id, decoration_status) VALUES(%i, 19, 0)", self.avatar_id];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[InsertDecorationItem] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"[InsertDecorationItem] Could not execute the query.");
    }
    
    
    
}

@end
