//
//  StartSleepDetectViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "StartSleepDetectViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ECSlidingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface StartSleepDetectViewController ()

@property (nonatomic) int sleepDataidT;
@property (nonatomic) NSString *timestartT;
@property (nonatomic) NSString *timeendT;
@property (nonatomic) int latencyT;
@property (nonatomic) int qualityT;
@property (nonatomic) int durationT;
@property (nonatomic) int durationdeepT;
@property (nonatomic) int durationlightT;
@property (nonatomic) NSString *codeavatarT;
@property (nonatomic) NSString *graphT;
@property (nonatomic) BOOL graphCheck;
@property (nonatomic) NSString *graphTextT;
@property (strong, nonatomic) NSLocale *lang;


@property (weak, nonatomic) IBOutlet UIButton *ButtonStopDetect;


@end

@implementation StartSleepDetectViewController

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
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sqlite"];
    
    // Set lang
    self.lang = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // Set graphCheck
    self.graphCheck = false;
    
    // Add data
    self.countTimeAddData = 0;
    [self addData];
    
    // Custom button
    self.ButtonStopDetect.layer.cornerRadius = 5;
    self.ButtonStopDetect.layer.masksToBounds = YES;
    
    
    // Animation rotation gear
    [self spin];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






// ----------------------------------------------------------------------------
//                            ANIMATION ROTATE GEAR
// ----------------------------------------------------------------------------


- (void)spin
{
    
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.ImageViewGear1.transform = CGAffineTransformRotate(self.ImageViewGear1.transform, M_PI_2);
        self.ImageViewGear2.transform = CGAffineTransformRotate(self.ImageViewGear2.transform, -M_PI_2);
        self.ImageViewGear3.transform = CGAffineTransformRotate(self.ImageViewGear3.transform, M_PI_2);
    } completion:^(BOOL finished) {
        [self spin];
    }];
}





// ----------------------------------------------------------------------------
//                                 ADD DATA
// ----------------------------------------------------------------------------


- (void)addData {
    
    // STEP 1 : Check session & Set start value
    
    __block int SleepListCount=0;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setLocale:self.lang];
    NSString *query = @"SELECT * FROM sleepData";
    
    NSArray *arrCheckSleepList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] arrCheckSleepList];
    if (arrCheckSleepList == nil) {
        arrCheckSleepList = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        SleepListCount = (int)arrCheckSleepList.count + 1;
        NSLog(@"sleepListCount1 = %i",SleepListCount);
        
        
//        [objDateformat setDateFormat:@"dd MMMM yyyy eee"];
//        NSString *strTime = [objDateformat stringFromDate:[NSDate date]];
//        
//        [self createSleepData:strTime];
    }
    else {
        SleepListCount = (int)arrCheckSleepList.count;
        NSLog(@"sleepListCount2 = %i",SleepListCount);
    }
    
    
    
    // STEP 2 : Detect
    
    __block float X = 0;
    __block float Y = 0;
    __block float tempX = 0;
    __block float tempY = 0;
    __block float rangeX = 0;
    __block float rangeY = 0;
    __block float rangeXX = 0;
    __block float rangeYY = 0;
    __block int rangePer = 0;
    __block NSString *type;
    __block float typeFloat = 0;
    __block NSString *timeStart;
    __block NSString *timeEnd;
    __block int count = 0;
    __block int countLatency = 1;
    
    float timeRun = 0.5;
    NSTimeInterval updateInterval = timeRun;
    
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager] ;
    
    
    if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            //            self.labelCount.text = [NSString stringWithFormat:@"%d",count];
