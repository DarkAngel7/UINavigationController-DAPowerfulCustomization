//
//  CustomizationViewController.m
//  UINavigationController+DAPowerfulCustomization
//
//  Created by DarkAngel on 2017/7/11.
//  Copyright © 2017年 DarkAngel. All rights reserved.
//

#import "CustomizationViewController.h"

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
    UITableViewCell *cell = sender;
    UILabel *propertyLabel = [cell viewWithTag:999];
    NSString *key = [NSString stringWithFormat:@"da_%@", propertyLabel.text];
    id value;
    if ([segue.identifier isEqualToString:kBackgroundViewAlphaSegueId]) {
        UITextField *alphaTextField = [cell viewWithTag:1000];
        value = @(alphaTextField.text.doubleValue);
    }
    [destinationVC.navigationItem setValue:value forKey:key];
}


@end
