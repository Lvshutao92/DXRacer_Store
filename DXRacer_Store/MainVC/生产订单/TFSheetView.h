//
//  TFSheetView.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/17.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^CabcelBlock)(void);

typedef void(^WeixinBlock)(void);

typedef void(^ZhifubaoBlock)(void);


@interface TFSheetView : UIView
- (void)showInView:(UIView *)view;
- (void)disMissView;

@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;



@property (nonatomic,strong)CabcelBlock cancelBlock;

@property (nonatomic,strong)WeixinBlock wxBlock;

@property (nonatomic,strong)ZhifubaoBlock zfbBlock;


@end
