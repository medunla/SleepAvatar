//
//  NavigationViewController.m
//  SleepAvatar
//
//  Created by panupatnew on 2/3/2558 BE.
//  Copyright (c) 2558 medunla. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface NavigationViewController ()

@property (strong,nonatomic) NSArray *menu;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end

@implementation NavigationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set menu
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    self.menu = @[@"zero", @"one", @"two", @"three"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








// ----------------------------------------------------------------------------
//                                TABLE CELL
// ----------------------------------------------------------------------------


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}








// ----------------------------------------------------------------------------
//                                  BUTTON GO HOME
// ----------------------------------------------------------------------------


- (IBAction)ButtonToAvatar:(id)sender {
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AvatarViewController"];
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
