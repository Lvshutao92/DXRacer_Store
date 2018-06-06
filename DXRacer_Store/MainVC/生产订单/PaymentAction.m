//
//  PaymentAction.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/6.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "PaymentAction.h"

@implementation PaymentAction

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PaymentAction *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PaymentAction alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else {
    }
}

- (void)onReq:(BaseReq *)req {
    
}

@end
