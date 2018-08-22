//
//  ShouHouOrderViewController.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/8/22.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ShouHouOrderViewController.h"
#import "DZFOrderCell.h"



#import "DaiFuKuan_ViewController.h"
#import "YiFuKuan_ViewController.h"
#import "CancelOrder_ViewController.h"
#import "DaiFaHuo_ViewController.h"
#import "YiFaHuo_ViewController.h"
#import "YiQianShou_ViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "DXRacer_Store-Swift.h"

#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)


#import "ABABViewController.h"
@interface ShouHouOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *orderNum;
}
@property (nonatomic,strong)NSMutableArray *sectionArray;//分区标题

@property (nonatomic,strong)NSMutableArray *sectionArrayStatus;


@property (nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSMutableArray *statusArray;

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源


@property(nonatomic,strong)TFSheetView *tfSheetView;

@end

@implementation ShouHouOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self getOrderStatus];
    [self getOrderList];
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
            //            NSString *code = [diction objectForKey:@"code"]
            //           NSLog(@"222-----------%@",diction);
            if ([[diction objectForKey:@"msg"] isEqualToString:@"yes"]) {
                [weakSelf getOrderList];
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
        } enError:^(NSError *error) {
            //            NSLog(@"222-----------%@",error);
        }];
    }
}






- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"DZFOrderCell" bundle:nil] forCellReuseIdentifier:@"DZFOrderCell"];
    [self.view addSubview:self.tableview];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableview.tableFooterView = v;
    
    
}




- (void)getOrderStatus{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"加载中....", @"HUD loading title");
    __weak typeof (self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"order/enums") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //        NSLog(@"==////======%@",diction);
        [weakSelf.statusArray removeAllObjects];
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            for (NSDictionary *dic1 in [diction objectForKey:@"object"]) {
                Model *model = [Model mj_objectWithKeyValues:dic1];
                //NSLog(@"%@==////======%@",model.key,model.value);
                [weakSelf.statusArray addObject:model];
            }
        }
        [weakSelf.tableview reloadData];
        [hud hideAnimated:YES];
    } enError:^(NSError *error) {
        [hud hideAnimated:YES];
        //NSLog(@"%@",error);
    }];
}

- (void)getOrderList{
    __weak typeof (self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"refund/getRefundOrderList") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"%@",diction);
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.sectionArray removeAllObjects];
        [weakSelf.sectionArrayStatus removeAllObjects];
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            for (NSDictionary *dic1 in [diction objectForKey:@"object"]) {
                [weakSelf.sectionArrayStatus addObject:[[dic1 objectForKey:@"order"]objectForKey:@"orderStatus"]];
                
                [weakSelf.sectionArray addObject:[[dic1 objectForKey:@"order"]objectForKey:@"orderNo"]];
                
                NSMutableDictionary *dictt = [NSMutableDictionary dictionaryWithCapacity:1];
                [dictt setObject:[dic1 objectForKey:@"orderItems"] forKey:[[dic1 objectForKey:@"order"]objectForKey:@"orderNo"]];
                [weakSelf.dataArray addObject:dictt];
            }
        }else  if ([code isEqualToString:@"401"]){
            [Manager logout];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        
        [weakSelf.tableview reloadData];
        
        
        if (weakSelf.sectionArray.count == 0) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-150, SCREEN_WIDTH, 100)];
            lab.text = @"暂无任何订单";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor lightGrayColor];
            [weakSelf.view addSubview:lab];
        }
    } enError:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"DZFOrderCell";
    DZFOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[DZFOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    NSDictionary *dict = [arr objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString([dict objectForKey:@"productItemImg"])]];
    });
    cell.lab1.text = [dict objectForKey:@"productTitle"];
    cell.lab1.numberOfLines = 0;
    cell.lab3.text = [Manager jinegeshi:[dict objectForKey:@"orderFee"]];
    cell.lab4.text = [dict objectForKey:@"productItemNo"];
    cell.lab2.text = [NSString stringWithFormat:@"X%@",[dict objectForKey:@"quantity"]];
    
    cell.lab5.text = [dict objectForKey:@"productAttrs"];
    
    cell.lab3.textColor = RGB_AB;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *arr = [dic objectForKey:[self.sectionArray objectAtIndex:section]];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    lab.backgroundColor = [UIColor whiteColor];
    [view addSubview:lab];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-120, 49)];
    lab1.text = [NSString stringWithFormat:@"订单号：%@",[self.sectionArray objectAtIndex:section]];
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textColor = [UIColor blackColor];
    lab1.textAlignment = NSTextAlignmentLeft;
    [lab addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 0, 100, 49)];
    NSString *str;
    for (Model *model in self.statusArray) {
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:section]]) {
            str = model.value;
        }
    }
    lab2.text = str;
    lab2.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    lab2.textColor = RGB_AB;
    lab2.textAlignment = NSTextAlignmentRight;
    [lab addSubview:lab2];
    return view;
}

