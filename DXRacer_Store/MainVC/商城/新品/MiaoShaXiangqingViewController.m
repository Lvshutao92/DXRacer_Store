//
//  MiaoShaXiangqingViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/24.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "MiaoShaXiangqingViewController.h"
#import "FrankDetailDropDelegate.h"
#import "FrankDropBounsView.h"
#import <MJRefresh/MJRefresh.h>
#import "BiaogeTableViewCell.h"
#import "CreateOrderViewController.h"

#import "AddrViewController.h"
#import "LZProductDetails.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import "DaiFuKuan_ViewController.h"
#import "YiFuKuan_ViewController.h"
#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)


@interface MiaoShaXiangqingViewController ()<FrankDetailDropDelegate,UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate , UIWebViewDelegate,LLPhotoBrowserDelegate>
{
    dispatch_source_t _timer;
    
    CGFloat imgheight;
    
    NSMutableDictionary *dic_sID;
    NSMutableArray *arr_sID;
    
    NSMutableArray *productItemList_Arr;
    
    NSMutableArray *arr;
    NSString *productCanshu;
    NSString *productnumber;
    NSString *stringID;
    NSString *stringPrice;
    NSString *stringStatus;
    NSString *stringImg;
    NSString *itemNo;
    
    NSString *orderNum;
    UIView *headerV;
    UIView *footerV;
    
    UILabel *titleLab;
    UILabel *priceLab;
    UILabel *activityNameLab;
    UILabel *activityPriceLab;
    UILabel *line1;
    
    UILabel *guigeLab;
    UIImageView *guigeimg;
    UIButton *guigeBtn;
    UILabel *line2;
    
    NSMutableArray *afe;
    
    
    CGFloat titleHeight;
    
    UISegmentedControl *segment;
    
    
    
    UIView *bgv;
    UILabel *addtitlab;
    UIImageView *jiantou;
    UILabel *namelab;
    UILabel *phonelab;
    UILabel *addresslab;
    UIButton *btn;
    UILabel *line3;
    
    NSString *addressID;
    
    
    UILabel *numberLab;
    NSString *stt;
    NSString *isorno_star;
    
    
    HJCAjustNumButton *btns;
}
@property(nonatomic,strong)MBProgressHUD *HUD;

@property(nonatomic,strong)NSString *zuidagoumainum;
@property(nonatomic,strong)UIView *backgroundView;


@property(nonatomic,strong)UIImageView *headerImg;


@property (nonatomic, strong) FrankDropBounsView * dropView;
@property (nonatomic, strong) UILabel * tabbarView;
@property (nonatomic,strong)NSTimer *timer_s;

@property (nonatomic, strong) UITableView * tableview1;
@property (nonatomic, strong) UITableView * tableview2;
@property (nonatomic, strong) UITableView * tableview3;
@property (nonatomic, strong) UITableView * tableview4;

@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;


@property (strong, nonatomic)UILabel *dian1;
@property (strong, nonatomic)UILabel *dian2;
@property (strong, nonatomic)UILabel *dayLabel;
@property (strong, nonatomic)UILabel *hourLabel;
@property (strong, nonatomic)UILabel *minuteLabel;
@property (strong, nonatomic)UILabel *secondLabel;

@property(nonatomic,strong)TFSheetView *tfSheetView;
@end

@implementation MiaoShaXiangqingViewController

- (void)lodinfo{
    //    __weak typeof (self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"address") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"----%@",diction);
            NSMutableArray *array = (NSMutableArray *)diction;
            if ([Manager judgeWhetherIsEmptyAnyObject:array]==YES) {
                if (array.count>0) {
                    NSDictionary *dic = [array firstObject];
                    self->addressID = [dic objectForKey:@"id"];
                    self->addresslab.text = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"receiveProvince"],[dic objectForKey:@"receiveCity"],[dic objectForKey:@"receiveDistrict"],[dic objectForKey:@"address"]];
                }else{
                    [self->btn setTitle:@"" forState:UIControlStateNormal];
                }
            }else{
                [self->btn setTitle:@"" forState:UIControlStateNormal];
            }
        //NSLog(@"----%@",diction);
    } enError:^(NSError *error) {
        //NSLog(@"----%@",error);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"宝贝";
    
    UIImage *theImage1 = [UIImage imageNamed:@"3"];
    UIView *ve = [[UIView alloc]initWithFrame:CGRectMake(0, [Manager returnDianchitiaoHeight], 44, 44)];
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
    [readerBtn setBackgroundImage:theImage1 forState:UIControlStateNormal];
    [readerBtn addTarget:self action:@selector(onRightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [ve addSubview:readerBtn];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:ve];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
    self.tabbarView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.dropView];
    [self.view addSubview:self.tabbarView];
    
    
    
    headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 730)];
    headerV.userInteractionEnabled = YES;
    self.tableview1.tableHeaderView = headerV;
    
