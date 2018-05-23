//
//  XPPD_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/21.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "XPPD_ViewController.h"

@interface XPPD_ViewController ()
@property(nonatomic,strong)UIWebView *webview;
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
    
    
//    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"下划线" attributes:attribtDic];
//
//    label1.attributedText = attribtStr;
//    [self.view addSubview:label1];
    
//    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
//    NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//
//    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:@"中划线" attributes:attribtDic2];
//    label2.attributedText = attribtStr2;
//
//    [self.view addSubview:label2];
    
    
    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://player.youku.com/embed/XMzQ0MDE5OTEzMg=="]];
    [self.webview loadRequest:request];
    [self.view addSubview:self.webview];
    
    
}








//String(format: "<iframe height='180' width='320' src='http://player.youku.com/embed/XMzQ0MDE5OTEzMg==' frameborder=0 allowfullscreen></iframe>")








@end