//            NSLog(@"%d",count);
            
            if (count == 0) {
                X = accelerometerData.acceleration.x;
                Y = accelerometerData.acceleration.y;
                tempX = X;
                tempY = Y;
            }
            else {
                
                if (count == 1) {
                    [objDateformat setDateFormat:@"HH:mm"];
                    timeStart = [objDateformat stringFromDate:[NSDate date]];
                    NSLog(@"timeStart!");
                }
                
                X = accelerometerData.acceleration.x;
                Y = accelerometerData.acceleration.y;
                //                self.labelX.text = [NSString stringWithFormat:@"X = %f",X];
                //                self.labelY.text = [NSString stringWithFormat:@"Y = %f",Y];
                
                // X
                if (X>=0 && tempX>=0) {
                    rangeX = X-tempX;
                }
                else if (X>=0 && tempX<0) {
                    rangeX = X-(tempX*-1);
                }
                else if (X<0 && tempX>=0) {
                    rangeX = (X*-1)-tempX;
                }
                else if (X<0 && tempX<0) {
                    rangeX = (X*-1)-(tempX*-1);
                }
                // Y
                if (Y>=0 && tempY>=0) {
                    rangeY = Y-tempY;
                }
                else if (Y>=0 && tempY<0) {
                    rangeY = Y-(tempY*-1);
                }
                else if (Y<0 && tempY>=0) {
                    rangeY = (Y*-1)-tempY;
                }
                else if (Y<0 && tempY<0) {
                    rangeY = (Y*-1)-(tempY*-1);
                }
                
                // Set not -
                if (rangeX<0) { rangeX *= -1; }
                if (rangeY<0) { rangeY *= -1; }
                
                if (rangeX>rangeXX) {
                    rangeXX = rangeX;
                }
                if (rangeY>rangeYY) {
                    rangeYY = rangeY;
                }
                
                //                self.labelRangeX.text = [NSString stringWithFormat:@"rangeX = %f",rangeXX];
                //                self.labelRangeY.text = [NSString stringWithFormat:@"rangeY = %f",rangeYY];
                
                tempX = X;
                tempY = Y;
                
                
                
                
                // --------------------------
                rangePer = ( (rangeXX+rangeYY) *100)/0.5; // 0.5 => max range
                typeFloat = rangePer*0.01;
                
                // Old
//                if (typeFloat <= 0.1) {
//                    type = @"Deep sleep";
//                }
//                else if (typeFloat <= 0.5) {
//                    type = @"Light sleep";
//                }
//                else {
//                    type = @"Awake";
//                }
                
                // New
                if (countLatency<=15) {
                    if (typeFloat <= 0.05) {
                        type = @"Deep sleep";
                    }
                    else if (typeFloat <= 0.25) {
                        type = @"Light sleep";
                    }
                    else {
                        type = @"Awake";
                    }
                }
                else {
                    if (typeFloat <= 0.1) {
                        type = @"Deep sleep";
                    }
                    else if (typeFloat <= 0.5) {
                        type = @"Light sleep";
                    }
                    else {
                        type = @"Awake";
                    }
                }
                
                
                NSLog(@"%d, rangePer : %i, typeFloat : %f, [%@]",count,rangePer,typeFloat,type);
                
                if (count == (60/timeRun) ) {
                    timeEnd = [objDateformat stringFromDate:[NSDate date]];
                    
//                    rangePer = ( (rangeXX+rangeYY) *100)/0.5; // 0.5 => max range
//                    typeFloat = (rangePer/100);
//                    if (typeFloat <= 0.1) {
//                        type = @"Deep sleep";
//                    }
//                    else if (typeFloat <= 0.5) {
//                        type = @"Light sleep";
//                    }
//                    else {
//                        type = @"Awake";
//                    }
                    
                    NSLog(@"rangeX : %f, rangeY : %f",rangeXX, rangeYY);
                    NSLog(@"%@[%f]", type, typeFloat);
                    NSLog(@"timeStart : %@",timeStart);
                    NSLog(@"timeEnd : %@",timeEnd);
                    NSLog(@" ");
                    
                    
                    // Add data into sqlite
                    if (self.countTimeAddData==0) {
                        [objDateformat setDateFormat:@"dd MMMM yyyy eee"];
                        NSString *strTime = [objDateformat stringFromDate:[NSDate date]];
                        
                        [self createSleepData:strTime];
                        self.countTimeAddData = 1;
                    }
                    NSLog(@"[Start function save sleepBehavior]");
                    [self saveSleepBehavior:SleepListCount timeStart:timeStart timeEnd:timeEnd type:type range:typeFloat ];
                    
                    rangeXX =0;
                    rangeYY =0;
                    count = 0;
                    countLatency++;
                }
            }
            
            count++;
            
        }];
    }
    
    
}








// ----------------------------------------------------------------------------
//                                 STOP DETECT
// ----------------------------------------------------------------------------


