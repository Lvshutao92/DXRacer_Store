//
//  CartTableViewCell.m
//  ArtronUp
//
//  Created by Artron_LQQ on 15/12/1.
//  Copyright © 2015年 ArtronImages. All rights reserved.
//

#import "CartTableViewCell.h"
//#import "LQQPictureManager.h"

@interface CartTableViewCell ()

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *imageView_cell;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//时间
@property (nonatomic,retain) UILabel *dateLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

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

-(void)reloadDataWith:(CartModel*)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView_cell sd_setImageWithURL:[NSURL URLWithString:NSString(model.image)]placeholderImage:[UIImage imageNamed:@""]];
    });
    //NSLog(@"------%@",NSString(model.image));
    
    self.nameLabel.text = model.productName;
    
    
    
    
    
    
    
    if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
        self.priceLabel.text = model.promotionTitle;
        self.nameLabel.frame = CGRectMake(160, 5, SCREEN_WIDTH-170, 20);
        self.sizeLabel.frame = CGRectMake(160, 35, SCREEN_WIDTH-170, 20);
        
        if ([Manager widthForString:model.promotionTitle fontSize:14 andHeight:20] > (SCREEN_WIDTH-180)) {
             self.priceLabel.frame = CGRectMake(160, 65, SCREEN_WIDTH-180, 20);
        }else{
             self.priceLabel.frame = CGRectMake(160, 65, [Manager widthForString:model.promotionTitle fontSize:14 andHeight:20]+10, 20);
        }
        
    }else{
        self.priceLabel.text = @"";
        self.nameLabel.frame = CGRectMake(160, 5, SCREEN_WIDTH-170, 50);
        self.sizeLabel.frame = CGRectMake(160, 65, SCREEN_WIDTH-170, 20);
        
        self.priceLabel.frame = CGRectMake(160, 65, 100, 0);
    }
    
    
    
    self.dateLabel.text = [Manager jinegeshi:model.salePrice];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.quantity];
    self.sizeLabel.text = model.productAttr;
    
    
    self.selectBtn.selected = self.isSelected;
}
-(void)setupMainView
{
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = kUIColorFromRGB(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.selectBtn];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    
    imageBgView.contentMode = UIViewContentModeScaleAspectFill;
    imageBgView.clipsToBounds = YES;
    
    [bgView addSubview:imageBgView];
    
    //显示照片
    self.imageView_cell = [[UIImageView alloc]init];
//    self.imageView_cell.image = [UIImage imageNamed:@"default_pic_1"];
    self.imageView_cell.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView_cell.clipsToBounds = YES;
    [bgView addSubview:self.imageView_cell];
    
    //商品名
    self.nameLabel = [[UILabel alloc]init];
//    self.nameLabel.text = @"海报";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.numberOfLines = 0;
    [bgView addSubview:self.nameLabel];
    
    //尺寸
    self.sizeLabel = [[UILabel alloc]init];
//    self.sizeLabel.text = @"尺寸:58*86cm";
    self.sizeLabel.textColor = RGBCOLOR(132, 132, 132);
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:self.sizeLabel];
    
    //时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:18];
    self.dateLabel.textColor = [UIColor redColor];
//    self.dateLabel.text = @"2015-12-03 17:49";
    [bgView addSubview:self.dateLabel];
    
//    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:12];
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.backgroundColor = [UIColor redColor];
    LRViewBorderRadius(self.priceLabel, 10, 0, [UIColor clearColor]);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.priceLabel];
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.numberLabel];
    
#pragma mark - 添加约束

    //白色背景
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-0);
        
    }];
    
    
    self.selectBtn.frame = CGRectMake(5, 50, 30, 30);
    imageBgView.frame = CGRectMake(35, 5, 120, 120);
    [self.imageView_cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBgView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    self.nameLabel.frame = CGRectMake(160, 5, SCREEN_WIDTH-170, 20);
    self.sizeLabel.frame = CGRectMake(160, 35, SCREEN_WIDTH-170, 20);
    self.priceLabel.frame = CGRectMake(160, 65, 100, 20);
    //选中按钮
//    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bgView).offset(5);
//        make.centerY.equalTo(bgView);
//        make.width.equalTo(@30);
//        make.height.equalTo(@30);
//    }];
    
    //图片背景
//    [imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView).offset(5);
//        make.left.equalTo(self.selectBtn.mas_right).offset(5);
//        make.bottom.equalTo(bgView).offset(-5);
//        make.width.equalTo(imageBgView.mas_height);
//    }];
    
    //显示图片
//    [self.imageView_cell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(imageBgView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
//    }];
    
    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageBgView.mas_right).offset(5);
//        make.top.equalTo(bgView).offset(10);
//        make.height.equalTo(@20);
//        make.right.equalTo(bgView).offset(10);
//    }];
  
//    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageBgView.mas_right).offset(5);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
//        make.height.equalTo(@20);
//        make.right.equalTo(bgView).offset(10);
//    }];
    
    
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageBgView.mas_right).offset(5);
//        make.top.equalTo(self.sizeLabel.mas_bottom).offset(10);
//        make.height.equalTo(@20);
//        make.width.equalTo(@80);
//    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgView.mas_right).offset(5);
        make.bottom.equalTo(bgView).offset(-10);
        make.height.equalTo(@20);
        make.right.equalTo(cutBtn.mas_left);
    }];
    //数量加按钮
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-5);
        make.bottom.equalTo(bgView).offset(-10);
        make.height.equalTo(@25);
        make.width.equalTo(@25);
    }];

    //数量显示
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left);
        make.bottom.equalTo(addBtn);
        make.width.equalTo(@40);
        make.height.equalTo(addBtn);
    }];

    //数量减按钮
    [cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberLabel.mas_left);
        make.height.equalTo(addBtn);
        make.width.equalTo(addBtn);
        make.bottom.equalTo(addBtn);
    }];
}
@end
