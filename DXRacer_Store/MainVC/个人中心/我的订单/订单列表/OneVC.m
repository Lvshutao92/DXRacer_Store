//
//  OneVC.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/5/1.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "OneVC.h"
#import "DZFOrderCell.h"
#import "ProductOrderDetailsViewController.h"
#import "ProductOrder_TwoDetails_ViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"


#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)

@interface OneVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *sectionArray;//分区标题

@property (nonatomic,strong)NSMutableArray *sectionArrayStatus;


@property(nonatomic,strong)NSMutableArray *statusArray;

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源


@property(nonatomic,strong)TFSheetView *tfSheetView;
@end

@implementation OneVC


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    
    [self getOrderStatus];
    [self getOrderList];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单";
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"DZFOrderCell" bundle:nil] forCellReuseIdentifier:@"DZFOrderCell"];
    [self.view addSubview:self.tableview];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableview.tableFooterView = v;
}

- (void)getOrderStatus{
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
    } enError:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}

- (void)getOrderList{
    __weak typeof (self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"order/list") paramDic:nil token:nil finish:^(id responseObject) {
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
        }
        [weakSelf.tableview reloadData];
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
    cell.lab2.text = [Manager jinegeshi:[dict objectForKey:@"productFee"]];
    cell.lab3.text = [dict objectForKey:@"productItemNo"];
    
    cell.lab4.text = [NSString stringWithFormat:@"X%@",[dict objectForKey:@"quantity"]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
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
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.textColor = [UIColor redColor];
    lab2.textAlignment = NSTextAlignmentRight;
    [lab addSubview:lab2];
    return view;
}

- (void)clickBtn:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    NSString *orderNo = [self.sectionArray objectAtIndex:sender.tag-100];
    NSLog(@"---%@",orderNo);
    
    self.tfSheetView = [[TFSheetView alloc]init];
    //取消
    self.tfSheetView.cancelBlock = ^{
        NSLog(@"取消");
        [weakSelf.tfSheetView disMissView];
    };
    //微信支付
    self.tfSheetView.wxBlock = ^{
        NSLog(@"微信支付");
        [weakSelf.tfSheetView disMissView];
    };
    //支付宝支付
    self.tfSheetView.zfbBlock = ^{
        NSLog(@"支付宝支付");
        [weakSelf doAPPay:orderNo];
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
//            NSLog(@"*****************************result%@",resultDic);
        }];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}






- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 49)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.userInteractionEnabled = YES;
    [view addSubview:lab];
    
    NSString *str;
    for (Model *model in self.statusArray) {
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:section]]) {
            str = model.key;
        }
    }
    
    if ([str isEqualToString:@"01"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-80, 10, 70, 30);
        [btn setTitle:@"去支付" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn, 15, 1, [UIColor orangeColor]);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + section;
        [lab addSubview:btn];
        
    }else if ([str isEqualToString:@"02"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn setTitle:@"确认收货" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn, 15, 1, [UIColor redColor]);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [lab addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH-200, 10, 90, 30);
        [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn1, 15, 1, [UIColor blackColor]);
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [lab addSubview:btn1];
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
        [btn setTitle:@"阿西吧啊" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        LRViewBorderRadius(btn, 15, 1, [UIColor blackColor]);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [lab addSubview:btn];
    }
    
    
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str;
    for (Model *model in self.statusArray) {
        if ([model.key isEqualToString:[self.sectionArrayStatus objectAtIndex:indexPath.section]]) {
            str = model.value;
        }
    }
    if ([str isEqualToString:@"已付款"]) {
        ProductOrderDetailsViewController *or = [[ProductOrderDetailsViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }else if ([str isEqualToString:@"待付款"]){
        ProductOrder_TwoDetails_ViewController *or = [[ProductOrder_TwoDetails_ViewController alloc]init];
        or.orderNo = [self.sectionArray objectAtIndex:indexPath.section];
        or.orderStatus = str;
        [self.navigationController pushViewController:or animated:YES];
    }else{
        
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