- (IBAction)stopDetect:(id)sender {
    
    // STEP 1 : Update data into database
    
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if ([mManager isAccelerometerActive] == YES) {
        [mManager stopAccelerometerUpdates];
    }
    NSLog(@"Stop detect");
    
    [self updateSleepData];
    
}








// ----------------------------------------------------------------------------
//                            SAVE DATA INTO DATABASE
// ----------------------------------------------------------------------------


- (void)saveSleepBehavior:(int)sleepData_id timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd type:(NSString *)type range:(float)range {
    NSLog(@"[saveSleepBehavior] Start!");

    NSString *query = [NSString stringWithFormat:@"INSERT INTO sleepBehavior (sleepData_id, sleepBehavior_timestart, sleepBehavior_timeend, sleepBehavior_type) VALUES (%i, '%@', '%@', '%@')", sleepData_id, timeStart, timeEnd, type];
    NSLog(@"sql : %@",query);
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[saveSleepBehavior] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);

        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"[saveSleepBehavior] Could not execute the query.");
    }

}








// ----------------------------------------------------------------------------
//                            ADD GRAPH-BAR VALUE
// ----------------------------------------------------------------------------


- (void)addGraphBarValue:(NSString *)type {
    NSLog(@"[addGraphBarValue] Start!");
    
    // First time
    if (self.graphCheck == false) {
        
        if ([type isEqualToString: @"Deep sleep"]) {
            self.graphT = @"0.3";
        }
        else if ([type isEqualToString: @"Light sleep"]) {
            self.graphT = @"0.5";
        }
        else if ([type isEqualToString: @"Awake"]) {
            self.graphT = @"1.0";
        }
        else {
            self.graphT = @"1.0";
        }
        self.graphCheck = true;
    }
    // Other time
    else {
        
        if ([type isEqualToString: @"Deep sleep"]) {
            self.graphT = [NSString stringWithFormat:@"%@,0.3",self.graphT];
        }
        else if ([type isEqualToString: @"Light sleep"]) {
            self.graphT = [NSString stringWithFormat:@"%@,0.5",self.graphT];
        }
        else if ([type isEqualToString: @"Awake"]) {
            self.graphT = [NSString stringWithFormat:@"%@,1.0",self.graphT];
        }
        else {
            self.graphT = [NSString stringWithFormat:@"%@,1.0",self.graphT];
        }
    }
    NSLog(@"GraphBar : %@",self.graphT);
    
}







// ----------------------------------------------------------------------------
//                           CREATE SLEEP-DATA FIRST TIME
// ----------------------------------------------------------------------------


-(void)createSleepData:(NSString *)date {
    
    int avatar_id           = [self findAvatarId];
    NSLog(@"AvatarID : %i", avatar_id);
    NSString *timeStart     = @"00:00";
    NSString *timeEnd       = @"00:00";
    int latency             = 0;
    int quality             = 0;
    int duration            = 0;
    int durationdeep        = 0;
    int durationlight       = 0;
    NSString *codeavatar    = @"000";
    NSString *graphBar      = @"0";
    NSString *graphBarText  = @"01";
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO sleepData (Avatar_id, sleepData_date, sleepData_timestart, sleepData_timeend, sleepData_latency, sleepData_quality, sleepData_duration, sleepData_durationdeep, sleepData_durationlight, sleepData_codeavatar, sleepData_graphBar, sleepData_graphBarText) VALUES(%i, '%@', '%@', '%@', %d, %d, %d, %d, %d, '%@', '%@', '%@')", avatar_id, date, timeStart, timeEnd, latency, quality, duration, durationdeep, durationlight, codeavatar, graphBar, graphBarText];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[CreateSleepData] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"[CreateSleepData] Could not execute the query.");
    }
}








// ----------------------------------------------------------------------------
//                         UPDATE SLEEP-DATA FINISH TIME
// ----------------------------------------------------------------------------


