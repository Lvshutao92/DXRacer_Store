//
//  ProductView.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/14.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductView;

typedef NS_ENUM(NSInteger,ButtonClickType){
    ButtonClickTypeNormal = 0,
    ButtonClickTypeUp = 1,
    ButtonClickTypeDown = 2,
};

@protocol NY_ProducttViewDelegate <NSObject>

@optional
//选中最上方的按钮的点击事件
- (void)selectTopButton:(ProductView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type;
//选中分类中按钮的点击事件
- (void)selectItme:(ProductView *)selectView withIndex:(NSInteger)index;

@end



@interface ProductView : UIView
@property (nonatomic, weak) id<NY_ProducttViewDelegate>delegate;
//默认选中，默认是第一个
@property (nonatomic, assign) int defaultSelectIndex;

//默认选中项，默认是第一个
@property (nonatomic, assign) int defaultSelectItmeIndex;
//设置可选项数组
@property (nonatomic, copy) NSArray *selectItmeArr;

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr;
@end
