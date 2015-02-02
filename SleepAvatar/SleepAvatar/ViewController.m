//
//  ViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sql"];
    
    
    
    // STEP 1 : Query db
    NSString *query = @"SELECT * FROM user";
    
    if (self.arrUser != nil) {
        self.arrUser = nil;
    }
    self.arrUser = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"count:%i",[self.arrUser count]);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
