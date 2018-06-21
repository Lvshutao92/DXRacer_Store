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
    
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollview];
    
    
    
    
    NSString *string = @"    迪瑞克斯座椅（江阴）有限公司成立于2015年，旗下品牌迪瑞克斯（DXRacer）是全球知名座椅领导品牌，以追求高品质生活和以人为本的设计理念，围绕着“人体工程学”这一专业领域，倡导健康、正确的计算机操作空间，寻求促进健康意识的计算机操作的创新解决方案。\n    迪瑞克斯（DXRacer）致力于为全球用户提供中高端电脑椅、办公椅以及人体工学等设备。其产品远销欧美40余个国家，在全球电竞圈与办公领域颇有盛名，有着电竞椅之王的美誉。\n    DXRacer目前已同步销售十多个电脑椅系列，每个系列拥有不同的设计元素，针对不同的用户群体。生产工艺日益创新，平均每季度会推出新款，更新升级经典款，凭借着追求品质和以人为本的设计理念，DXRacer座椅日渐深受各领域玩家的喜爱。\n    尤其在电竞领域，迪瑞克斯不仅成为WCG、LPL、IEM、StarsWar、ESL等世界各大电竞赛事的赞助商，还是SKT、NAVI、NIP、EDG等世界知名战队合作伙伴，为众多职业选手和电竞粉丝的首选装备。\n    一直以来，公司都倡导健康的生活环境，将不断创新并造就出更多提升人们生活品质的产品，也坚信迪瑞克斯（DXRacer）产品将走进许多人的生活，为更多的人造就健康的操作空间。";
    UILabel *titLab = [[UILabel alloc]init];
    titLab.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    titLab.text = string;
    titLab.numberOfLines = 0;
    titLab.font = [UIFont systemFontOfSize:18];
    [Manager changeLineSpaceForLabel:titLab WithSpace:8];
    CGFloat height = [self getHeightLineWithString:string withWidth:SCREEN_WIDTH-20 withFont:[UIFont systemFontOfSize:18]];
    titLab.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, height);
    [self.scrollview addSubview:titLab];
    
    self.scrollview.contentSize = CGSizeMake(0, SCREEN_HEIGHT*1.1);
    
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