-(void)updateSleepData {
    NSLog(@"[updateSleepData] Start!");

    
    // STEP 0 : Create value
    
    int sleepData_id        = 0;
    NSString *timeStart     = @"00:00";
    NSString *timeEnd       = @"00:00";
    int latency             = 0;
    int quality             = 0;
    int duration            = 0;
    int durationdeep        = 0;
    int durationlight       = 0;
    NSString *codeavatar    = @"000";
    NSString *graphBar      = @"0";
    NSString *graphBarText  = @"01";
    
    
    
    // STEP 1 : Change value
    
    [self analyzeSleep];
    
    sleepData_id    = self.sleepDataidT;
    timeStart       = self.timestartT;
    timeEnd         = self.timeendT;
    latency         = self.latencyT;
    quality         = self.qualityT;
    duration        = self.durationT;
    durationdeep    = self.durationdeepT;
    durationlight   = self.durationlightT;
    codeavatar      = self.codeavatarT;
    graphBar        = self.graphT;
    graphBarText    = self.graphTextT;
    
    NSLog(@"latency : %d, quality : %d, duration : %d, durationdeep : %d, durationlight : %d, codeavatar : %@, graphBar : %@, graphBarText : %@", latency, quality, duration, durationdeep, durationlight, codeavatar, graphBar, graphBarText);
    
    
    
    
    // STEP 2 : update/delate database
    NSString *query = [NSString stringWithFormat:@"UPDATE sleepData SET sleepData_timestart = '%@', sleepData_timeend = '%@', sleepData_latency = %d, sleepData_quality = %d, sleepData_duration = %d, sleepData_durationdeep = %d, sleepData_durationlight = %d, sleepData_codeavatar = '%@', sleepData_graphBar = '%@', sleepData_graphBarText = '%@' WHERE sleepData_id = %d", timeStart, timeEnd, latency, quality, duration, durationdeep, durationlight, codeavatar, graphBar, graphBarText, sleepData_id];
    
    NSLog(@"sql : %@",query);
    [self.dbManager executeQuery:query];
    
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[saveSleepData] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"[saveSleepData]Could not execute the query.");
    }

    
    
    
}








// ----------------------------------------------------------------------------
//                               ANALYZE SLEEP
// ----------------------------------------------------------------------------


