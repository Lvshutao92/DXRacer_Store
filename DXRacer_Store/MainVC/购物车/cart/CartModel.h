//
//  CartModel.h
//  ArtronUp
//
//  Created by Artron_LQQ on 16/1/7.
//  Copyright © 2016年 ArtronImages. All rights reserved.
//
/**
 *  @author LQQ, 16-01-08 19:01:03
 *
 *  购物车商品模型
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CartModel : NSObject

//@property (nonatomic,copy) NSString *sizeStr;
//@property (nonatomic,copy) NSString *nameStr;
//@property (nonatomic,copy) NSString *dateStr;
//@property (nonatomic,assign) NSInteger number;
//@property (nonatomic,copy) NSString *price;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,assign) BOOL isSelect;


@property (nonatomic,strong) NSString *productAttr;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *salePrice;
@property (nonatomic,strong) NSString *id;

@property (nonatomic,strong) NSString *promotionTitle;



@property (nonatomic,strong)NSString *productType;
@end
