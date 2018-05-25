//
//  Model.h
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model_A.h"
@interface Model : NSObject
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger number;


@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *business_id;
@property (nonatomic,strong) NSString *chair_color_name;
@property (nonatomic,strong) NSString *chair_logo_name;
@property (nonatomic,strong) NSString *clothes_color_name;
@property (nonatomic,strong) NSString *clothes_size_name;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *listprice;
@property (nonatomic,strong) NSString *realprice;
@property (nonatomic,strong) NSString *shoppingcartid;
@property (nonatomic,strong) NSString *skucode;
@property (nonatomic,strong) NSString *skuname;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *price;


@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *isDefault;
@property (nonatomic,strong) NSString *person;
@property (nonatomic,strong) NSString *receiveCity;
@property (nonatomic,strong) NSString *receiveProvince;
@property (nonatomic,strong) NSString *receiveDistrict;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *tel;


@property (nonatomic,strong) NSString *model_img;
@property (nonatomic,strong) NSString *original_img;
@property (nonatomic,strong) NSString *catalog_name;
@property (nonatomic,strong) NSString *type_name;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *brand_name;
@property (nonatomic,strong) NSString *model_no;
@property (nonatomic,strong) NSString *small_img;
@property (nonatomic,strong) NSString *catalog_id;
@property (nonatomic,strong) NSString *model_name;
@property (nonatomic,strong) NSString *series_name;
@property (nonatomic,strong) NSString *model_title;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *sale_price;


@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *linkUrl;
@property (nonatomic,strong) NSString *phoneUrl;
@property (nonatomic,strong) NSString *title1;
@property (nonatomic,strong) NSString *title2;
@property (nonatomic,strong) NSString *title3;
@property (nonatomic,strong) NSString *listImg;

@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *productAttr;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *salePrice;




@property (nonatomic,strong) NSString *imgUrl;

@property (nonatomic,strong) NSString *proportion;

@property (nonatomic,strong) NSString *attrCode;
@property (nonatomic,strong) NSString *attrValue;
@property (nonatomic,strong) NSString *productModelId;
@property (nonatomic,strong) NSString *rowIndex;

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;



@property (nonatomic,strong)NSString *orderStatus;

@property (nonatomic,strong)NSString *productFee;
@property (nonatomic,strong)NSString *productItemNo;
@property (nonatomic,strong)NSString *productItemImg;
@property (nonatomic,strong)NSString *productTitle;


@property (nonatomic,strong)NSString *activityName;
@property (nonatomic,strong)NSString *onSalePrice;
@property (nonatomic,strong)NSString *productItemId;
@property (nonatomic,strong)NSString *orderFee;

@property (nonatomic,strong)NSString *promotionTitle;


@property (nonatomic,strong)NSDictionary *productItem;
@property (nonatomic,strong)Model_A *productItem_model;

@property (nonatomic,strong)NSDictionary *product;
@property (nonatomic,strong)Model_A *product_model;

@property (nonatomic,strong)NSDictionary *crush;
@property (nonatomic,strong)Model_A *crush_model;

@property (nonatomic,strong)NSString *skuId;
@property (nonatomic,strong)NSString *switchs;


@property (nonatomic,strong)NSString *productAttrs;
@end