//    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    self.tableview1.tableFooterView = footerV;
    
    
    _headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [headerV addSubview:self.headerImg];
    
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.numberOfLines = 0;
    [headerV addSubview:titleLab];
    priceLab = [[UILabel alloc]init];
    priceLab.textColor = [UIColor grayColor];
    [headerV addSubview:priceLab];
    
    activityNameLab = [[UILabel alloc]init];
    activityNameLab.textColor = [UIColor blackColor];
    activityNameLab.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:activityNameLab];
    
    activityPriceLab = [[UILabel alloc]init];
    activityPriceLab.textColor = [UIColor redColor];
    activityPriceLab.textAlignment = NSTextAlignmentLeft;
    [headerV addSubview:activityPriceLab];
    
    line1 = [[UILabel alloc]init];
    line1.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [headerV addSubview:line1];
    
    
    guigeLab = [[UILabel alloc]init];
    guigeLab.textColor = [UIColor whiteColor];
    guigeLab.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:guigeLab];
    line2 = [[UILabel alloc]init];
    line2.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [headerV addSubview:line2];
    
    
    self.dayLabel = [[UILabel alloc]init];
    self.dayLabel.textColor = [UIColor blackColor];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:self.dayLabel];
    
    self.hourLabel = [[UILabel alloc]init];
    self.hourLabel.textColor = [UIColor whiteColor];
    self.hourLabel.backgroundColor = [UIColor blackColor];
    self.hourLabel.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:self.hourLabel];
    
    
    self.minuteLabel = [[UILabel alloc]init];
    self.minuteLabel.textColor = [UIColor whiteColor];
    self.minuteLabel.backgroundColor = [UIColor blackColor];
    self.minuteLabel.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:self.minuteLabel];
    
    
    self.secondLabel = [[UILabel alloc]init];
    self.secondLabel.textColor = [UIColor whiteColor];
    self.secondLabel.backgroundColor = [UIColor blackColor];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:self.secondLabel];
    
    self.dian1 = [[UILabel alloc]init];
    self.dian1.textAlignment = NSTextAlignmentCenter;
    self.dian1.text = @":";
    [headerV addSubview:self.dian1];
    
    
    self.dian2 = [[UILabel alloc]init];
    self.dian2.textAlignment = NSTextAlignmentCenter;
    self.dian2.text = @":";
    [headerV addSubview:self.dian2];
    
    
    
    
    
    bgv = [[UIView alloc]init];
    bgv.backgroundColor = [UIColor whiteColor];
    bgv.userInteractionEnabled = YES;
    [headerV addSubview:bgv];
    
    addtitlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 70, 20)];
    addtitlab.text = @"配送至：";
    [bgv addSubview:addtitlab];
    
    jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25, 20, 20, 20)];
    jiantou.image = [UIImage imageNamed:@"箭头3"];
    [bgv addSubview:jiantou];
    
