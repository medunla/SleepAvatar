//
//  StartSleepDetectTableViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 1/16/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface StartSleepDetectTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

- (void)loadData;
- (void)addData;

@end
