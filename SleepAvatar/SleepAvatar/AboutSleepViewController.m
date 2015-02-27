//
//  AboutSleepViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/7/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "AboutSleepViewController.h"

@interface AboutSleepViewController ()

@end

@implementation AboutSleepViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







// ----------------------------------------------------------------------------
//                               BUTTON LEFT-MENU
// ----------------------------------------------------------------------------


- (IBAction)menuButtonTapped:(id)sender {
    ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
