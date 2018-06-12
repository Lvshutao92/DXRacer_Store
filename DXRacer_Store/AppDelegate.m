//
//  AppDelegate.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YiFuKuan_ViewController.h"
#import "WXApi.h"
#import "PaymentAction.h"


#import "OneVC.h"
#import "LoginViewController.h"
#import "XPPD_ViewController.h"
@interface AppDelegate ()<selectDelegate>
{
    NSInteger count;
}
@property(nonatomic,strong)MainTabbarViewController *mainVC;
@end
//1385994805
UIBackgroundTaskIdentifier taskId;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘处理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    
//    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES){
//        NSDictionary *dic = @{@"passWord":[Manager redingwenjianming:@"password.text"],
//                              @"loginName":[Manager redingwenjianming:@"phone.text"]};
//        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/login") paramDic:dic token:nil finish:^(id responseObject) {
//            NSDictionary *diction = [Manager returndictiondata:responseObject];
//            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
//            if ([code isEqualToString:@"200"]) {
//                [Manager writewenjianming:@"token.text" content:[[diction objectForKey:@"object"]objectForKey:@"token"]];
//                [Manager writewenjianming:@"userid.text" content:[[diction objectForKey:@"object"]objectForKey:@"userId"]];
//            }
//            //NSLog(@"----%@",diction);
//        } enError:^(NSError *error) {
//            NSLog(@"---%@",error);
//        }];
//    }
    
    
    //测试的时候改变info 里的版本号就可以了
    NSArray *images = @[@"gud1.jpg",@"gud2.jpg",@"gud3.jpg",@"gud4.jpg",@"av3.jpg"];
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

    
    
//    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
//        NSLog(@"log : %@", log);
//    }];
//    //向微信注册,发起支付必须注册
//    [WXApi registerApp:@"wxc6a4ecf6eccfc55c"];//注册appid
    
    
    [self initShortcutItems];
    
    
    //进入后台后可继续运行定时器
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(timeFireMethod)userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return YES;
}










-(void)initShortcutItems{
    //快捷菜单的图标
    //这个是系统提供‘添加’图标
    if (@available(iOS 9.0, *)) {
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"item1"
                                                                           localizedTitle:@"去购物车"
                                                                        localizedSubtitle:nil
                                                                                     icon:icon1
                                                                                 userInfo:nil];
        UIApplicationShortcutIcon * icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"a1"];
        UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"item2"
                                                                            localizedTitle:@"查看订单"
                                                                         localizedSubtitle:@""
                                                                                      icon:icon2
                                                                                  userInfo:nil];
        
        
        UIApplicationShortcutIcon * icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"秒杀"];
        UIApplicationShortcutItem * item3 = [[UIApplicationShortcutItem alloc]initWithType:@"item3"
                                                                            localizedTitle:@"抢购秒杀"
                                                                         localizedSubtitle:@""
                                                                                      icon:icon3
                                                                                  userInfo:nil];
        
        
//        UIApplicationShortcutIcon * icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"自定义的图片"];
//        UIApplicationShortcutItem * item4 = [[UIApplicationShortcutItem alloc]initWithType:@"item4"
//                                                                            localizedTitle:@"QQ客服"
//                                                                         localizedSubtitle:@""
//                                                                                      icon:icon4
//                                                                                  userInfo:nil];
        
        
        UIApplicationShortcutIcon * icon5 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"a6"];
        UIApplicationShortcutItem * item5 = [[UIApplicationShortcutItem alloc]initWithType:@"item5"
                                                                            localizedTitle:@"联系我们"
                                                                         localizedSubtitle:@"咨询了解更多信息"
                                                                                      icon:icon5
                                                                                  userInfo:nil];
        
        [[UIApplication sharedApplication] setShortcutItems:@[item1,item2,item3,item5]];
    } else {
        
    }
    /*
     参数一：标示符，书写唯一性，当你点击时需要通过判断与它是否相同进行特定的事件操作
     参数二：大标题
     参数三：小标题，一般用作说明、介绍使用，可不写
     参数四：图标，可设置系统的，也可以设置自定义的（自定义的图片必须是正方形、单色并且尺寸是35*35像素的图片）
     参数五：传一些需求数据
     */
    //设置app的快捷菜单
}

#pragma mark--3DTouch点击事件处理
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(9.0)){
    NSString * type = shortcutItem.type;
    if ([type isEqualToString:@"item1"]) {
        
        self.mainVC.selectedIndex = 2;
        
    }else if ([type isEqualToString:@"item2"]) {
        if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES){
            OneVC *vvv = [[OneVC alloc]init];
            MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
            MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
            [nav pushViewController:vvv animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
            MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
            [nav presentViewController:login animated:YES completion:nil];
        }
    }else if ([type isEqualToString:@"item3"]) {
            XPPD_ViewController *xppd = [[XPPD_ViewController alloc]init];
            xppd.navigationItem.title = @"秒杀专场";
            MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
            MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
            [nav pushViewController:xppd animated:YES];
    }else if ([type isEqualToString:@"item4"]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"309718069"];
        NSURL *url = [NSURL URLWithString:qqstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.window addSubview:webView];
    }else if ([type isEqualToString:@"item5"]) {
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"4009005033"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}













- (void)clickEnter
{
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainVC = [[MainTabbarViewController alloc]init];
    self.mainVC.selectedIndex = 0;
    for (UIBarItem *item in self.mainVC.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
    }
    self.window.rootViewController = self.mainVC;
//    [self.window makeKeyWindow];
//    self.window.rootViewController = vc;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
}

- (void)timeFireMethod{
    //已登录，刷新token
//    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
//        [Manager clickLogin];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //NSLog(@"\n ===> 程序进入后台 !");
    //开启一个后台任务
//    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
//        //结束指定的任务
//        [application endBackgroundTask:taskId];
//    }];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer {
//    count++;
//    if (count % 3600 == 0) {
//        UIApplication *application = [UIApplication sharedApplication];
//        //结束旧的后台任务
//        [application endBackgroundTask:taskId];
//        //开启一个新的后台
//        taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
//        if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
//            [Manager clickLogin];
//        }
//    }
//    NSLog(@"-----%ld",count);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //已登录，刷新token
//    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES) {
//        [Manager clickLogin];
//    }
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



//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    [WXApi handleOpenURL:url delegate:[PaymentAction sharedManager]];
//    return YES;
//}




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
                YiFuKuan_ViewController *vvv = [[YiFuKuan_ViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
                MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
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
                YiFuKuan_ViewController *vvv = [[YiFuKuan_ViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
                MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
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
                YiFuKuan_ViewController *vvv = [[YiFuKuan_ViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
                MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
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
                YiFuKuan_ViewController *vvv = [[YiFuKuan_ViewController alloc]init];
                vvv.orderNo = [[dic objectForKey:@"alipay_trade_app_pay_response"]objectForKey:@"out_trade_no"];
                MainTabbarViewController *tabBarController = (MainTabbarViewController *)self.window.rootViewController;
                MainNavigationViewController *nav = (MainNavigationViewController *)tabBarController.selectedViewController;
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
