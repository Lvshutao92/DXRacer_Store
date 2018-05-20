//
//  TFSheetView.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/17.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "TFSheetView.h"

@interface TFSheetView()
{
    UIView *_contentView;
}
@end



@implementation TFSheetView


- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, screen_Height);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = NO;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    
    
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _contentView.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-120, 50)];
        lab.text = @"请选择支付方式";
        lab.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:lab];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(SCREEN_WIDTH-40, 10, 30, 30);
        [_btn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_btn];
        
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
        [_contentView addSubview:line1];
        
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
        [_contentView addSubview:line2];
        
        
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 65, 40, 40)];
        img1.image = [UIImage imageNamed:@"支付宝支付"];
        [_contentView addSubview:img1];
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 150, 50)];
        lab1.text = @"支付宝支付";
        [_contentView addSubview:lab1];
        
        
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(0, 60, SCREEN_WIDTH, 50);
        [_btn1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_btn1];
        
        
        
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 40, 40)];
        img2.image = [UIImage imageNamed:@"微信支付"];
        [_contentView addSubview:img2];
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 115, 150, 50)];
        lab2.text = @"微信支付";
        [_contentView addSubview:lab2];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(0, 115, SCREEN_WIDTH, 50);
        [_btn2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_btn2];
        
        
        
        
        [self addSubview:_contentView];
    }
}

- (void)click:(UIButton *)sender{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)click1:(UIButton *)sender{
    if (self.zfbBlock) {
        self.zfbBlock();
    }
}
- (void)click2:(UIButton *)sender{
    if (self.wxBlock) {
        self.wxBlock();
    }
}







- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [self->_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [self->_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [self->_contentView removeFromSuperview];
                         
                     }];
    
}







@end
