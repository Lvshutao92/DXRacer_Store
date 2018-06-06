//
//  AboutUsViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/3.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property(nonatomic,strong)UIScrollView *scrollview;
@end

@implementation AboutUsViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    
    
//    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:self.scrollview];
    
    
    
    
    NSString *string = @"   DXRacer电脑椅是一款非常流行的配合电脑使用的专业座椅。通常来说，桌子、椅子、计算机即构成最基本的工作站系统。可以说，小到每户家庭，大到每所学校、每家公司、每间网吧，都有自己的工作站系统。更广义上来讲，工作站不仅包括计算机硬件设备、配套工作平台、作业辅助工具、扩展装置和设备，还包括周边环境（如光线），甚至您个人常用的物件（如桌台或书架上的一本常用专业书籍，或是桌脚旁的CD架），等等。DXRacer电脑椅就是这个系统中的重要一部分。它的设计非常符合人体工程学国际标准，因此在国内外十分流行。";
    UILabel *titLab = [[UILabel alloc]init];
    titLab.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    titLab.text = string;
    titLab.numberOfLines = 0;
    titLab.font = [UIFont systemFontOfSize:18];
    [Manager changeLineSpaceForLabel:titLab WithSpace:8];
    CGFloat height = [self getHeightLineWithString:string withWidth:SCREEN_WIDTH-20 withFont:[UIFont systemFontOfSize:18]];
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 88;
    }else{
        hei = 64;
    }
    titLab.frame = CGRectMake(10, hei+10, SCREEN_WIDTH-20, height);
    [self.view addSubview:titLab];
    
    
    
}










#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}



@end