-(void)analyzeSleep {
    NSLog(@"[analyzeSleep] Start!");
    
    
    
    // ------------------------------------------------
    // STEP 0 : Create value
    // ------------------------------------------------
    
    int sleepData_id            = 0;
    NSString *timeStart         = @"00:00";
    NSString *timeEnd           = @"00:00";
    
    int latency                 = 0;
    BOOL latencyCountAmount     = false;
    
    int quality                 = 0;
    int scoreLatency            = 0;
    int scoreDuration           = 0;
    int scoreEfficiency         = 0;
    int efficiency              = 0; // true sleep/sleep duration
    
    int duration                = 0;
    int durationHour            = 0;
    int durationdeep            = 0;
    int durationlight           = 0;
    
    NSString *codeAvatar        = @"000";
    
    NSString *graphBarText      = @"";
    NSString *graphBarTextTemp  = @""; // Temp text for any loop
    NSString *graphBarTextGet   = @""; // Temp text in loop
    NSArray *arr_graphBarTextGet;
    BOOL graphBarTextCheck      = false;


    
    
    NSString *query;
    NSArray *arr;
    
    
    int properDurationMin   = 0;
    int properDurationMax   = 0;
    int age = [self findUserAge];
    NSLog(@"Age : %i", age);
    
    // Find properDuration
    if (age<1) {
        properDurationMin = 14;
        properDurationMax = 15;
    }
    else if (age<2) {
        properDurationMin = 12;
        properDurationMax = 14;
    }
    else if (age<6) {
        properDurationMin = 11;
        properDurationMax = 13;
    }
    else if (age<12) {
        properDurationMin = 10;
        properDurationMax = 10;
    }
    else if (age<15) {
        properDurationMin = 9;
        properDurationMax = 9;
    }
    else if (age<18) {
        properDurationMin = 8;
        properDurationMax = 8;
    }
    else {
        properDurationMin = 7;
        properDurationMax = 8;
    }
    NSLog(@"properDurationMin : %i, properDurationMax : %i", properDurationMin, properDurationMax);

    
    
    
    
    

    // ------------------------------------------------
    // STEP 1 : Get data sleepBehavior for analyze
    // ------------------------------------------------
    
    
    // --------------------------
    // Find sleepData_id
    // --------------------------
    query = @"SELECT * FROM sleepData";
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"query : %@, result : %@",query,arr);
    
    // sleepData_id
    sleepData_id = (int)[arr count];
    NSLog(@"sleepData_id : %i", sleepData_id);
    
    
    
    
    // --------------------------
    // Find - sleepData_timestart
    //      - sleepData_timeend
    //      - graphBar
    //      - Duration
    //      - Duration deep
    //      - Dutation light
    //      - Latency
    //      - Efficiency
    //      - graphBarText
    // --------------------------
    query = [NSString stringWithFormat:@"SELECT * FROM sleepBehavior WHERE sleepData_id = %d",sleepData_id];
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"query : %@, result : %@",query,arr);
    
    // duration
    duration = (int)[arr count];
    NSLog(@"duration : %d", duration);
    
    // durationHour
    durationHour = duration/60;
    
    
    for (int i=0; i<duration; i++) {
        NSLog(@"i = %d", i);
        
        // --------------------------
        // Find - timestart
        //      - timeend
        // --------------------------
        if ( i==0 ) {
            // timeStart
            timeStart = [[arr objectAtIndex:i] objectAtIndex:2];
            NSLog(@"timestart = %@", timeStart);
        }
        if (i == (duration-1) ) {
            // timeEnd
            timeEnd = [[arr objectAtIndex:i] objectAtIndex:3];
            NSLog(@"timeend = %@", timeEnd);
        }
        
        
        // --------------------------
        // Find - GraphBar
        //      - Duration deep
        //      - Dutation light
        //      - Latency
        // --------------------------
        NSString *type = [[arr objectAtIndex:i] objectAtIndex:4];
        NSLog(@"Type: %@",type);
        [self addGraphBarValue:type];
        
        if ([type  isEqual: @"Deep sleep"]) {
            durationdeep++;
            NSLog(@"durationdeep++");
            latencyCountAmount = true;
        }
        else if ([type  isEqual: @"Light sleep"]) {
            durationlight++;
            NSLog(@"durationlight++");
            latencyCountAmount = true;
        }
        if (latencyCountAmount == false) {
            latency++;
            NSLog(@"latency++");
        }
        
        
        // --------------------------
        // Find graphBarText
        // --------------------------
        
        // Get
        if (i==0) {
            graphBarTextGet = [[arr objectAtIndex:i] objectAtIndex:2];
        }
        else if (i == (duration-1) ) {
            graphBarTextGet = [[arr objectAtIndex:i] objectAtIndex:3];
        }
        arr_graphBarTextGet  = [graphBarTextGet componentsSeparatedByString: @":"];
        graphBarTextGet = [arr_graphBarTextGet objectAtIndex:0];
        NSLog(@"graphBarTextGet : %@",graphBarTextGet);
        
        // Temp & Set graphBarText
        if ([graphBarTextTemp isEqualToString:graphBarTextGet]) {}
        else {
            
            // Temp
            graphBarTextTemp = graphBarTextGet;
            
            // Set graphBarText
            if (graphBarTextCheck == false) {
                graphBarText = graphBarTextTemp;
                graphBarTextCheck = true;
            }
            else {
                graphBarText = [NSString stringWithFormat:@"%@,%@", graphBarText, graphBarTextTemp];
            }
            NSLog(@"graphBarText : %@", graphBarText);
            
        }
        
        
        
    }
    NSLog(@"timestart : %@, timeend : %@, durationdeep : %i, durationlight : %i, latency : %i, graphBarText : %@", timeStart, timeEnd, durationdeep, durationlight, latency, graphBarText);
    
    
    
    

    // --------------------------
    // Find efficiency
    // --------------------------
    efficiency = ((durationdeep+durationlight)*100)/duration;
    NSLog(@"Sleep Efficiency : %d%%", efficiency);
    
    
    
    
    
    
    
    
    

    // ------------------------------------------------
    // Step 2 : Analyze data -> Quality
    // ------------------------------------------------
    

    // Section Duration
    if (durationHour<properDurationMin) {
        scoreDuration = properDurationMin - durationHour;
        if (scoreDuration>3) {
            scoreDuration = 3;
        }
    }
    
    // Section Latency
    if      (latency > 60) { scoreLatency = 3; }
    else if (latency > 30 && scoreDuration<3) { scoreLatency = 2; }
    else if (latency > 15 && scoreDuration<3) { scoreLatency = 1; }
    else    { scoreLatency = 3; }
    
    // Section Efficiency
    if      (efficiency < 65) { scoreEfficiency = 3; }
    else if (efficiency < 75 && scoreDuration<3) { scoreEfficiency = 2; }
    else if (efficiency >= 75 && scoreDuration<3) { scoreEfficiency = 1; }
    else    { scoreEfficiency = 3; }
    
    quality = 100 - (11*scoreLatency) - (11*scoreDuration) - (11*scoreEfficiency);
    NSLog(@"Quality : %d%%", quality);
    NSLog(@"scoreLatency : %d", scoreLatency);
    NSLog(@"scoreDuration : %d", scoreDuration);
    NSLog(@"scoreEfficiency : %d", scoreEfficiency);
    
    
    
    
    
    
    

    
    // ------------------------------------------------
    // Step 3 : Analyze data -> codeAvatar
    // ------------------------------------------------
    
    
    // Section Duration
    if (durationHour>properDurationMax) {
        codeAvatar = @"2";
    }
    else {
        if (scoreDuration == 0) {
            codeAvatar = @"1";
        }
        else if (scoreDuration<3) {
            codeAvatar = @"3";
        }
        else {
            codeAvatar = @"4";
        }
    }
    // Section Deep sleep
    if (  ((durationdeep * 100)/ (properDurationMin*60) )   >49) {
        codeAvatar = [NSString stringWithFormat:@"%@1",codeAvatar];
    }
    else if ( ((durationdeep * 100)/ (properDurationMin*60) ) >32) {
        codeAvatar = [NSString stringWithFormat:@"%@2",codeAvatar];
    }
    else {
        codeAvatar = [NSString stringWithFormat:@"%@3",codeAvatar];
    }
    // Section Light sleep
    if ( ((durationlight * 100)/ (properDurationMin*60) ) >19) {
        codeAvatar = [NSString stringWithFormat:@"%@1",codeAvatar];
    }
    else if ( ((durationlight * 100)/ (properDurationMin*60) ) >13) {
        codeAvatar = [NSString stringWithFormat:@"%@2",codeAvatar];
    }
    else {
        codeAvatar = [NSString stringWithFormat:@"%@3",codeAvatar];
    }
    
    
    
    
    
    
    

    // ------------------------------------------------
    // Step 4 : Set value to global
    // ------------------------------------------------
    
    self.sleepDataidT   = sleepData_id;
    self.timestartT     = timeStart;
    self.timeendT       = timeEnd;
    self.latencyT       = latency;
    self.qualityT       = quality;
    self.durationT      = duration;
    self.durationdeepT  = durationdeep;
    self.durationlightT = durationlight;
    self.codeavatarT    = codeAvatar;
    self.graphTextT     = graphBarText;
    
    
    NSLog(@"[analyzeSleep] End!");
}








