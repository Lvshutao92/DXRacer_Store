//
//  ProductDetailsViewController.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/14.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWQSelectAttributes.h"
#import "DWQSelectView.h"


@interface ProductDetailsViewController : UIViewController



@property(nonatomic,strong)NSString *idStr;


@property(nonatomic,strong)DWQSelectView *selectView;
@property(nonatomic,strong)DWQSelectAttributes *selectAttributes;

@property(nonatomic,strong)NSMutableArray *attributesArray;

@end
