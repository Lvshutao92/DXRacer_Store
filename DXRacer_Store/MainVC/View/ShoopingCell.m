//
//  ShoopingCell.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//


#import "ShoopingCell.h"

@interface ShoopingCell()



@end



@implementation ShoopingCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(245, 246, 248);
        
        [self setupMainView];
    }
    return self;
}
//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}

// 数量加按钮
-(void)addBtnClick
{
    if (self.numAddBlock) {
        self.numAddBlock();
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}

-(void)reloadDataWith:(Model *)model
{
    
//    NSLog(@"---%@",NSString(model.image));
   
    [self.imageView_cell sd_setImageWithURL:[NSURL URLWithString:NSString(model.image)]placeholderImage:[UIImage imageNamed:@"yizi.jpg"]];
    
    self.nameLabel.text = model.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.salePrice];

    self.numberLabel.text = model.quantity;
    self.sizeLabel.text = model.productAttr;

    self.dateLabel.text = [NSString stringWithFormat:@"¥ %.2f",[model.quantity doubleValue] * [model.salePrice doubleValue]];
    
    
    
    self.selectBtn.selected = self.isSelected;
    
    
    
    model.number = [model.quantity integerValue];
}




-(void)setupMainView
{
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = kUIColorFromRGB(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(5, 36, 28, 28);
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.selectBtn setImage:theImage forState:UIControlStateSelected];
    [self.selectBtn setTintColor:[UIColor redColor]];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.selectBtn];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(40, 5, 60, 90);
    imageBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:imageBgView];
    
    //显示照片
    self.imageView_cell = [[UIImageView alloc]init];
    self.imageView_cell.frame = CGRectMake(40.1, 5.1, 59.8, 89.8);
    //    self.imageView_cell.image = [UIImage imageNamed:@"default_pic_1"];
    self.imageView_cell.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView_cell.clipsToBounds = YES;
    [bgView addSubview:self.imageView_cell];
    
    
    
    
    //商品名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = CGRectMake(105, 5, SCREEN_WIDTH-210, 30);
    self.imageView_cell.frame = CGRectMake(40, 5, 60, 90);
    //    self.nameLabel.text = @"海报";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.nameLabel];
    
    //尺寸
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.frame = CGRectMake(105, 45, 140, 20);
    //    self.sizeLabel.text = @"尺寸:58*86cm";
    self.sizeLabel.textColor = RGBCOLOR(132, 132, 132);
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:self.sizeLabel];
    
    //时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.frame = CGRectMake(105, 75, 100, 20);
    self.dateLabel.font = [UIFont systemFontOfSize:16];
    self.dateLabel.textColor = [UIColor redColor];
    //    self.dateLabel.text = @"2015-12-03 17:49";
    [bgView addSubview:self.dateLabel];
    
    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH-105, 5, 100, 30);
    //    self.priceLabel.text = @"￥100.11";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.priceLabel];
    
    //数量加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(SCREEN_WIDTH-40, 65, 30, 30);
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.addBtn];
    
    //数量减按钮
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(SCREEN_WIDTH-120, 65, 30, 30);
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [self.cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.frame = CGRectMake(SCREEN_WIDTH-90, 65, 50, 30);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    
    self.numberLabel.layer.borderColor = [UIColor colorWithWhite:.5 alpha:.5].CGColor;
    self.numberLabel.layer.borderWidth = 1;
    
    [bgView addSubview:self.numberLabel];
    
}

@end
