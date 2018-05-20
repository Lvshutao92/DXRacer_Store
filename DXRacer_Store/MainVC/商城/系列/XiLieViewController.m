//
//  XiLieViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/2.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "XiLieViewController.h"
#import "ProductView.h"
@interface XiLieViewController ()<NY_ProducttViewDelegate>
@property (nonatomic, strong) ProductView *selectView;
@property (nonatomic, copy) NSArray *dataArr;


@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation XiLieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.selectView];
    self.dataArray = [@[@"https://img-website.dxracer.com.cn/advert/ec90b7b0f4e20df36268c835c73bae8d.jpg",
                        @"https://img-website.dxracer.com.cn/advert/ffe4ce4ee62a75612b8af86acb6fea30.jpg",
                        @"https://img-website.dxracer.com.cn/advert/30b7e22ce68f7374a5b616fb256af5ae.jpg",
                        @"https://img-website.dxracer.com.cn/advert/8729b887542db7710f3cb018983f16ff.jpg",
                        @"https://img-website.dxracer.com.cn/advert/ec90b7b0f4e20df36268c835c73bae8d.jpg",
                        @"https://img-website.dxracer.com.cn/advert/ffe4ce4ee62a75612b8af86acb6fea30.jpg",
                        @"https://img-website.dxracer.com.cn/advert/30b7e22ce68f7374a5b616fb256af5ae.jpg",
                        ]mutableCopy];
    
}
#pragma mark NY_SelectViewDelegate
-(void)selectItme:(ProductView *)selectView withIndex:(NSInteger)index{
    //index代表选中的品类，0是全部。
    if (index == 0) {
        NSLog(@"分类中的全部");
    }else{
        NSLog(@"分类中的其他");
    }
}
-(void)selectTopButton:(ProductView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType)type1{
    //价格
    if (index == 102&&type1) {
        switch (type1) {
            case ButtonClickTypeNormal:
                //正常价格
            {
                NSLog(@"上边按钮的正常价格");
            }
                break;
            case ButtonClickTypeUp:
                //价格升序排列
            {
                NSLog(@"上边按钮的价格升序排列");
            }
                break;
            case ButtonClickTypeDown:
                //价格降序排列
            {
                NSLog(@"上边按钮的价格降序排列");
            }
                break;
            default:
                break;
        }
    }else if (index == 100){//综合
        NSLog(@"上边按钮的综合");
    }else if (index == 101){//促销
        NSLog(@"上边按钮的促销");
    }else{//全部
        NSLog(@"上边按钮的全部");
    }
}
#pragma mark 懒加载
-(ProductView *)selectView{
    if (!_selectView) {
        CGFloat hei;
        if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
            hei = 88;
        }else{
            hei = 64;
        }
        _selectView = [[ProductView alloc]initWithFrame:CGRectMake(0, hei, [UIScreen mainScreen].bounds.size.width, 40) withArr:nil];
        _selectView.delegate = self;
    }
    _selectView.selectItmeArr = _dataArr;
    return _selectView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
@end
