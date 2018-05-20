//
//  GetACouponCell.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/3.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "GetACouponCell.h"

@implementation GetACouponCell

- (UIView *)bgview {
    if (_bgview == nil) {
        self.bgview = [[UIView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 150)];
        LRViewBorderRadius(self.bgview, 8, 0, [UIColor clearColor]);
        self.bgview.backgroundColor = [UIColor whiteColor];
    }
    return _bgview;
}

- (IrregularLabel *)label{
    if (_label == nil) {
        self.label = [[IrregularLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        self.label.text = @"  满减券";
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.backgroundColor = RGBACOLOR(255, 163, 71, 1);
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:16];
    }
    return _label;
}

- (UILabel *)lab1{
    if (_lab1 == nil) {
        self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 20, 30)];
        self.lab1.textColor = [UIColor blackColor];
        self.lab1.text = @"¥";
        self.lab1.font = [UIFont systemFontOfSize:16];
    }
    return _lab1;
}

- (UILabel *)lab2{
    if (_lab2 == nil) {
        self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(35, 60, 80, 40)];
        self.lab2.textColor = [UIColor blackColor];
        self.lab2.text = @"30.00";
        self.lab2.font = [UIFont systemFontOfSize:26];
    }
    return _lab2;
}
- (UILabel *)lab3{
    if (_lab3 == nil) {
        self.lab3 = [[UILabel alloc]initWithFrame:CGRectMake(115, 70, 120, 20)];
        self.lab3.textColor = [UIColor grayColor];
        self.lab3.text = @"满2000元可用";
        self.lab3.font = [UIFont systemFontOfSize:16];
    }
    return _lab3;
}


- (UIButton *)btn{
    if (_btn == nil) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(SCREEN_WIDTH-130, 60, 100, 40);
        [self.btn setTitle:@"立即领取" forState:UIControlStateNormal];
        LRViewBorderRadius(self.btn, 10, 0, [UIColor clearColor]);
        self.btn.backgroundColor = [UIColor orangeColor];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _btn;
}



- (UILabel *)line{
    if (_line == nil) {
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH-20, 1)];
        self.line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.35];
    }
    return _line;
}
- (UILabel *)lab4{
    if (_lab4 == nil) {
        self.lab4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, SCREEN_WIDTH-40, 30)];
        self.lab4.textColor = [UIColor grayColor];
        self.lab4.textAlignment = NSTextAlignmentRight;
        self.lab4.text = @"领取1天内有效";
        self.lab4.font = [UIFont systemFontOfSize:16];
    }
    return _lab4;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bgview addSubview:self.label];
        [self.bgview addSubview:self.lab1];
        [self.bgview addSubview:self.lab2];
        [self.bgview addSubview:self.lab3];
        [self.bgview addSubview:self.btn];
        [self.bgview addSubview:self.line];
        [self.bgview addSubview:self.lab4];
        [self.contentView addSubview:self.bgview];
    }
    return self;
}



@end
