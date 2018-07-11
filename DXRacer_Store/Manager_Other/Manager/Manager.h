//
//  Manager.h
//  DMS
//
//  Created by 吕书涛 on 2018/3/5.
//  Copyright © 2018年 吕书涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "PrefixHeader.pch"

//首先导入头文件信息
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@interface Manager : NSObject


////获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;



//声明单例方法
+ (Manager *)sharedManager;
//MD5加密
- (NSString *)md5:(NSString *)str;
//base加解密
+ (NSString*)encodeBase64String:(NSString*)input;
+ (NSString*)decodeBase64String:(NSString*)input;
+ (NSString*)encodeBase64Data:(NSData*)data;
+ (NSString*)decodeBase64Data:(NSData*)data;
//字典转json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//金额转大写
+(NSString *)digitUppercase:(NSString *)numstr;
//存数据
+ (void)writewenjianming:(NSString *)wenjianming content:(NSString *)content;
//取数据
+ (NSString *)redingwenjianming:(NSString *)wenjianming;
+ (void)remove:(NSString *)paths;
//时间格式转化
+ (NSString *)timezhuanhuan:(NSString *)str;
//金额格式转换
+ (NSString *)jinegeshi:(NSString *)text;
+ (NSString *)usdjinegeshi:(NSString *)text;
//网络请求
+ (AFHTTPSessionManager *)returnsession;
+ (NSDictionary *)returndictiondata:(NSData *)responseObject;
//返回button
+ (UIButton *)returnButton;
//计算体积
+ (CGFloat )returnTiJi:(NSString *)longstr width:(NSString *)widthstr height:(NSString *)heightstr;
//时间戳转时间
+ (NSString *)TimeCuoToTime:(NSString *)str;
+ (NSString *)TimeCuoToTimes:(NSString *)str;
//获取手机型号
- (NSString*)iphoneType;
//获取IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4;
//日期相减
+ (NSInteger)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;
//
+ (UIImage *) imageFromURLString: (NSString *) urlstring;
//获取当前时间
+(NSString*)getCurrentTimes;






//判断对象
+ (BOOL)judgeWhetherIsEmptyAnyObject:(id)object;


+ (void)requestPUTWithURLStr:(NSString *)urlStr
                    paramDic:(NSDictionary *)paramDic
                     token:(NSString *)token
                      finish:(void(^)(id responseObject))finish
                     enError:(void(^)(NSError *error))enError;
+ (void)requestPOSTWithURLStr:(NSString *)urlStr
                     paramDic:(NSDictionary *)paramDic
                        token:(NSString *)token
                       finish:(void(^)(id responseObject))finish
                      enError:(void(^)(NSError *error))enError;
+ (void)requestDELETEWithURLStr:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                          token:(NSString *)token
                         finish:(void(^)(id responseObject))finish
                        enError:(void(^)(NSError *error))enError;
+ (void)requestGETWithURLStr:(NSString *)urlStr
                    paramDic:(NSDictionary *)paramDic
                       token:(NSString *)token
                      finish:(void(^)(id responseObject))finish
                     enError:(void(^)(NSError *error))enError;

//post arr
+ (void)requestPOSTWithURLStr:(NSString *)urlStr
                     paramArr:(NSMutableArray *)paramArr
                        token:(NSString *)token
                       finish:(void(^)(id responseObject))finish
                      enError:(void(^)(NSError *error))enError;





//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

//刷新token
+ (void)clickLogin;

+(CGFloat)getLabelHeightWithContent:(NSString *)content andLabelWidth:(CGFloat)width andLabelFontSize:(int)font;


+ (void)logout;


+ (CGFloat )returnDaohanglanHeight;
+ (CGFloat )returnDianchitiaoHeight;
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;


@property(nonatomic,assign)CGFloat gouwuNumHeight;


@property(nonatomic,strong)NSString *mobile;


@property(nonatomic,strong)NSMutableArray *arr_K;
@end

