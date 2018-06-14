//
//  DaiFuKuan_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/5.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "DaiFuKuan_ViewController.h"
#import "DZFOrderCell.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"


#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)
@interface DaiFuKuan_ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //bottom
    NSString *btn1Title;
    NSString *btn2Title;
    
    //header
    UIImageView *imgV;
    UILabel *namelab;
    UILabel *addresslab;
    
    //footer
    UILabel *orderNumLab;
    UILabel *orderCreatetimeLab;
    
    UILabel *payTypeLab;
    
    UILabel *invioceTypeLab;
    UILabel *invioceTitleLab;
    UILabel *invioceContentLab;
    
    UILabel *ProductTotalPriceLab;
    UILabel *freightLab;
    UILabel *shifukuanLab;
    
    UIButton *btn2;
}

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)NSTimer *timer;

@property UIPasteboard *pBoard;
@property(nonatomic,strong)TFSheetView *tfSheetView;


@property(nonatomic,strong)NSString *str1;
@property(nonatomic,strong)NSString *str2;
@property(nonatomic,strong)NSString *str3;
@property(nonatomic,strong)NSString *str4;
@property(nonatomic,strong)NSString *str5;
@property(nonatomic,strong)NSString *str6;
@property(nonatomic,strong)NSString *str7;
@property(nonatomic,strong)NSString *str8;
@property(nonatomic,strong)NSString *str9;
@property(nonatomic,strong)NSString *str10;
@property(nonatomic,strong)NSString *str11;
@property(nonatomic,strong)NSString *str12;
@property(nonatomic,strong)NSString *str13;
@end

@implementation DaiFuKuan_ViewController
- (void)viewWillAppear:(BOOL)animated{
    [self getOrderDetailsInfomation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.navigationItem.title = @"订单详情";
    
    btn1Title = @"去支付";
    btn2Title = @"取消订单";
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-51) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"DZFOrderCell" bundle:nil] forCellReuseIdentifier:@"DZFOrderCell"];
    [self.view addSubview:self.tableview];
    
    
    [self setUpHeaderView];
    [self setUpFooterView];
    
    
    [self setupDibuView];
    
    
}






- (void)getOrderDetailsInfomation{
    __weak typeof (self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"order/%@",self.orderNo];
    [Manager requestGETWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"==////======%@",diction);
        
        //地址
        NSDictionary *addressDic = [diction objectForKey:@"shippingAddress"];
        
        self->namelab.text = [NSString stringWithFormat:@"收货人：%@   %@",[addressDic objectForKey:@"receiverName"],[addressDic objectForKey:@"receiverMobile"]];
        
        CGFloat titleHeight = [Manager getLabelHeightWithContent:[NSString stringWithFormat:@"收货地址：%@%@%@%@",[addressDic objectForKey:@"receiverState"],[addressDic objectForKey:@"receiverCity"],[addressDic objectForKey:@"receiverDistrict"],[addressDic objectForKey:@"receiverAddress"]] andLabelWidth:SCREEN_WIDTH-65 andLabelFontSize:14];
        self->addresslab.frame = CGRectMake(35, 45, SCREEN_WIDTH-65, titleHeight);
        self->addresslab.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",[addressDic objectForKey:@"receiverState"],[addressDic objectForKey:@"receiverCity"],[addressDic objectForKey:@"receiverDistrict"],[addressDic objectForKey:@"receiverAddress"]];
        
        weakSelf.str13 = @"created";
        if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"shippingInvoice"]]==YES) {
            NSDictionary *invDic = [diction objectForKey:@"shippingInvoice"];
            self->invioceTypeLab.text = [invDic objectForKey:@"invoiceType"];
            self->invioceTitleLab.text = [invDic objectForKey:@"invoiceTitle"];
            self->invioceContentLab.text = [invDic objectForKey:@"receivePerson"];
            weakSelf.str1  = [invDic objectForKey:@"invoiceTitle"];
            weakSelf.str2  = [invDic objectForKey:@"invoiceType"];
            
            weakSelf.str3  = [invDic objectForKey:@"bankName"];
            weakSelf.str4  = [invDic objectForKey:@"bankNo"];
            weakSelf.str5  = [invDic objectForKey:@"invoiceCode"];
            weakSelf.str6  = [invDic objectForKey:@"registerAddress"];
            
            weakSelf.str7  = [invDic objectForKey:@"receiveProvince"];
            weakSelf.str8  = [invDic objectForKey:@"receiveCity"];
            weakSelf.str9  = [invDic objectForKey:@"receiveDistrict"];
            weakSelf.str10 = [invDic objectForKey:@"receiveAddress"];
            weakSelf.str11 = [invDic objectForKey:@"receivePerson"];
            weakSelf.str12 = [invDic objectForKey:@"receivePhone"];
            if (![[invDic objectForKey:@"invoiceStatus"] isEqualToString:@"created"]) {
                [self->btn2 setTitle:@"发票详情" forState:UIControlStateNormal];
                weakSelf.str13 = @"no";
            }
        }

        //产品信息
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *dic in [diction objectForKey:@"shippingOrderItems"]) {
            Model *model = [Model mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        //订单
        NSDictionary *orderDic = [diction objectForKey:@"shippingOrder"];
        self->orderNumLab.text = [orderDic objectForKey:@"orderNo"];
        self->orderCreatetimeLab.text = [Manager TimeCuoToTimes:[orderDic objectForKey:@"createTime"]];
        
        
        self->ProductTotalPriceLab.text = [Manager jinegeshi:[orderDic objectForKey:@"productFee"]];
        self->freightLab.text = [Manager jinegeshi:[orderDic objectForKey:@"discountFee"]];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需付款：%@",[Manager jinegeshi:[orderDic objectForKey:@"orderTotalFee"]]]];
        NSRange range1 = NSMakeRange(0, 4);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
        [self->shifukuanLab setAttributedText:noteStr];
        //发票
        
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)coptext{
    NSString *str = orderNumLab.text;
    self.pBoard.string = str;
    [self TextButtonAction];
}

// 只显示文字
- (void)TextButtonAction{
    MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.text =@"复制成功";
    UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dui"]];
    [hud setCustomView:imageview];
    [hud setMode:MBProgressHUDModeCustomView];
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)setUpHeaderView{
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    headerV.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableHeaderView = headerV;
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    imgV.image = [UIImage imageNamed:@"topUser"];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds=YES;
    [headerV addSubview:imgV];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 60)];
    lab.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:lab];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 15, 100, 30);
    [leftBtn setTitle:self.orderStatus forState:UIControlStateNormal];
    [imgV addSubview:leftBtn];
    
    
    UILabel *bglab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 100)];
    bglab.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(bglab, 10, .5, [UIColor colorWithWhite:.8 alpha:.3]);
    [headerV addSubview:bglab];
    //物流信息
    
    
    //地址
    UIImageView *addreimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 37.5, 25, 25)];
    addreimg.image = [UIImage imageNamed:@"sz1"];
    [bglab addSubview:addreimg];
    namelab = [[UILabel alloc]initWithFrame:CGRectMake(35, 15, SCREEN_WIDTH-50, 25)];
    namelab.font = [UIFont systemFontOfSize:14];
    [bglab addSubview:namelab];
    addresslab = [[UILabel alloc]init];
    addresslab.font = [UIFont systemFontOfSize:14];
    addresslab.numberOfLines = 0;
    [bglab addSubview:addresslab];
}




