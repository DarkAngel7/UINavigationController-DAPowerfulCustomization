//
//  ViewController.m
//  UINavigationController+DAPowerfulCustomization
//
//  Created by DarkAngel on 2017/7/11.
//  Copyright © 2017年 DarkAngel. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+DAPowerfulCustomization.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.da_navigationBarHidden = YES;
    self.navigationItem.da_statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
