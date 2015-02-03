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

@interface StartSleepDetectViewController ()

@property (nonatomic) int latencyT;
@property (nonatomic) int qualityT;
@property (nonatomic) int durationT;
@property (nonatomic) int durationdeepT;
@property (nonatomic) int durationlightT;
@property (nonatomic) NSString *codeavatarT;
@property (nonatomic) NSMutableArray * graphT;
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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sleepAvatar.sql"];
    
    // Set lang
    self.lang = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // Add data
    [self addData];
    
    // Load the data.
    [self loadData];
    
    // Custom button
    self.ButtonStopDetect.layer.cornerRadius = 5;
    self.ButtonStopDetect.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// ----------------------------------------------------------------------------
//                                 LOAD DATA
// ----------------------------------------------------------------------------


- (void)loadData {
    
    NSString *query = @"SELECT * FROM sleepBehavior";
    
    
    if (self.arrSleepBehavior != nil) {
        self.arrSleepBehavior = nil;
    }
    self.arrSleepBehavior = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"[SleepBehavior] count arrSleepBehavior : %i",[self.arrSleepBehavior count]);
//    [self.table reloadData];
    
}








// ----------------------------------------------------------------------------
//                                 ADD DATA
// ----------------------------------------------------------------------------


- (void)addData {
    
    
    // STEP 1 : Check session & Set start value
    
    __block int SleepListCount;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setLocale:self.lang];
    NSString *query = @"SELECT * FROM sleepData";
    
    NSArray *arrCheckSleepList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] arrCheckSleepList];
    if (arrCheckSleepList == nil) {
        arrCheckSleepList = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        SleepListCount = (unsigned long)arrCheckSleepList.count + 1;
        NSLog(@"sleepListCount1 = %i",SleepListCount);
        
        
        [objDateformat setDateFormat:@"dd MMMM yyyy eee"];
        NSString *strTime = [objDateformat stringFromDate:[NSDate date]];
        
        [self createSleepData:strTime];
    }
    else {
        SleepListCount = (unsigned long)arrCheckSleepList.count;
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
    
    float timeRun = 0.5;
    NSTimeInterval updateInterval = timeRun;
    
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager] ;
    
    
    if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            //            self.labelCount.text = [NSString stringWithFormat:@"%d",count];
            NSLog(@"%d",count);
            
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
                
                if (count == (60/timeRun) ) {
                    timeEnd = [objDateformat stringFromDate:[NSDate date]];
                    
                    rangePer = ( (rangeXX+rangeYY) *100)/0.5; // 0.5 => max range
                    typeFloat = (rangePer/100);
                    if (typeFloat <= 0.1) {
                        type = @"Deep sleep";
                    }
                    else if (typeFloat <= 0.5) {
                        type = @"Light sleep";
                    }
                    else {
                        type = @"Awake";
                    }
                    
                    NSLog(@"rangeX : %f, rangeY : %f",rangeXX, rangeYY);
                    NSLog(@"%@[%f]", type, typeFloat);
                    NSLog(@"timeStart : %@",timeStart);
                    NSLog(@"timeEnd : %@",timeEnd);
                    NSLog(@" ");
                    
                    
                    // Add data into sqlite
                    [self saveSleepBehavior:SleepListCount timeStart:timeStart timeEnd:timeEnd type:type range:typeFloat ];
                    
                    
                    rangeXX =0;
                    rangeYY =0;
                    count = 0;
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
    
    
    // Push graph
    //    if ([type isEqualToString: @"Deep sleep"]) {
    //        [self.graphT addObject:@0.3];
    //    }
    //    else if ([type isEqualToString: @"Light sleep"]) {
    //        [self.graphT addObject:@0.5];
    //    }
    //    else if ([type isEqualToString: @"Awake"]) {
    //        [self.graphT addObject:@1.0];
    //    }
    //    else {
    //        [self.graphT addObject:@1.0];
    //    }
    
    
    
    
    
    NSString *query;
    query = [NSString stringWithFormat:@"INSERT INTO sleepBehavior VALUES(null, %d, '%@', '%@', '%@')", sleepData_id, timeStart, timeEnd, type];
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[saveSleepBehavior] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self loadData];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"[saveSleepBehavior] Could not execute the query.");
    }
}