//    namelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-180, 20)];
//    namelab.font = [UIFont systemFontOfSize:14];
//    [bgv addSubview:namelab];
//
//    phonelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 20, 110, 20)];
//    phonelab.font = [UIFont systemFontOfSize:14];
//    phonelab.textAlignment = NSTextAlignmentRight;
//    [bgv addSubview:phonelab];
    
    
    addresslab = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, SCREEN_WIDTH-110, 60)];
    addresslab.font = [UIFont systemFontOfSize:14];
    addresslab.numberOfLines = 0;
    [bgv addSubview:addresslab];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getaddress) forControlEvents:UIControlEventTouchUpInside];
    [bgv addSubview:btn];
    
    line3 = [[UILabel alloc]init];
    line3.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [headerV addSubview:line3];
    
    [btn bringSubviewToFront:bgv];
    
    
    numberLab = [[UILabel alloc]init];
    numberLab.text = @"数量：";
    [headerV addSubview:numberLab];
    productnumber = @"1";
    LRWeakSelf(self);
    btns = [[HJCAjustNumButton alloc] init];
    btns.callBack = ^(NSString *currentNum){
        self->productnumber = currentNum;
        NSInteger inde0 = [weakSelf.zuidagoumainum integerValue];
        NSInteger inde1 = [currentNum integerValue];
        //NSLog(@"%ld------%ld",inde0,inde1);
        if (inde0 < inde1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"超过最大购买数量" message:[NSString stringWithFormat:@"最大购买数量%ld",inde0] preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    };
    [headerV addSubview:btns];
    
    
    
    
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]]==YES){
        [self lodinfo];
    }
    
    
    [self getDetailsInfo];
    
    [self getIndexOneInfomation];
    [self getIndexTwoInfomation];
}



- (void)getaddress{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        AddrViewController *addr = [[AddrViewController alloc]init];
        addr.navigationItem.title = @"收货地址";
        addr.order = @"order";
        [self.navigationController pushViewController:addr animated:YES];
    }
}




- (void)onRightNavBtnClick {
    self.tabBarController.selectedIndex = 2;
}






- (void)getDetailsInfo{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"promotion/crush/%@",self.idStr];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",diction);
        
        NSString *videoId;
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            
            
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"productItem"]] == YES){
                NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"productItem"];
                [weakSelf.headerImg sd_setImageWithURL:[NSURL URLWithString:NSString([dicti objectForKey:@"listImg"])]];
            }
            
            
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"product"]] == YES){
                NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"product"];
                self->titleHeight = [Manager getLabelHeightWithContent:[dicti objectForKey:@"modelName"] andLabelWidth:SCREEN_WIDTH-30 andLabelFontSize:17];
                self->titleLab.text = [dicti objectForKey:@"modelName"];
                videoId = [dicti objectForKey:@"video"];
                self->priceLab.text = [Manager jinegeshi:[dicti objectForKey:@"salePrice"]];
                self->titleLab.frame = CGRectMake(5, 10+SCREEN_WIDTH, SCREEN_WIDTH-10, self->titleHeight);
                self->priceLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+10, 100, 20);
                self->activityNameLab.frame = CGRectMake(95, 10+SCREEN_WIDTH+self->titleHeight+10, SCREEN_WIDTH-190, 20);
                self->activityPriceLab.frame = CGRectMake(SCREEN_WIDTH-105, 10+SCREEN_WIDTH+self->titleHeight+10, 100, 20);
                self->line1.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+40, SCREEN_WIDTH, 10);
                
                
                self->guigeLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+60, 70, 40);
                weakSelf.dayLabel.frame    = CGRectMake(SCREEN_WIDTH-200, 10+SCREEN_WIDTH+self->titleHeight+60, 40, 40);
                weakSelf.hourLabel.frame   = CGRectMake(SCREEN_WIDTH-140, 10+SCREEN_WIDTH+self->titleHeight+60, 30, 40);
                weakSelf.minuteLabel.frame = CGRectMake(SCREEN_WIDTH-90, 10+SCREEN_WIDTH+self->titleHeight+60, 30, 40);
                weakSelf.secondLabel.frame = CGRectMake(SCREEN_WIDTH-40, 10+SCREEN_WIDTH+self->titleHeight+60, 30, 40);
                weakSelf.dian1.frame = CGRectMake(SCREEN_WIDTH-60, 10+SCREEN_WIDTH+self->titleHeight+60, 20, 40);
                weakSelf.dian2.frame = CGRectMake(SCREEN_WIDTH-110, 10+SCREEN_WIDTH+self->titleHeight+60, 20, 40);
                self->line2.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+105, SCREEN_WIDTH, 5);
                
                
                self->bgv.frame = CGRectMake(0, SCREEN_WIDTH+self->titleHeight+120, SCREEN_WIDTH, 60);
                self->line3.frame = CGRectMake(0, SCREEN_WIDTH+self->titleHeight+180, SCREEN_WIDTH, 5);
                
                self->numberLab.frame =  CGRectMake(10, SCREEN_WIDTH+self->titleHeight+190, 80, 40);
                self->btns.frame = CGRectMake(90, SCREEN_WIDTH+self->titleHeight+190, 150, 40);
                
                
                NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString: self->priceLab.text attributes:attribtDic1];
                self->priceLab.attributedText = attribtStr1;
            }
            if ([[[diction objectForKey:@"object"] objectForKey:@"switch"]isEqualToString:@"0"]) {
                self->guigeLab.text = @"距开始";
                self->guigeLab.backgroundColor = RGBACOLOR(0, 174, 10, 1);
            }else{
                self->guigeLab.text = @"距结束";
                self->guigeLab.backgroundColor = [UIColor redColor];
            }
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"crush"]] == YES){
                NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"crush"];
                self->activityNameLab.text = @"秒杀价：";
                self->activityPriceLab.text = [Manager jinegeshi:[dicti objectForKey:@"salePrice"]];
                if ([[[diction objectForKey:@"object"] objectForKey:@"switch"]isEqualToString:@"0"]){
                    [weakSelf downSecondHandle:[dicti objectForKey:@"startTime"]];
                    self->isorno_star = @"no";
                }else{
                    [weakSelf downSecondHandle:[dicti objectForKey:@"endTime"]];
                    self->isorno_star = @"yes";
                }
                
                
                weakSelf.zuidagoumainum = [dicti objectForKey:@"unitQuantity"];
            }
        }
        [weakSelf.tableview1 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}
















