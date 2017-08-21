//
//  CustomizationViewController.m
//  UINavigationController+DAPowerfulCustomization
//
//  Created by DarkAngel on 2017/7/11.
//  Copyright © 2017年 DarkAngel. All rights reserved.
//

#import "CustomizationViewController.h"
#import "UINavigationController+DAPowerfulCustomization.h"

static NSString *const kBackgroundViewAlphaSegueId = @"BackgroundViewAlpha";

@interface CustomizationViewController ()

@end

@implementation CustomizationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupAutomaticallyUpdateNavigationItemConfiguration];
}

- (void)setupAutomaticallyUpdateNavigationItemConfiguration
{
    DANavigationItemUpdate *bgUpdate = [DANavigationItemUpdate updateWithNavigationItemKeyPath:@"da_navigationBarBackgroundViewAlpha" fromValue:@0 toValue:@1];
    DANavigationItemUpdate *statusBarUpdate = [DANavigationItemUpdate updateWithNavigationItemKeyPath:@"da_statusBarStyle" fromValue:@(UIStatusBarStyleDefault) toValue:@(UIStatusBarStyleLightContent)];
    DANavigationItemUpdate *tintColorUpdate = [DANavigationItemUpdate updateWithNavigationItemKeyPath:@"da_navigationBarTintColor" fromValue:[UIColor blackColor] toValue:[UIColor redColor]];
    DANavigationItemUpdate *barButtonItemUpdate = [DANavigationItemUpdate updateWithNavigationItemKeyPath:@"rightBarButtonItem" fromValue:self.navigationItem.rightBarButtonItem toValue:nil];
    DANavigationItemUpdate *titleAlphaItemUpdate = [DANavigationItemUpdate updateWithNavigationItemKeyPath:@"da_navigationBarTitleTextAttributes" fromValue:@{NSForegroundColorAttributeName: [UIColor greenColor]} toValue:@{NSForegroundColorAttributeName: [[UIColor greenColor] colorWithAlphaComponent:0]}];
    DANavigationItemUpdatesConfiguration *configuration = [DANavigationItemUpdatesConfiguration configurationWithObservedScrollView:self.tableView triggerOffset:CGPointMake(0, 200) navigationItemUpdates:@[bgUpdate, statusBarUpdate,tintColorUpdate, barButtonItemUpdate, titleAlphaItemUpdate]];
    self.da_navigationItemUpdatesConfiguration = configuration;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationVC = segue.destinationViewController;
    destinationVC.view.backgroundColor = [UIColor blueColor];
    UITableViewCell *cell = sender;
    UILabel *propertyLabel = [cell viewWithTag:999];
    NSString *key = [NSString stringWithFormat:@"da_%@", propertyLabel.text];
    id value;
    if ([segue.identifier isEqualToString:kBackgroundViewAlphaSegueId]) {
        UITextField *alphaTextField = [cell viewWithTag:1000];
        value = alphaTextField.text.length ? @(alphaTextField.text.doubleValue) : @1;
    }
    [destinationVC.navigationItem setValue:value forKey:key];
}


@end
