//
//  Model.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "Model.h"

@implementation Model
+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"switchs"]) propertyName = @"switch";
    
    return propertyName;
}
@end
