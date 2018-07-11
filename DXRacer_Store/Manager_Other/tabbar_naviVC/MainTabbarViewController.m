//
//  MainTabbarViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "HomePageViewController.h"
#import "ClassifyViewController.h"
#import "ShoopingCartViewController.h"
#import "PersonViewController.h"

#import "CartViewController.h"
#import "ZhuYe_ViewController.h"
@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UITabBar class]]) {
//            //此处注意设置 y的值 不要使用屏幕高度 - 49 ，因为还有tabbar的高度 ，用当前tabbarController的View的高度 - 49即可
//            view.frame = CGRectMake(view.frame.origin.x, self.view.bounds.size.height-49, view.frame.size.width, 49);
//        }
//    }
//    // 此处是自定义的View的设置 如果使用了约束 可以不需要设置下面,_bottomView的frame
//    //_bottomView.frame = self.tabBar.bounds;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
}
- (instancetype)init {
    if (self = [super init]) {
//        HomePageViewController *oneVc = [[HomePageViewController alloc]init];
        ZhuYe_ViewController *oneVc = [[ZhuYe_ViewController alloc]init];
        
        MainNavigationViewController *mainoneVC = [[MainNavigationViewController alloc]initWithRootViewController:oneVc];
//        oneVc.title = @"首页";
        mainoneVC.tabBarItem.image = [UIImage imageNamed:@"1"];
        mainoneVC.tabBarItem.title = @"首页";
        oneVc.navigationItem.title = @"迪瑞克斯";
        mainoneVC.tabBarItem.selectedImage = [UIImage imageNamed:@"01"];

        ClassifyViewController *twoVc = [[ClassifyViewController alloc]init];
        MainNavigationViewController *maintwoVc = [[MainNavigationViewController alloc]initWithRootViewController:twoVc];
        twoVc.title = @"产品";
        maintwoVc.tabBarItem.image = [UIImage imageNamed:@"2"];
        maintwoVc.tabBarItem.selectedImage = [UIImage imageNamed:@"02"];

       
        CartViewController *threeVc = [[CartViewController alloc]init];
        MainNavigationViewController *mainthreeVC = [[MainNavigationViewController alloc]initWithRootViewController:threeVc];
        threeVc.title = @"购物车";
        mainthreeVC.tabBarItem.image = [UIImage imageNamed:@"3"];
        mainthreeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"03"];

        PersonViewController *fourVc = [[PersonViewController alloc]init];
        MainNavigationViewController *mainfourVC = [[MainNavigationViewController alloc]initWithRootViewController:fourVc];
        fourVc.title = @"我的";
        mainfourVC.tabBarItem.image = [UIImage imageNamed:@"4"];
        mainfourVC.tabBarItem.selectedImage = [UIImage imageNamed:@"04"];

        self.tabBar.tintColor = RGB_AB;
        self.viewControllers = @[mainoneVC,maintwoVc,mainthreeVC,mainfourVC];
    }
    return self;
}




@end