// ----------------------------------------------------------------------------
//                              FIND AVATAR-ID
// ----------------------------------------------------------------------------


- (int) findAvatarId {
    
    NSLog(@"[findAvatarId] Start!");
    
    NSString *query = @"SELECT avatar_id FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrAvatarid = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];
    
    int avatarid = [ [[arrAvatarid objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];
    
    NSLog(@"AvatarID : %i",avatarid);
    return avatarid;
}








// ----------------------------------------------------------------------------
//                              FIND USER AGE
// ----------------------------------------------------------------------------


- (int) findUserAge {
    NSLog(@"[findUserAge] Start!");
    // STEP 1 : Get data
    
    NSString *query = @"SELECT user_birthday FROM user ORDER BY user_id DESC LIMIT 1";
    
    NSArray *arrUserBDay = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfuser_birthday = [self.dbManager.arrColumnNames indexOfObject:@"user_birthday"];
    
    NSString *bday = [[arrUserBDay objectAtIndex:0] objectAtIndex:indexOfuser_birthday];
    
    // STEP 2 : Calculate Age
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:self.lang];
    
    NSDate *prev = [dateFormatter dateFromString:bday];
    NSDate* now = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:prev
                                       toDate:now
                                       options:0];
    int age = (int)[ageComponents year];
    NSLog(@"Age : %i",age);
    return age;
}





@end
