//
//  CouponsViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/3.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "CouponsViewController.h"


//获取控制器的宽高
#define MeH self.view.frame.size.height
#define MeW self.view.frame.size.width
@interface CouponsViewController ()

@end

@implementation CouponsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(instancetype)initWithAddVCARY:(NSArray *)VCS TitleS:(NSArray *)TitleS index:(NSInteger)index{
    if (self = [super init]) {
        _VCAry = VCS;
        _TitleAry = TitleS;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        //先初始化各个界面
        UIView *BJView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MeW, 50)];
        BJView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:BJView];
        
        
        for (int i = 0 ; i<_VCAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(MeW/_VCAry.count), 0, MeW/_VCAry.count, BJView.frame.size.height-2);
            [btn setTitle:_TitleAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            if (i == index) {
                btn.selected = YES;
            }
            
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(SeleScrollBtn:) forControlEvents:UIControlEventTouchUpInside];
            [BJView addSubview:btn];
            
        }
        
        _LineView = [[UIView alloc] initWithFrame:CGRectMake(MeW/_VCAry.count*index, BJView.frame.size.height-2, MeW/_VCAry.count, 2)];
        _LineView.backgroundColor = [UIColor redColor];
        [BJView addSubview:_LineView];
        
        
        _MeScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height, MeW, MeH-BJView.frame.size.height-44)];
        _MeScroolView.backgroundColor = [UIColor whiteColor];
        _MeScroolView.pagingEnabled = YES;
        _MeScroolView.delegate = self;
        [self.view addSubview:_MeScroolView];
        
        
        for (int i2 = 0; i2<_VCAry.count; i2++) {
            UIView *view = [[_VCAry objectAtIndex:i2] view];
            view.frame = CGRectMake(i2*MeW, 0, MeW, _MeScroolView.frame.size.height);
            [_MeScroolView addSubview:view];
            [self addChildViewController:[_VCAry objectAtIndex:i2]];
            
        }
        
        
        _MeScroolView.contentOffset = CGPointMake(index*MeW, 0);
        
        
        [_MeScroolView setContentSize:CGSizeMake(MeW*_VCAry.count, _MeScroolView.frame.size.height)];
        
    }
    return self;
}

/**
 *  滚动停止调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    //    NSLog(@"当前第几页====%d",index);
    
    
    
    /**
     *  此方法用于改变x轴
     */
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self->_LineView.frame;
        f.origin.x = index*(MeW/self->_VCAry.count);
        self->_LineView.frame = f;
    }];
    
    UIButton *btn = [self.view viewWithTag:1000+index];
    for (UIButton *b in btn.superview.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = (b==btn)?YES:NO;
        }
    }
    
}

//点击每个按钮然后选中对应的scroolview页面及选中按钮
-(void)SeleScrollBtn:(UIButton*)btn{
    for (UIButton *button in btn.superview.subviews)
    {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button != btn) ? NO : YES;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self->_LineView.frame;
        f.origin.x = (btn.tag-1000)*(MeW/self->_VCAry.count);
        self->_LineView.frame = f;
        self->_MeScroolView.contentOffset = CGPointMake((btn.tag-1000)*MeW, 0);
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.title = @"我的优惠券";
}
@end