// ----------------------------------------------------------------------------
//                           CREATE SLEEP-DATA FIRST TIME
// ----------------------------------------------------------------------------


-(void)createSleepData:(NSString *)date {
    
    int avatar_id = [self findAvatarId];
    NSString *timeStart = @"00:00";
    NSString *timeEnd = @"00:00";
    int latency = 0;
    int quality = 0;
    int duration = 0;
    int durationdeep = 0;
    int durationlight = 0;
    NSString *codeavatar = @"000";
    NSString *graphBar = @"0";
    
    NSString *query;
    query = [NSString stringWithFormat:@"INSERT INTO sleepData VALUES(null, %d, '%@', '%@', '%@', %d, %d, %d, %d, %d, '%@', '%@')", avatar_id, date, timeStart, timeEnd, latency, quality, duration, durationdeep, durationlight, codeavatar, graphBar];
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
    
    
    // STEP 0 : Create value
    
    int sleepData_id = 0;
    NSString *timeStart = @"00:00";
    NSString *timeEnd = @"00:00";
    int latency = 0;
    int quality = 0;
    int duration = 0;
    int durationdeep = 0;
    int durationlight = 0;
    NSString *codeavatar = @"000";
    
    
    
    
    // STEP 1 : Calculate data from sleepBehavior
    
    NSString *query;
    NSArray *arr;
    
    // Find sleepData_id
    query = @"SELECT * FROM sleepData";
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    // sleepData_id <-------------------------------
    sleepData_id = (int)arr.count;
    NSLog(@"sleepData_id : %d", sleepData_id);
    
    // Find sleepData_timestart & sleepData_timeend & create sleepBehavior in graph
    query = [NSString stringWithFormat:@"SELECT * FROM sleepBehavior WHERE sleepData_id = %d",sleepData_id];
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    int countArr = (int)arr.count;
    NSLog(@"countArr : %d", countArr);
    
    
    NSInteger indexOfsleepBehavior_timestart = [self.dbManager.arrColumnNames indexOfObject:@"sleepBehavior_timestart"];
    NSInteger indexOfsleepBehavior_timeend = [self.dbManager.arrColumnNames indexOfObject:@"sleepBehavior_timeend"];
    NSInteger indexOfsleepBehavior_type = [self.dbManager.arrColumnNames indexOfObject:@"sleepBehavior_type"];
    
    
    NSMutableArray *arrSleepGraph = [[NSMutableArray alloc] init];
    for (int i=0; i<countArr; i++) {
        NSLog(@"i = %d", i);
        
        // Set timestart & timeend
        if ( i==0 ) {
            // timeStart <-------------------------------
            timeStart = [[arr objectAtIndex:i] objectAtIndex:indexOfsleepBehavior_timestart];
            NSLog(@"timestart = %@", timeStart);
        }
        if (i == (countArr-1) ) {
            // timeEnd <-------------------------------
            timeEnd = [[arr objectAtIndex:i] objectAtIndex:indexOfsleepBehavior_timeend];
            NSLog(@"timeend = %@", timeEnd);
        }
        
        // Set data in graph
        NSString *type = [[arr objectAtIndex:i] objectAtIndex:indexOfsleepBehavior_type];
        if ([type  isEqual: @"Deep sleep"]) {
            [arrSleepGraph addObject:[NSNumber numberWithFloat:0.3]];
        }
        else if ([type  isEqual: @"Light sleep"]) {
            [arrSleepGraph addObject:[NSNumber numberWithFloat:0.8]];
        }
        else if ([type  isEqual: @"Awake"]) {
            [arrSleepGraph addObject:[NSNumber numberWithFloat:1.0]];
        }
    }
    

    int age = [self findUserAge];
    
    [self analyzeSleep:age sleepData:arrSleepGraph];
    
    latency = self.latencyT;
    quality = self.qualityT;
    duration = self.durationT;
    durationdeep = self.durationdeepT;
    durationlight = self.durationlightT;
    codeavatar = self.codeavatarT;
    
    NSLog(@"latency : %d, quality : %d, duration : %d, durationdeep : %d, durationlight : %d, codeavatar : %@", latency, quality, duration, durationdeep, durationlight, codeavatar);
    
    
    
    
    
    
    
    
    
    // STEP 2 : update database
    query = [NSString stringWithFormat:@"UPDATE sleepData SET sleepData_timestart = '%@', sleepData_timeend = '%@', sleepData_duration = %d, sleepData_durationdeep = %d, sleepData_durationlight = %d, sleepData_quality = %d, sleepData_codeavatar = '%@' WHERE sleepData_id = %d", timeStart, timeEnd, duration, durationdeep, durationlight, quality, codeavatar, sleepData_id];
    [self.dbManager executeQuery:query];
    
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"[saveSleepData] Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"[saveSleepData]Could not execute the query.");
    }
    
    
    //
    //    for (id obj in self.graphT) {
    //        NSLog(@"graphT :%@", obj);
    //    }
    
    
    
}








