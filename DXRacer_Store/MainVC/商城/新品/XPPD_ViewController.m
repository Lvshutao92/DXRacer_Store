//
//  XPPD_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/21.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "XPPD_ViewController.h"

@interface XPPD_ViewController ()

@end

@implementation XPPD_ViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =RGBACOLOR(237, 236, 242, 1);
}

















@end