- (void)cilck1{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        if ([isorno_star isEqualToString:@"no"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"活动暂未开始" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            [self commitOrder];
        }
    }
}
- (void)commitOrder{
    __weak typeof(self) weakSelf = self;
    if (self.idString.length > 0 && addressID.length > 0 && productnumber.length > 0) {
        NSDictionary *dic = @{@"skuId":self.idStr,
                              @"quantity":productnumber,
                              @"addressId":addressID};
//         NSLog(@"--=====%@",dic);
        [Manager requestPOSTWithURLStr:KURLNSString(@"promotion/crush/confirm") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
//            NSLog(@"--%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]){
                weakSelf.tfSheetView = [[TFSheetView alloc]init];
                //取消
                weakSelf.tfSheetView.cancelBlock = ^{
                    DaiFuKuan_ViewController *or = [[DaiFuKuan_ViewController alloc]init];
                    or.orderNo = [diction objectForKey:@"object"];
                    or.orderStatus = @"待付款";
                    [self.navigationController pushViewController:or animated:YES];
                    [weakSelf.tfSheetView disMissView];
                };
                //微信支付
                weakSelf.tfSheetView.wxBlock = ^{
                    //NSLog(@"微信支付");
                    
                    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
                    {
                        [weakSelf doWXPay:[diction objectForKey:@"object"]];
                    }
                    else
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机未安装微信，请安装好再进行支付" preferredStyle:1];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alert addAction:cancel];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                    
                    [weakSelf.tfSheetView disMissView];
                };
                //支付宝支付
                weakSelf.tfSheetView.zfbBlock = ^{
                    //NSLog(@"支付宝支付");
                    [weakSelf doAPPay:[diction objectForKey:@"object"]];
                    [weakSelf.tfSheetView disMissView];
                };
                [weakSelf.tfSheetView showInView:self.view];
            }else  if ([code isEqualToString:@"401"]){
                [Manager logout];
                LoginViewController *login = [[LoginViewController alloc]init];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [weakSelf presentViewController:login animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[diction objectForKey:@"object"] preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
#pragma mark   ==============点击订单模拟支付行为==============
- (void)doAPPay:(NSString *)orderNo
{
    NSString *str = [NSString stringWithFormat:@"order/alipay/%@",orderNo];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [[AlipaySDK defaultService] payOrder:base64Decoded fromScheme:@"dxracerdiruikesi" callback:^(NSDictionary *resultDic) {
            //                NSLog(@"*****************************result%@",resultDic);
        }];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//微信
- (void)doWXPay:(NSString *)orderNo{
    orderNum = orderNo;
    if (self.timer_s != nil) {
        [self.timer_s invalidate];
        self.timer_s = nil;
    }
    self.timer_s = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"order/weixin/h5/%@",orderNo];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //        NSLog(@"%@",diction);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[diction objectForKey:@"msg"]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"test-shop.dxracer.com.cn://" forHTTPHeaderField:@"Referer"];
        [webView loadRequest:request];
        webView.hidden = YES;
        [weakSelf.view addSubview:webView];
        
    } enError:^(NSError *error) {
        //        NSLog(@"%@",error);
    }];
}


- (void)timerAction:(NSTimer *)timer{
    [self judjePayFailAndSuccess];
}

- (void)judjePayFailAndSuccess{
    if ([Manager judgeWhetherIsEmptyAnyObject:orderNum]==YES) {
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"order/payment/check/%@",orderNum];
        NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [Manager requestPOSTWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //            NSLog(@"111-----------%@",diction);
            //            NSString *code = [diction objectForKey:@"code"]
            if ([[diction objectForKey:@"msg"] isEqualToString:@"yes"]) {
                YiFuKuan_ViewController *vvv = [[YiFuKuan_ViewController alloc]init];
                vvv.orderNo = self->orderNum;
                [weakSelf.navigationController pushViewController:vvv animated:YES];
                [weakSelf.timer_s invalidate];
                weakSelf.timer_s = nil;
            }
        } enError:^(NSError *error) {
            //            NSLog(@"222-----------%@",error);
        }];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    if (self.timer_s != nil) {
        [self.timer_s invalidate];
        self.timer_s = nil;
    }
}












- (void)cilck3{
    
}
- (void)cilck4{
    self.tabBarController.selectedIndex = 2;
}



















- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 消除导航影响
    //[self.dropView viewControllerWillAppear];
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    
    
    
    if (addresslab.text.length <= 0) {
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuanzhi:) name:@"chuanzhi" object:nil];
}
- (void)chuanzhi:(NSNotification *)text {
    NSDictionary *dic = text.userInfo;
    addresslab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
    addressID = [dic objectForKey:@"id"];
    [btn setTitle:@"" forState:UIControlStateNormal];
}





- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    self.tabBarController.tabBar.hidden = YES;
    // 消除导航影响
    //[self.dropView viewControllerWillDisappear];
}


- (UILabel *)tabbarView{
    
    if (!_tabbarView) {
        _tabbarView = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        _tabbarView.textAlignment = NSTextAlignmentCenter;
        
        _tabbarView.userInteractionEnabled = YES;
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"马上抢" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn1];
        
        
//        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn3.frame = CGRectMake((SCREEN_WIDTH-260)/2+10, 0, (SCREEN_WIDTH-260)/2, 55);
//        [btn3 setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
//        btn3.backgroundColor = [UIColor whiteColor];
//        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn3 addTarget:self action:@selector(cilck3) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn3];
//
//        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn4.frame = CGRectMake(10, 0, (SCREEN_WIDTH-260)/2, 55);
//        [btn4 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
//        btn4.backgroundColor = [UIColor whiteColor];
//        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn4 addTarget:self action:@selector(cilck4) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn4];
        
    }
    return _tabbarView;
}
- (FrankDropBounsView *)dropView{
    if (!_dropView) {
        CGFloat height = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.tabbarView.frame) - [Manager returnDaohanglanHeight];
        _dropView = [FrankDropBounsView createFrankDropBounsViewWithFrame:CGRectMake(0, [Manager returnDaohanglanHeight], CGRectGetWidth(self.view.frame), height) withDelegate:self];
        _dropView.needShowAlertView = NO;// 设置是否显示提示文字
        _dropView.backgroundColor = [UIColor clearColor];
        _dropView.alertTitle = @"";
    }
    return _dropView;
}


- (void)pullDownToReloadData:(MJRefreshNormalHeader *)table{
    //NSLog(@"--- 下拉");
    [self.dropView showTopPageViewWithCompleteBlock:^{
        [table endRefreshing];
    }];
}
- (void)pullUpToReloadMoreData:(MJRefreshBackNormalFooter *)table{
    //NSLog(@"--- 上拉");
    [self.dropView showBottomPageViewWithCompleteBlock:^{
        [table endRefreshing];
    }];
}
#pragma mark ---------  TripDetailDropDelegate  -------------
/**
 自定义上部展示视图模块 代理方法
 */
- (UIView *)frankDropBounsViewResetTopView{
    
    self.tableview1 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview1.backgroundColor = [UIColor whiteColor];
    
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    self.tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
    
    return self.tableview1;
}
#pragma mark ---------  TripDetailDropDelegate  -------------
/**
 自定义切换标题模块 代理方法
 */