// ----------------------------------------------------------------------------
//                               ANALYZE SLEEP
// ----------------------------------------------------------------------------


-(void)analyzeSleep:(int)age sleepData:(NSMutableArray*)sleepData {
    NSLog(@"[analyzeSleep] Start!");
    //    int age = 21;
    int properDurationMin   = 0;
    int properDurationMax   = 0;
    
    
    int duration            = [sleepData count];
    int durationHour        = duration/60;
    //    int durationMin         = duration-(60*durationHour);
    
    int latency             = 0;
    int latencyHour         = 0;
    int latencyMin          = 0;
    BOOL latencyCountAmount = false;
    
    int efficiency          = 0; // true sleep/sleep duration
    
    int deepSleep           = 0;
    int deepSleepHour       = 0;
    int deepSleepMin        = 0;
    int deepSleepPer        = 0;
    int lightSleep          = 0;
    int lightSleepHour      = 0;
    int lightSleepMin       = 0;
    int lightSleepPer       = 0;
    
    NSString *descript      = @"Description : ";
    
    int quality             = 0;
    int scoreLatency        = 0;
    int scoreDuration       = 0;
    int scoreEfficiency     = 0;
    
    NSString *codeAvatar    = @"";
    
    
    
    
    // ------------------------------------------------
    // Step 1 : Calculate sleep data
    // ------------------------------------------------
    
    
    // Set properDuration
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
    
    // Calculate deepSleep, lightSleep, Latency
    for (id obj in sleepData) {
        
        float data = [obj floatValue];
        
        // Deep & Light count
        if (data < 0.31) {
            deepSleep++;
        }
        else if (data < 0.81) {
            lightSleep++;
        }
        
        // Latency count
        if (data > 0.30 && latencyCountAmount == false) {
            latency++;
        }
        if (data < 0.31 && latencyCountAmount == false) {
            latencyCountAmount = true;
        }
        

    }
    
    deepSleepHour  = deepSleep/60;
    deepSleepMin   = deepSleep - (deepSleepHour*60);
    deepSleepPer   = (100*deepSleep)/duration;
    lightSleepHour = lightSleep/60;
    lightSleepMin  = lightSleep - (lightSleepHour*60);
    lightSleepPer  = (100*lightSleep)/duration;
    latencyHour    = latency/60;
    latencyMin     = latency - (latencyHour*60);
    NSLog(@"Latency : %d", latency);
    
    // Calculate Sleep Efficiency
    // true sleep/sleep duration
    efficiency = ((deepSleep+lightSleep)*100)/duration;
    NSLog(@"Sleep Efficiency : %d%%", efficiency);
    
    
    
    
    
    
    
    
    // ------------------------------------------------
    // Step 2 : Calculate Quality
    // ------------------------------------------------
    
    
    // Latency
    if      (latency > 60) { scoreLatency = 3; }
    else if (latency > 30) { scoreLatency = 2; }
    else if (latency > 15) { scoreLatency = 1; }
    // Duration
    if (durationHour<properDurationMin) {
        scoreDuration = properDurationMin - durationHour;
        if (scoreDuration>3) {
            scoreDuration = 3;
        }
    }
    // Efficiency
    if      (efficiency < 65) { scoreEfficiency = 3; }
    else if (efficiency < 75) { scoreEfficiency = 2; }
    else if (efficiency < 85) { scoreEfficiency = 1; }
    
    quality = 100 - (11*scoreLatency) - (11*scoreDuration) - (11*scoreEfficiency);
    NSLog(@"Quality : %d%%", quality);
    NSLog(@"scoreLatency : %d", scoreLatency);
    NSLog(@"scoreDuration : %d", scoreDuration);
    NSLog(@"scoreEfficiency : %d", scoreEfficiency);
    
    
    
    
    
    
    
    // ------------------------------------------------
    // Step 3 : Analyze Avatar Process
    // ------------------------------------------------
    
    
    // Duration
    if (durationHour>properDurationMax) {
        descript = @"Duration : More max(level 2), ";
        codeAvatar = @"2";
    }
    else {
        if (scoreDuration == 0) {
            descript = @"Duration : Good(level 1), ";
            codeAvatar = @"1";
        }
        else if (scoreDuration<3) {
            descript = @"Duration : Less(level 3), ";
            codeAvatar = @"3";
        }
        else {
            descript = @"Duration : Very less(level 4), ";
            codeAvatar = @"4";
        }
    }
    // Deep sleep
    if (  ((deepSleepHour*100)/properDurationMin)   >49) {
        descript = [NSString stringWithFormat:@"%@Deep sleep : Normol(level 1), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@1",codeAvatar];
    }
    else if ( ((deepSleepHour*100)/properDurationMin) >32) {
        descript = [NSString stringWithFormat:@"%@Deep sleep : less(level 2), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@2",codeAvatar];
    }
    else {
        descript = [NSString stringWithFormat:@"%@Deep sleep : Very less(level 3), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@3",codeAvatar];
    }
    // Light sleep
    if ( ((lightSleepHour*100)/properDurationMin) >19) {
        descript = [NSString stringWithFormat:@"%@Light sleep : Normol(level 1), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@1",codeAvatar];
    }
    else if ( ((lightSleepHour*100)/properDurationMin) >13) {
        descript = [NSString stringWithFormat:@"%@Light sleep : less(level 2), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@2",codeAvatar];
    }
    else {
        descript = [NSString stringWithFormat:@"%@Light sleep : Very less(level 3), ",descript];
        codeAvatar = [NSString stringWithFormat:@"%@3",codeAvatar];
    }
    descript = [NSString stringWithFormat:@"%@CodeAvatar : %@",descript, codeAvatar];
    
    
    
    
    
    
    // ------------------------------------------------
    // Step 4 : Set value
    // ------------------------------------------------
    
    self.latencyT = latency;
    self.qualityT = quality;
    self.durationT = duration;
    self.durationdeepT = deepSleep;
    self.durationlightT = lightSleep;
    self.codeavatarT = codeAvatar;
}