- (void)setUpFooterView{
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275)];
    footerV.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableFooterView = footerV;
    
    UIView *footerBgv = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 160)];
    footerBgv.backgroundColor = [UIColor whiteColor];
    [footerV addSubview:footerBgv];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
    lab1.text = @"订单编号：";
    lab1.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab1];
   
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 80, 30)];
    lab2.text = @"下单时间：";
    lab2.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab2];
    
    
    orderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 180, 30)];
    orderNumLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:orderNumLab];
    
    self.pBoard = [UIPasteboard generalPasteboard];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(280, 5, 35, 20);
    [btn setTitle:@"复制" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(coptext) forControlEvents:UIControlEventTouchUpInside];
    [footerBgv addSubview:btn];
    
    
    orderCreatetimeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, SCREEN_WIDTH-100, 30)];
    orderCreatetimeLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:orderCreatetimeLab];
    orderNumLab.font = [UIFont systemFontOfSize:14];
    orderCreatetimeLab.font = [UIFont systemFontOfSize:14];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [footerBgv addSubview:line1];
    
    
    
    
    
    
    
    
    
    
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 30)];
    lab5.text = @"发票类型：";
    lab5.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab5];
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 80, 30)];
    lab6.text = @"发票抬头：";
    lab6.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab6];
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 80, 30)];
    lab7.text = @"收票人：";
    lab7.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab7];
    invioceTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 70, SCREEN_WIDTH-100, 30)];
    invioceTypeLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceTypeLab];
    invioceTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 100, SCREEN_WIDTH-100, 30)];
    invioceTitleLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceTitleLab];
    invioceContentLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 130, SCREEN_WIDTH-100, 30)];
    invioceContentLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceContentLab];
    invioceTypeLab.font = [UIFont systemFontOfSize:14];
    invioceTitleLab.font = [UIFont systemFontOfSize:14];
    invioceContentLab.font = [UIFont systemFontOfSize:14];
    
    
    
    UIView *footerBgv1 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 100)];
    footerBgv1.backgroundColor = [UIColor whiteColor];
    [footerV addSubview:footerBgv1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
    label1.text = @"商品总额";
    label1.font = [UIFont systemFontOfSize:15];
    [footerBgv1 addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 80, 30)];
    label2.text = @"折扣";
    label2.font = [UIFont systemFontOfSize:15];
    [footerBgv1 addSubview:label2];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
    line3.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [footerBgv1 addSubview:line3];
    
    ProductTotalPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 30)];
    [footerBgv1 addSubview:ProductTotalPriceLab];
    
    freightLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 30, 80, 30)];
    [footerBgv1 addSubview:freightLab];
    
    
    //    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 61, 70, 39)];
    //    label3.text = @"需付款：";
    //    label3.font = [UIFont systemFontOfSize:15];
    //    [footerBgv1 addSubview:label3];
    
    shifukuanLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 61, SCREEN_WIDTH-20, 39)];
    shifukuanLab.textColor = [UIColor redColor];
    [footerBgv1 addSubview:shifukuanLab];
    
    ProductTotalPriceLab.font = [UIFont systemFontOfSize:15];
    freightLab.font = [UIFont systemFontOfSize:15];
    shifukuanLab.font = [UIFont systemFontOfSize:15];
    ProductTotalPriceLab.textAlignment = NSTextAlignmentRight;
    freightLab.textAlignment = NSTextAlignmentRight;
    shifukuanLab.textAlignment = NSTextAlignmentRight;
}










- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"DZFOrderCell";
    DZFOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[DZFOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Model *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.productItemImg)]];
    cell.lab1.text = model.productTitle;
    cell.lab1.numberOfLines = 0;
    cell.lab3.text = [Manager jinegeshi:model.orderFee];
    cell.lab4.text = model.productItemNo;
    
    cell.lab2.text = [NSString stringWithFormat:@"X%@",model.quantity];
    cell.lab5.text = model.productAttrs;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}







- (void)clickPay{
    __weak typeof(self) weakSelf = self;
    self.tfSheetView = [[TFSheetView alloc]init];
    //取消
    self.tfSheetView.cancelBlock = ^{
        //        NSLog(@"取消");
        [weakSelf.tfSheetView disMissView];
    };
    //微信支付
    self.tfSheetView.wxBlock = ^{
        //        NSLog(@"微信支付");
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
        {
            [weakSelf doWXPay:weakSelf.orderNo];
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
    self.tfSheetView.zfbBlock = ^{
        //        NSLog(@"支付宝支付");
        [weakSelf doAPPay:weakSelf.orderNo];
        [weakSelf.tfSheetView disMissView];
    };
    [self.tfSheetView showInView:self.view];
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
//        NSLog(@"%@",error);
    }];
}


//微信
- (void)doWXPay:(NSString *)orderNo{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
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
    if ([Manager judgeWhetherIsEmptyAnyObject:self.orderNo]==YES) {
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"order/payment/check/%@",self.orderNo];
        NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [Manager requestPOSTWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //            NSString *code = [diction objectForKey:@"code"]
            if ([[diction objectForKey:@"msg"] isEqualToString:@"yes"]) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付完成" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
        } enError:^(NSError *error) {
//            NSLog(@"222-----------%@",error);
        }];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}






- (void)clickCancelOrder{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认取消？" message:@"温馨提示" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"-------%@",[self.sectionArray objectAtIndex:sender.tag]);
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"order/cancel/%@",self.orderNo];
        //NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Manager requestPOSTWithURLStr:KURLNSString(str) paramArr:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
//            NSLog(@"%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"msg"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        } enError:^(NSError *error) {
//            NSLog(@"%@",error);
        }];
        
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)setupDibuView{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(SCREEN_WIDTH-95, 10, 90, 30);
    [btn setTitle:btn1Title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(btn, 13, 0, [UIColor clearColor]);
    [btn addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.frame = CGRectMake(SCREEN_WIDTH-200, 10, 90, 30);
    [btn1 setTitle:btn2Title forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    LRViewBorderRadius(btn1, 13, 1, [UIColor blackColor]);
    [btn1 addTarget:self action:@selector(clickCancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.frame = CGRectMake(SCREEN_WIDTH-300, 10, 90, 30);
    [btn2 setTitle:@"编辑发票" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    LRViewBorderRadius(btn2, 13, 1, [UIColor blackColor]);
    [btn2 addTarget:self action:@selector(clickEditInvioce) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn2];
    
}

- (void)clickEditInvioce{
    FaPiao_ViewController *fapiao = [[FaPiao_ViewController alloc]init];
    fapiao.navigationItem.title = @"编辑发票";
    fapiao.orderNo = self.orderNo;
    
    
    
    fapiao.invioceTitle    = self.str1;
    fapiao.invioceType     = self.str2;
    
    fapiao.bankName        = self.str3;
    fapiao.bankNo          = self.str4;
    fapiao.invoiceCode     = self.str5;
    fapiao.registerAddress = self.str6;
    
    fapiao.receiveProvince = self.str7;
    fapiao.receiveCity     = self.str8;
    fapiao.receiveDistrict = self.str9;
    fapiao.receiveAddress  = self.str10;
    fapiao.receivePerson   = self.str11;
    fapiao.receivePhone    = self.str12;
    
    fapiao.status = self.str13;
    
    [self.navigationController pushViewController:fapiao animated:YES];
}





- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


@end