- (void)clickBtn:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    NSString *orderNo = [self.sectionArray objectAtIndex:sender.tag-100];
    //    NSLog(@"---%@",orderNo);
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
            [weakSelf doWXPay:orderNo];
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
        [weakSelf doAPPay:orderNo];
        [weakSelf.tfSheetView disMissView];
    };
    [self.tfSheetView showInView:self.view];
}
#pragma mark   ==============点击订单支付==============
- (void)doAPPay:(NSString *)orderNo
{
    NSString *str = [NSString stringWithFormat:@"order/alipay/%@",orderNo];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        [[AlipaySDK defaultService] payOrder:base64Decoded fromScheme:@"dxracerdiruikesi" callback:^(NSDictionary *resultDic) {
            //            NSLog(@"*****************************result%@",resultDic);
        }];
    } enError:^(NSError *error) {
        //        NSLog(@"%@",error);
    }];
}
//微信
- (void)doWXPay:(NSString *)orderNo{
    orderNum = orderNo;
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




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *str;
    for (Model *model in self.statusArray) {
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:section]]) {
            str = model.key;
        }
    }
    if ([str isEqualToString:@"01"] || [str isEqualToString:@"02"] || [str isEqualToString:@"05"] || [str isEqualToString:@"06"] || [str isEqualToString:@"07"]){
        return 60;
    }
    return 10;
}
- (void)clickbutton{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"订单生成30分钟后自动取消，快前往支付吧" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor whiteColor];
    lab.userInteractionEnabled = YES;
    [view addSubview:lab];
    
    NSString *str;
    for (Model *model in self.statusArray) {
        //        NSLog(@"%@---------%@",model.key,model.value);
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:section]]) {
            str = model.key;
        }
    }
    
    if ([str isEqualToString:@"01"]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, 40, 30);
        [button setTitle:@"⏰" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:button];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-80, 10, 70, 30);
        [btn setTitle:@"去支付" forState:UIControlStateNormal];
        [btn setTitleColor:RGB_AB forState:UIControlStateNormal];
        LRViewBorderRadius(btn, 15, 1, RGB_AB);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + section;
        [lab addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH-190, 10, 90, 30);
        [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn1, 15, 1, [UIColor blackColor]);
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        btn1.tag = section;
        [btn1 addTarget:self action:@selector(clickCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:btn1];
        
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 49);
        
    }else if ([str isEqualToString:@"02"]) {
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn2, 15, 1, [UIColor blackColor]);
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        btn2.tag = section;
        [btn2 addTarget:self action:@selector(clickCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:btn2];
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 49);
    }else if ([str isEqualToString:@"05"]) {
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn2, 15, 1, [UIColor blackColor]);
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        btn2.tag = section;
        [btn2 addTarget:self action:@selector(clickCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:btn2];
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 49);
    }else if ([str isEqualToString:@"07"]) {
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn2 setTitle:@"退货退款" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn2, 15, 1, [UIColor blackColor]);
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        btn2.tag = section;
        [btn2 addTarget:self action:@selector(clickReturnShopping:) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:btn2];
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 49);
    }else if ([str isEqualToString:@"06"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn setTitle:@"确认收货" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn, 15, 1, [UIColor redColor]);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = section;
        [btn addTarget:self action:@selector(clickShouHuo:) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:btn];
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 49);
    }else{
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        lab.frame  = CGRectMake(0, 1, SCREEN_WIDTH, 0);
    }
    
    return view;
}

- (void)clickReturnShopping:(UIButton *)sender{
    ReturnShoppingViewController *ret = [[ReturnShoppingViewController alloc]init];
    ret.orderNo = [self.sectionArray objectAtIndex:sender.tag];
    ret.navigationItem.title = @"退货退款";
    [self.navigationController pushViewController:ret animated:YES];
}

- (void)clickShouHuo:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认签收？" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //        NSLog(@"-------%@",[self.sectionArray objectAtIndex:sender.tag]);
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"order/receive/%@",[self.sectionArray objectAtIndex:sender.tag]];
        //        NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Manager requestPOSTWithURLStr:KURLNSString(str) paramArr:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]){
                [weakSelf getOrderList];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[diction objectForKey:@"msg"] preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf getOrderList];
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)clickCancelOrder:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认取消？" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"-------%@",[self.sectionArray objectAtIndex:sender.tag]);
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"order/cancel/%@",[self.sectionArray objectAtIndex:sender.tag]];
        //NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Manager requestPOSTWithURLStr:KURLNSString(str) paramArr:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]){
                [weakSelf getOrderList];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[diction objectForKey:@"msg"] preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf getOrderList];
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}




// 01---------待付款
// 02---------已付款
// 03---------取消中

// 04---------已取消

// 05---------待发货

// 06---------已发货
// 07---------已签收



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str;
    for (Model *model in self.statusArray) {
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:indexPath.section]]) {
            str = model.value;
        }
    }
    if ([str isEqualToString:@"待付款"]){
        DaiFuKuan_ViewController *or = [[DaiFuKuan_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
    else if ([str isEqualToString:@"已付款"]) {
        YiFuKuan_ViewController *or = [[YiFuKuan_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
    else if ([str isEqualToString:@"待发货"]) {
        DaiFaHuo_ViewController *or = [[DaiFaHuo_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
    else if ([str isEqualToString:@"已发货"]){
        YiFaHuo_ViewController *or = [[YiFaHuo_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
    else if ([str isEqualToString:@"已签收"]){
        YiQianShou_ViewController *or = [[YiQianShou_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
    else {
        CancelOrder_ViewController *or = [[CancelOrder_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }
}





- (NSMutableArray *)sectionArrayStatus{
    if (_sectionArrayStatus == nil) {
        self.sectionArrayStatus = [NSMutableArray arrayWithCapacity:1];
    }
    return _sectionArrayStatus;
}
- (NSMutableArray *)statusArray{
    if (_statusArray == nil) {
        self.statusArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _statusArray;
}

- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        self.sectionArray =[NSMutableArray arrayWithCapacity:1];
    }
    return _sectionArray;
}


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

@end