// ----------------------------------------------------------------------------
//                              FIND AVATAR-ID
// ----------------------------------------------------------------------------


- (int) findAvatarId {
    
    NSString *query = @"SELECT avatar_id FROM avatar ORDER BY avatar_id DESC LIMIT 1";
    
    NSArray *arrAvatarid = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfavatar_id = [self.dbManager.arrColumnNames indexOfObject:@"avatar_id"];
    
    int avatarid = [ [[arrAvatarid objectAtIndex:0] objectAtIndex:indexOfavatar_id] intValue];

    return avatarid;
}








// ----------------------------------------------------------------------------
//                              FIND USER AGE
// ----------------------------------------------------------------------------


- (int) findUserAge {
    
    // STEP 1 : Get data
    
    NSString *query = @"SELECT user_birthday FROM user ORDER BY user_id DESC LIMIT 1";
    
    NSArray *arrUserBDay = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfuser_birthday = [self.dbManager.arrColumnNames indexOfObject:@"user_birthday"];
    
    NSString *bday = [[arrUserBDay objectAtIndex:0] objectAtIndex:indexOfuser_birthday];
    
    // STEP 2 : Calculate Age
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *prev = [dateFormatter dateFromString:bday];
    NSDate* now = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:prev
                                       toDate:now
                                       options:0];
    int age = [ageComponents year];

    return age;
}





@end