- (NSArray *) resetToolbarTitles{
    return @[@"图文详情",@"规格参数",@"评价"];
}
/**
 自定义底部展示视图模块 代理方法
 */
- (UIView *)resetBottomViewsWithIndex:(NSInteger)index{
    
    if (index == 1) {
        self.tableview2 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableview2.delegate = self;
        self.tableview2.dataSource = self;
        [self.tableview2 registerNib:[UINib nibWithNibName:@"BigImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
        self.tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
        return self.tableview2;
    }
    if (index == 2) {
        self.tableview3 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableview3.delegate = self;
        self.tableview3.dataSource = self;
        [self.tableview3 registerNib:[UINib nibWithNibName:@"BiaogeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
        [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
        self.tableview3.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
        return self.tableview3;
    }
    
    
    self.tableview4 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview4.delegate = self;
    self.tableview4.dataSource = self;
    [self.tableview4 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell4"];
    [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
    self.tableview4.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview4.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
    
    
    
    return self.tableview4;
}



- (void)getIndexTwoInfomation{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/desc/%@",self.idString];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //             NSLog(@"******%@",diction);
        [weakSelf.dataArray2 removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)diction;
        for (NSDictionary *dic in arr) {
            Model *model = [Model mj_objectWithKeyValues:dic];
            //            NSLog(@"%@---%@",model.attrCode,model.attrValue);
            [weakSelf.dataArray2 addObject:model];
        }
        [weakSelf.tableview3 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)getIndexOneInfomation{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/img/%@",self.idString];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //        NSLog(@"******%@",diction);
        [weakSelf.dataArray1 removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)diction;
        for (NSDictionary *dic in arr) {
            Model *model = [Model mj_objectWithKeyValues:dic];
            [weakSelf.dataArray1 addObject:model];
        }
        
        [weakSelf.tableview2 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview2]) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (Model *mo in self.dataArray1) {
            [arr addObject:NSString(mo.imgUrl)];
        }
        LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:(NSArray *)arr currentIndex:indexPath.row];
        photoBrowser.delegate = self;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview2]) {
        if (imgheight == 0) {
            imgheight = 250;
        }
        return imgheight;
    }else
        if ([tableView isEqual:self.tableview3]) {
            return 60;
        }
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableview2]) {
        return self.dataArray1.count;
    }else
        if ([tableView isEqual:self.tableview3]) {
            return self.dataArray2.count;
        }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview1]) {
        static NSString *identifierCell = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([tableView isEqual:self.tableview2]) {
        static NSString *identifierCell = @"cell2";
        BigImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[BigImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        Model *model = [self.dataArray1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        imgheight = [cell returnCellHeight:NSString(model.imgUrl)];
        
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:NSString(model.imgUrl)]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        cell.img.image = [cache imageFromDiskCacheForKey:key];
        
        
        
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.imgUrl)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            self->imgheight = SCREEN_WIDTH/size.width*size.height;
        }];
        
        return cell;
    }
    if ([tableView isEqual:self.tableview3]) {
        static NSString *identifierCell = @"cell3";
        BiaogeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[BiaogeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Model *model = [self.dataArray2 objectAtIndex:indexPath.row];
        cell.lab1.text = model.attrCode;
        cell.lab2.text = model.attrValue;
        cell.lab1.numberOfLines = 0;
        cell.lab2.numberOfLines = 0;
        return cell;
    }
    static NSString *identifierCell = @"cell4";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.textLabel.text = @"44444";
    return cell;
}












- (NSMutableArray *)dataArray1{
    if (_dataArray1 == nil) {
        self.dataArray1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray1;
}

- (NSMutableArray *)dataArray2{
    if (_dataArray2 == nil) {
        self.dataArray2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray2;
}

- (NSMutableArray *)dataArray3{
    if (_dataArray3 == nil) {
        self.dataArray3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray3;
}


-(void)downSecondHandle:(NSString *)aTimeString{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:aTimeString]; //结束时间
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
//    NSLog(@"现在的时间 === %@",dateString);
    
    
    NSTimeInterval  timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLabel.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLabel.text = @"";
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

@end
