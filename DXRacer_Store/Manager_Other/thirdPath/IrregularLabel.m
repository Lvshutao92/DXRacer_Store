//
//  IrregularLabel.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/3.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "IrregularLabel.h"

@implementation IrregularLabel
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化遮罩
        self.maskLayer = [CAShapeLayer layer];
        // 设置遮罩
        [self.layer setMask:self.maskLayer];
        // 初始化路径
        self.borderPath = [UIBezierPath bezierPath];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 遮罩层frame
    self.maskLayer.frame = self.bounds;
    
    // 设置path起点
    [self.borderPath moveToPoint:CGPointMake(0, 10)];
    // 左上角的圆角
    [self.borderPath addQuadCurveToPoint:CGPointMake(10, 0) controlPoint:CGPointMake(0, 0)];
    // 直线，到右上角
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width - 10, 0)];
    // 右上角的圆角
    [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 10) controlPoint:CGPointMake(self.bounds.size.width, 0)];
    // 直线，到右下角
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    //底部的小三角形
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2+5, self.bounds.size.height)];
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height-5)];
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2-5, self.bounds.size.height)];
    //直线，到左下角
    [self.borderPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    //直线，回到起点
    [self.borderPath addLineToPoint:CGPointMake(0, 10)];
    
    //将这个path赋值给maskLayer的path
    self.maskLayer.path = self.borderPath.CGPath;
}


/*
 - (void)layoutSubviews {
 [super layoutSubviews];
 
 // 遮罩层frame
 self.maskLayer.frame = self.bounds;
 
 
 // 设置path起点
 [self.borderPath moveToPoint:CGPointMake(0, 10)];
 
 // 箭头
 [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2-5, 10)];
 [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 0)];
 [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2+5, 10)];
 
 // 到右上角
 [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, 10)];
 // 到右下角
 [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
 // 到左下角
 [self.borderPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
 // 回到起点
 [self.borderPath addLineToPoint:CGPointMake(0, 10)];
 
 // 将这个path赋值给maskLayer的path
 self.maskLayer.path = self.borderPath.CGPath;
 }
 */









@end
