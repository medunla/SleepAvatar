//
//  SleepGraphDetailViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "SleepGraphDetailViewController.h"
#import "SHPieChartView.h"

@interface SleepGraphDetailViewController ()

@property (strong,nonatomic) NSArray *arrGraph;
@property (assign,nonatomic) NSInteger arrGraphCount;
@property (strong,nonatomic) NSArray *arrDay;
@property (strong,nonatomic) SimpleBarChart *chart;
@property (strong,nonatomic) NSArray *barColors;
@property (assign,nonatomic) NSInteger currentBarColor;

@end

@implementation SleepGraphDetailViewController

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
    
    // STEP 1 : Get value
    
    // Date ---------------------------------------------
    NSString *date    = [self.arrSleepData objectAtIndex:2];
    NSArray* arr_date  = [date componentsSeparatedByString: @" "];
    
    
    // TimeStart & TimeEnd ---------------------------------------------
    NSString *timestart = [self.arrSleepData objectAtIndex:3];
    NSString *timeend   = [self.arrSleepData objectAtIndex:4];
    
    
    // Latency ---------------------------------------------
    int latency = [[self.arrSleepData objectAtIndex:5] intValue];
    NSString *latencyText;
    if (latency>=60) {
        int hour = latency/60;
        int min = latency-(hour*60);
        latencyText = [NSString stringWithFormat:@"%dh %dmin",hour, min];
    }
    else {
        latencyText = [NSString stringWithFormat:@"%dmin",latency];
    }
    
    
    // Quality ---------------------------------------------
    int quality = [[self.arrSleepData objectAtIndex:6] intValue];
    
    
    // Duration ---------------------------------------------
    int duration = [ [self.arrSleepData objectAtIndex:7]  intValue];
    NSString *durationText;
    NSLog(@"duration : %i, %@",duration,durationText);
    
    if (duration>=60) {
        int durationHour = duration/60;
        int durationMin = duration-(durationHour*60);
        durationText = [NSString stringWithFormat:@"%dh %dmin",durationHour,durationMin];
    }
    else {
        durationText = [NSString stringWithFormat:@"%dmin",duration];
    }
    
    
    // Duration Deep ---------------------------------------------
    int durationdeep = [ [self.arrSleepData objectAtIndex:8]  intValue];
    int durationdeepPer = (durationdeep*100)/duration;
    NSString *durationdeepText;
    
    
    if (durationdeep>=60) {
        int durationHour = duration/60;
        int durationMin = durationdeep-(durationHour*60);
        durationdeepText = [NSString stringWithFormat:@"%dh %dmin",durationHour,durationMin];
    }
    else {
        durationdeepText = [NSString stringWithFormat:@"%dmin",durationdeep];
    }
    
    NSLog(@"durationdeep : %i, %i, %@",durationdeep, durationdeepPer, durationdeepText);
    
    
    // Duration Light ---------------------------------------------
    int durationlight = [ [self.arrSleepData objectAtIndex:9]  intValue];
    int durationlightPer = (durationlight*100)/duration;
    NSString *durationlightText;
    
    
    if (durationlight>=60) {
        int durationHour = duration/60;
        int durationMin = durationlight-(durationHour*60);
        durationlightText = [NSString stringWithFormat:@"%dh %dmin",durationHour,durationMin];
    }
    else {
        durationlightText = [NSString stringWithFormat:@"%dmin",durationlight];
    }
    
    NSLog(@"durationlight : %i, %i, %@",durationlight, durationlightPer, durationlightText);
    
    
    // Duration Awake ---------------------------------------------
    int durationawake = duration-(durationdeep+durationlight);
    int durationawakePer = (durationawake*100)/duration;
    NSString *durationawakeText;
    
    
    if (durationawake>=60) {
        int durationHour = duration/60;
        int durationMin = durationawake-(durationHour*60);
        durationawakeText = [NSString stringWithFormat:@"%dh %dmin",durationHour,durationMin];
    }
    else {
        durationawakeText = [NSString stringWithFormat:@"%dmin",durationawake];
    }
    
    NSLog(@"durationawake : %i, %i, %@",durationawake, durationawakePer, durationawakeText);
    
    
    
    
    // STEP 2 : Set to label
    
    // Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@ %@",[arr_date objectAtIndex: 0] ,[arr_date objectAtIndex: 1], [arr_date objectAtIndex: 2] ];
    
    //    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-menu.png"]]];
    //    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-back-text.png"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = btn;
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    // Quality
    self.labelQuality.text = [NSString stringWithFormat:@"%d%%",quality];
    [self createQualityGraph:quality];
    
    // Time start-end
    self.labelTimeStartToTimeEnd.text = [NSString stringWithFormat:@"%@ - %@",timestart, timeend];
    
    // Duration
    self.labelDuration.text = [NSString stringWithFormat:@"%@",durationText];
    
    // Latency
    self.labelLatency.text = [NSString stringWithFormat:@"%@",latencyText];
    
    // Deep sleep
    self.labelDeepPer.text = [NSString stringWithFormat:@"%d%%",durationdeepPer];
    self.labelDeepDuration.text = [NSString stringWithFormat:@"%@",durationdeepText];
    
    
    // Light sleep
    self.labelLightPer.text = [NSString stringWithFormat:@"%d%%",durationlightPer];
    self.labelLightDuration.text = [NSString stringWithFormat:@"%@",durationlightText];
    
    
    // Awake
    self.labelAwakePer.text = [NSString stringWithFormat:@"%d%%",durationawakePer];
    self.labelAwakeDuration.text = [NSString stringWithFormat:@"%@",durationawakeText];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [self.chart reloadData];
}




