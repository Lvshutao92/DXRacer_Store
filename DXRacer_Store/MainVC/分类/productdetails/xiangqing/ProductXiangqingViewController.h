//
//  ProductXiangqingViewController.h
//  商城详情
//
//  Created by 吕书涛 on 2018/5/17.
//  Copyright © 2018年 吕书涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWQSelectAttributes.h"
#import "DWQSelectView.h"





@interface ProductXiangqingViewController : UIViewController



@property(nonatomic,strong)NSString *idStr;


@property(nonatomic,strong)DWQSelectView *selectView;
@property(nonatomic,strong)DWQSelectAttributes *selectAttributes;

@property(nonatomic,strong)NSMutableArray *attributesArray;


@end
