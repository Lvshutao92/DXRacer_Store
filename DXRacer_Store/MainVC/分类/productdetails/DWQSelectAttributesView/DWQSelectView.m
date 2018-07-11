//
//  DWQSelectView.m
//  DWQSelectAttributes
//
//  Created by 杜文全 on 15/5/21.
//  Copyright © 2015年 com.sdzw.duwenquan. All rights reserved.
//

#import "DWQSelectView.h"
@interface DWQSelectView ()

//规格分类
@property(nonatomic,strong)NSArray *rankArr;

@end
@implementation DWQSelectView

@synthesize alphaView,whiteView,headImage,LB_detail,LB_line,LB_price,LB_stock,LB_showSales,mainscrollview,cancelBtn,addBtn,buyBtn,stockBtn,numberButton,LB_kucun;

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //self.showSales = @"135";
        [self creatUI];
        
    }
    return self;
}



-(void)creatUI{
    //半透明视图
    alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.3;
    [self addSubview:alphaView];
    
    //装载商品信息的视图
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, screen_Width, screen_Height-200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //商品图片
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, -20, 90, 90)];
    headImage.layer.cornerRadius = 4;
    headImage.backgroundColor = [UIColor whiteColor];
    headImage.contentMode = UIViewContentModeScaleAspectFit;
    LRViewBorderRadius(headImage, 5, 1, [UIColor colorWithWhite:.8 alpha:.3]);
    [whiteView addSubview:headImage];
    
    cancelBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(screen_Width-40, 10, 30, 30);
    LRViewBorderRadius(cancelBtn, 15, 1, [UIColor grayColor]);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:0];
    [whiteView addSubview:cancelBtn];
    
    
    //商品价格
    LB_price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+20, 10, 150, 20)];
//    LB_price.text = @"¥100";
    LB_price.textColor = RGB_AB;
    LB_price.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:LB_price];
    
    
    
    
    
    
    LB_stock = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+20, CGRectGetMaxY(LB_price.frame), 120, 20)];
    LB_stock.textColor = [UIColor grayColor];
    LB_stock.font = [UIFont systemFontOfSize:10];
    [whiteView addSubview:LB_stock];
    
    
    
    LB_kucun = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+140, CGRectGetMaxY(LB_price.frame), SCREEN_WIDTH-CGRectGetMaxX(headImage.frame)-120, 20)];
    LB_kucun.textColor = RGB_AB;
    LB_kucun.font = [UIFont systemFontOfSize:14];
    LB_kucun.text = @"";
    [whiteView addSubview:LB_kucun];
    
    
    //已售件数
    LB_showSales = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(LB_stock.frame), CGRectGetMaxY(LB_stock.frame), 100, 20)];
    LB_showSales.textColor = RGB_AB;
    
//    NSString *sellStr = [NSString stringWithFormat:@"已售 %@ 件",self.showSales];
    
//    NSDictionary*subStrAttribute = @{
//                                     NSForegroundColorAttributeName: [UIColor redColor],
//                                     };
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:sellStr];
//    [attributedText setAttributes:subStrAttribute range:NSMakeRange([sellStr rangeOfString:[self.showSales description]].location, [sellStr rangeOfString:[self.showSales description]].length)];
//       //[attributedText setAttributes:subStrAttribute range:NSMakeRange(3, 2)];
//    LB_showSales.attributedText = attributedText;
    //LB_showSales.text=sellStr;
    
    LB_showSales.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:LB_showSales];
    
    //用户所选择商品的尺码和颜色
    LB_detail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+20, CGRectGetMaxY(LB_stock.frame), 150, 20)];
    LB_detail.text = @"请选择 尺码 颜色分类";
    LB_detail.numberOfLines = 0;
    LB_detail.textColor = RGB_AB;
    LB_detail.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:LB_detail];
    //分界线
    LB_line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame)+10, screen_Width, 0.5)];
    LB_line.backgroundColor = BackgroundColor;
    [whiteView addSubview:LB_line];
    
    //加入购物车按钮
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, whiteView.dwq_height-50, whiteView.frame.size.width, 50);
    
    [addBtn setBackgroundColor:RGB_AB];
    [addBtn setTitleColor:[UIColor whiteColor] forState:0];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn setTitle:@"加入购物车" forState:0];
    [whiteView addSubview:addBtn];
    
    
  
    
    
    
    //立即购买按钮
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(whiteView.frame.size.width/2,  whiteView.dwq_height-50, whiteView.frame.size.width/2, 50);
    [buyBtn setBackgroundColor:RGB_AB];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:0];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyBtn setTitle:@"立即购买" forState:0];
//    [whiteView addSubview:buyBtn];
    
    //库存不足按钮
    stockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stockBtn.frame = CGRectMake(0,  whiteView.dwq_height-40, screen_Width, 40);
    [stockBtn setBackgroundColor:[UIColor lightGrayColor]];
    [stockBtn setTitleColor:[UIColor blackColor] forState:0];
    stockBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [stockBtn setTitle:@"库存不足" forState:0];
    [whiteView addSubview:stockBtn];
    //默认隐藏
    stockBtn.hidden = YES;
    
    //有的商品尺码和颜色分类特别多 所以用UIScrollView 分类过多显示不全的时候可滑动查看
    mainscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame)+10, screen_Width, whiteView.dwq_height-CGRectGetMaxY(headImage.frame)-60)];
    mainscrollview.backgroundColor = [UIColor clearColor];
//    mainscrollview.contentSize = CGSizeMake(0, 200);
    mainscrollview.showsHorizontalScrollIndicator = NO;
    mainscrollview.showsVerticalScrollIndicator = NO;
    [whiteView addSubview:mainscrollview];
    
    
    numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numberButton.frame = CGRectMake(whiteView.frame.size.width/2,  whiteView.dwq_height-90, whiteView.frame.size.width/2, 40);
    [whiteView addSubview:numberButton];
    
}





@end
