//
//  PaymentAction.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/6.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"


@protocol PaymentActionDelegate <NSObject>

@optional


@end



@interface PaymentAction : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<PaymentActionDelegate> delegate;

+ (instancetype)sharedManager;

@end