// ----------------------------------------------------------------------------
//                                  PIE GRAPH
// ----------------------------------------------------------------------------


- (void)createQualityGraph:(int)quality {
    float angle = (float)quality/100;
    NSLog(@"angle:%f",angle);
    
    SHPieChartView *concentricPieChart = [[SHPieChartView alloc] initWithFrame:CGRectMake(0, 0, 97, 97)];
    concentricPieChart.isConcentric = YES;
    concentricPieChart.concentricRadius = 38;
    // BG for translate
    concentricPieChart.concentricColor = [UIColor colorWithRed:(26/255.0) green:(32/255.0) blue:(44/255.0) alpha:1.0];
    // BG graph not use
    concentricPieChart.chartBackgroundColor = [UIColor colorWithRed:(54/255.0) green:(74/255.0) blue:(89/255.0) alpha:1.0];
    // BG graph use
    if (angle >= 0.8) {
        [concentricPieChart addAngleValue:angle andColor:[UIColor colorWithRed:0 green:(130/255.0) blue:(200/255.0) alpha:1.0] ];
    }
    else if (angle >= 0.5) {
        [concentricPieChart addAngleValue:angle andColor:[UIColor colorWithRed:(46/255.0) green:(204/255.0) blue:(113/255.0) alpha:1.0] ];
    }
    else {
        [concentricPieChart addAngleValue:angle andColor:[UIColor colorWithRed:(255/255.0) green:(76/255.0) blue:(78/255.0) alpha:1.0] ];
    }
    
    [self.ViewQualityGraph addSubview:concentricPieChart];
}









// ----------------------------------------------------------------------------
//                                  BAR GRAPH
// ----------------------------------------------------------------------------


- (void)loadView
{
	[super loadView];
    NSLog(@"StartBar");
    
    NSString *graph    = [self.arrSleepData objectAtIndex:11];
    NSArray* arrgraph  = [graph componentsSeparatedByString: @","];
//    NSMutableArray *arrgraph2 = [[NSMutableArray alloc] init];
//    for (id obj in arrgraph) {
//        float data = [obj floatValue];
//        [arrgraph2 addObject:[NSNumber numberWithFloat:data] ];
//    }
//    
//    NSLog(@"arrgraph2 : %@",arrgraph2);
    
    self.arrGraph = arrgraph;
//    self.arrGraph = @[@1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @1.0, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.5, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3, @0.3 ];
    NSLog(@"arrGraph : %@",self.arrGraph);
    self.arrGraphCount = self.arrGraph.count;
    self.arrDay = @[@6,@7,@8];
    
    float frameW                    = self.ViewGraph.frame.size.width;
    float frameH                    = self.ViewGraph.frame.size.height;
    float barW                      = frameW/self.arrGraphCount;
	self.barColors                  = @[[UIColor colorWithRed:0.0 green:(130/255.0) blue:(200/255.0) alpha:1.0],
                                        [UIColor colorWithRed:(45/255.0) green:(204/255.0) blue:(112/255.0) alpha:1.0],
                                        [UIColor colorWithRed:(179/255.0) green:(64/255.0) blue:(57/255.0) alpha:1.0],
                                        [UIColor colorWithRed:(49/255.0) green:(64/255.0) blue:(71/255.0) alpha:1.0]];
	self.currentBarColor			= 0;
    NSLog(@"1");
	self.chart						= [[SimpleBarChart alloc] initWithFrame:CGRectMake(0, 0, frameW, frameH)];
    NSLog(@"2");
	self.chart.delegate				= self;
	self.chart.dataSource			= self;
	self.chart.animationDuration	= 0;
	self.chart.barWidth				= barW;
    
	[self.ViewGraph addSubview:self.chart];
    
    [self setTime];
}


- (NSUInteger)numberOfBarsInBarChart:(SimpleBarChart *)barChart
{
	return self.arrGraphCount;
}

- (CGFloat)barChart:(SimpleBarChart *)barChart valueForBarAtIndex:(NSUInteger)index
{
	return [[self.arrGraph objectAtIndex:index] floatValue];
}

- (UIColor *)barChart:(SimpleBarChart *)barChart colorForBarAtIndex:(NSUInteger)index
{
    float value = [self.arrGraph[index] floatValue];
    if (value == 1.0) {
        return [self.barColors objectAtIndex:2];
    }
    else if (value == 0.5) {
        return [self.barColors objectAtIndex:1];
    }
    else {
        return [self.barColors objectAtIndex:0];
    }
}

-(void)setTime {
    // Set Time text
    if (self.arrDay.count > 0) {
        
        // Set width & height
        float labelW = self.ViewGraphText.frame.size.width/self.arrDay.count;
        float labelH = self.ViewGraphText.frame.size.height;
        
        
        for (int i=0; i<self.arrDay.count; i++) {
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i, 0, labelW, labelH)];
            myLabel.text = [NSString stringWithFormat:@"%@",[self.arrDay objectAtIndex:i] ];
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.font = [UIFont systemFontOfSize:10];
            myLabel.textColor = [UIColor colorWithRed:(49/255.0) green:(64/255.0) blue:(71/255.0) alpha:1.0];
            [self.ViewGraphText addSubview:myLabel];
        }
    }
}


@end
