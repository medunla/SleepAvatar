//
//  SleepGraphDetailViewController.h
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "SimpleBarChart.h"

@interface SleepGraphDetailViewController : UIViewController <SimpleBarChartDataSource, SimpleBarChartDelegate>

@property (nonatomic, strong) NSArray *arrSleepData;
@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UIView *ViewQualityGraph;
@property (weak, nonatomic) IBOutlet UILabel *labelQuality;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeStartToTimeEnd;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelLatency;
@property (weak, nonatomic) IBOutlet UILabel *labelDeepPer;
@property (weak, nonatomic) IBOutlet UILabel *labelLightPer;
@property (weak, nonatomic) IBOutlet UILabel *labelAwakePer;
@property (weak, nonatomic) IBOutlet UILabel *labelDeepDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelLightDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelAwakeDuration;
@property (weak, nonatomic) IBOutlet UIView *ViewGraph;
@property (weak, nonatomic) IBOutlet UIView *ViewGraphText;


@end
