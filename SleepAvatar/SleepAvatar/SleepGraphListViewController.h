//
//  SleepGraphListViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "DBManager.h"

@interface SleepGraphListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ECSlidingViewControllerDelegate>

- (IBAction)menuButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrSleepData;

- (void)loadData;

@end
