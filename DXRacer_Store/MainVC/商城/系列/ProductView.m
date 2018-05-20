//
//  ProductView.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/14.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ProductView.h"
#import "UIButton+ImageTitleStyle.h"
#import "NY_SelectCollectionViewCell.h"
#import "Masonry.h"
#import <objc/runtime.h>

#ifndef RGBA
#define RGBA(r,g,b,a)           \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif





static NSString  *const NY_SelectCollectionViewCellID = @"NY_SelectCollectionViewCell";
static char *const btnKey = "btnKey";



@interface ProductView()
{
    BOOL show;
}
@property (nonatomic, strong) UICollectionView *collect;
@end

@implementation ProductView

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray *)arr{
    self = [super initWithFrame:frame];
    if (self) {
        //        _selectItmeArr = arr;
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    //    [self createCollectionView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    UIView *mainView = [[UIView alloc]init];
    mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    //    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(50);
    //        make.left.right.equalTo(self);
    //        make.top.mas_equalTo(hei);
    //    }];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = RGBA(222, 222, 222, 1);
    [self addSubview:topLine];
    //    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(0.5);
    //        make.left.right.equalTo(mainView);
    //        make.top.mas_equalTo(mainView.mas_bottom);
    //    }];
    
    NSArray *titleArr = @[@"综合",@"最新",@"价格",@"销量"];
    for (int i = 0; i < 4; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, 50);
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArr[i] forState:UIControlStateNormal ];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [mainView addSubview:button];
        button.tag = 100+i;
        
        //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(mainView).offset(SCREEN_WIDTH/4*i);
        //            make.top.bottom.equalTo(mainView);
        //            make.width.mas_equalTo(SCREEN_WIDTH/4);
        //        }];
        if (i == _defaultSelectIndex) {
            button.selected = YES;
        }
        
        if (i == 2) {
            
            [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:4];
            objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        }
        //        if (i == 3) {
        //            [button setImage:[UIImage imageNamed:@"danjiantouup"] forState:UIControlStateNormal];
        //            [button setImage:[UIImage imageNamed:@"danjiantoudown"] forState:UIControlStateSelected];
        //            [button setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
        //        }
        
    }
    
}
//-(void)setSelectItmeArr:(NSArray *)selectItmeArr{
//    _selectItmeArr = selectItmeArr;
//    _defaultSelectIndex = 0;
//    UIButton *button = [self viewWithTag:102];
//    [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
//    objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
//    button.selected = NO;
//
//    for (int i = 0; i<4 ;i++) {
//        UIButton *button = [self viewWithTag:i+100];
//        if (i == 0) {
//            button.selected = YES;
//            continue;
//        }
//        if (i == 2) {
//            continue;
//        }
//        if (i == 1) {
//            continue;
//        }if (i == 3) {
//            continue;
//        }
//        button.selected = !button.selected;
//        if (i == 3) {
//            continue;
//        }
//    }
//
//    [self.collect reloadData];
//}
//- (void)createCollectionView{
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0,-ceil(_selectItmeArr.count/2.0)*35, SCREEN_WIDTH, ceil(_selectItmeArr.count/2.0)*35) collectionViewLayout:layout];
//    self.collect.delegate = self;
//    self.collect.dataSource = self;
//    self.collect.backgroundColor = [UIColor whiteColor];
//
//    self.collect.backgroundColor = RGBA(233, 233, 233 ,1);
//    [self addSubview:self.collect];
//
//    [self.collect registerNib:[UINib nibWithNibName:@"NY_SelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NY_SelectCollectionViewCellID];
//
//}
//#pragma mark UICollectionViewDelegate
////返回section个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
////每个section的item个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//    return _selectItmeArr.count;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_defaultSelectItmeIndex == indexPath.row) {
//        return;
//    }
//    NY_SelectCollectionViewCell *cell = (NY_SelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_defaultSelectItmeIndex inSection:0]];
//    [cell.Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    cell.selectImage.hidden = YES;
//
//    _defaultSelectItmeIndex = (int)indexPath.row;
//
//    NY_SelectCollectionViewCell *selCell = (NY_SelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [selCell.Btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//    selCell.selectImage.hidden = NO;
//
////    UIButton *btn = (UIButton *)[self viewWithTag:103];
////    NSDictionary *dic = _selectItmeArr[indexPath.row];
////    [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
////    [btn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
//
//    if ([self.delegate respondsToSelector:@selector(selectItme:withIndex:)]) {
//        [self.delegate selectItme:self withIndex:indexPath.row];
//    }
////    [self toggleViewWith:nil];
//}


//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NY_SelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NY_SelectCollectionViewCellID forIndexPath:indexPath];
//    if (indexPath.row == _defaultSelectItmeIndex) {
//        [cell.Btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//        cell.selectImage.hidden = NO;
//    }else{
//        [cell.Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        cell.selectImage.hidden = YES;
//    }
//
//    NSDictionary *dic = _selectItmeArr[indexPath.row];
//    [cell.Btn setTitle:dic[@"name"] forState:UIControlStateNormal];
//    return cell;
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    return nil;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//    return CGSizeMake(0, 0);
//}
////设置每个item的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(SCREEN_WIDTH/2, 35);
//}
////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
////设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}


- (void)selectClick:(UIButton *)btn{
    
    //    if (btn.tag != 103) {//没点击全部分类，则让其他按钮回复默认状态
    for (int i = 0; i<4 ;i++) {
        UIButton *button = [self viewWithTag:i+100];
        button.selected = NO;
    }
    btn.selected = YES;
    //        [self toggleViewWith:nil];
    //    }else{//当点击全部分类按钮，则
    //
    //        [self toggleViewWith:btn];
    //    }
    
    
    ButtonClickType type = ButtonClickTypeNormal;
    
    if (btn.tag == 102) {
        NSString *flag = objc_getAssociatedObject(btn, btnKey);
        if ([flag isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeUp;
        }else if ([flag isEqualToString:@"2"]){
            [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateNormal];
            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
            type = ButtonClickTypeDown;
        }
        
    }else{
        //点击全部不复位价格
        //        if (btn.tag != 103) {
        UIButton *button = [self viewWithTag:102];
        [button setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        type = ButtonClickTypeNormal;
        //        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectTopButton:withIndex:withButtonType:)]) {
        [self.delegate selectTopButton:self withIndex:btn.tag withButtonType:type];
    }
}
//- (void)toggleViewWith:(UIButton *)btn{
//
//    if (!btn) {
//        btn = [self viewWithTag:103];
//        if (show) {
//            show = NO;
//        }else{
//            return;
//        }
//    }else{
//        show = !show;
//    }
//    if (_defaultSelectItmeIndex != 0) {
//        btn.selected = YES;
//    }else{
//        btn.selected = NO;
//    }
//    if (show) {
//        self.frame = CGRectMake(0, self.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
//        [self.collect reloadData];
//    }else{
//        self.frame = CGRectMake(0, self.frame.origin.y, SCREEN_WIDTH, 40);
//    }
//    float frameY = show?40:-ceil(_selectItmeArr.count/2.0)*35;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.collect.frame = CGRectMake(0, frameY, SCREEN_WIDTH, ceil(_selectItmeArr.count/2.0)*35);
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:show?0.4:0.0];
//    }];
//
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self toggleViewWith:nil];
//}

@end
