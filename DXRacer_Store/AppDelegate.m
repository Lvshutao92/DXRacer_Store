//
//  AppDelegate.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ProductOrderDetailsViewController.h"

@interface AppDelegate ()<selectDelegate>
{
    NSInteger count;
}

@end
//1385994805
UIBackgroundTaskIdentifier taskId;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘处理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    
    
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES){
        NSDictionary *dic = @{@"passWord":[Manager redingwenjianming:@"password.text"],
                              @"loginName":[Manager redingwenjianming:@"phone.text"]};
        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/login") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [Manager writewenjianming:@"token.text" content:[[diction objectForKey:@"object"]objectForKey:@"token"]];
                [Manager writewenjianming:@"userid.text" content:[[diction objectForKey:@"object"]objectForKey:@"userId"]];
            }
//            NSLog(@"----%@",diction);
        } enError:^(NSError *error) {
            NSLog(@"---%@",error);
        }];
    }
    
    
    //测试的时候改变info 里的版本号就可以了
    NSArray *images = @[@"gud1.jpg",@"gud2.jpg",@"gud3.jpg", @"av3.jpg"];
    BOOL y = [XTGuidePagesViewController isShow];
    if (y) {
        XTGuidePagesViewController *xt = [[XTGuidePagesViewController alloc] init];
        self.window.rootViewController = xt;
        xt.delegate = self;
        [xt guidePageControllerWithImages:images];
    }else{
        [self clickEnter];
    }
    
    [self requestAuthorizationAddressBook];


    //进入后台后可继续运行定时器
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(timeFireMethod)userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return YES;
}


- (void)clickEnter
{
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabbarViewController *mainVC = [[MainTabbarViewController alloc]init];
    mainVC.selectedIndex = 0;
    for (UIBarItem *item in mainVC.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
    }
    self.window.rootViewController = mainVC;
//    [self.window makeKeyWindow];
//    self.window.rootViewController = vc;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
}

- (void)timeFireMethod{
    //已登录，刷新token
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
        [Manager clickLogin];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //NSLog(@"\n ===> 程序进入后台 !");
    //开启一个后台任务
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        //结束指定的任务
        [application endBackgroundTask:taskId];
    }];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer {
    count++;
    if (count % 3600 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        //结束旧的后台任务
        [application endBackgroundTask:taskId];
        //开启一个新的后台
        taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
        if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
            [Manager clickLogin];
        }
    }
//    NSLog(@"-----%ld",count);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //已登录，刷新token
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
        [Manager clickLogin];
    }
    //NSLog(@"\n ===> 程序重新激活 !");
}
- (void)applicationWillTerminate:(UIApplication *)application {
//    NSLog(@"\n ===> 程序意外暂行 !");
//    [Manager remove:@"phone.text"];
//    [Manager remove:@"password.text"];
//    [Manager remove:@"token.text"];
//    [Manager remove:@"userid.text"];
//    [Manager remove:@"img.text"];
//    [Manager remove:@"nikname.text"];
//    [Manager remove:@"password.text"];
}









//获取联系人
- (void)requestAuthorizationAddressBook {
    // 判断是否授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        // 请求授权
        ABAddressBookRef addressBookRef =  ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {  // 授权成功
                
            } else {        // 授权失败
                NSLog(@"授权失败！");
            }
        });
    }
}






//支付宝支付
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"^^^^^^^^^^^^^^^^^^^ result = %@",resultDic);
            
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *str = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"code"]];
            
            if ([str isEqualToString:@"10000"]) {
                ProductOrderDetailsViewController *vvv = [[ProductOrderDetailsViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                // 取到tabbarcontroller
                UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
                // 取到navigationcontroller
                UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
                [nav pushViewController:vvv animated:YES];
            }
            
            
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"&&&&&&&&&&&&&&&&&&&&&&& result = %@",resultDic);
            
            
            
            
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *str = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"code"]];
            
            if ([str isEqualToString:@"10000"]) {
                ProductOrderDetailsViewController *vvv = [[ProductOrderDetailsViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                // 取到tabbarcontroller
                UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
                // 取到navigationcontroller
                UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
                [nav pushViewController:vvv animated:YES];
            }
            
            
            
            
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"$$$$$$$$$$$$$$$$$$$---result = %@",resultDic);
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *str = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"code"]];
            
            if ([str isEqualToString:@"10000"]) {
                ProductOrderDetailsViewController *vvv = [[ProductOrderDetailsViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                // 取到tabbarcontroller
                UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
                // 取到navigationcontroller
                UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
                [nav pushViewController:vvv animated:YES];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//       NSLog(@"--------------------------------result = %@",resultDic);
            
            
            NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *str = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"code"]];
            
            if ([str isEqualToString:@"10000"]) {
                ProductOrderDetailsViewController *vvv = [[ProductOrderDetailsViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                // 取到tabbarcontroller
                UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
                // 取到navigationcontroller
                UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
                [nav pushViewController:vvv animated:YES];
            }
            
            
            
            
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

















- (void)applicationWillEnterForeground:(UIApplication *)application {
    //NSLog(@"\n ===> 程序进入前台 !");
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //NSLog(@"\n ===> 程序暂行 !");
}
@end
