//
//  CreateOrderViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/17.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "AddrViewController.h"
#import "CartModel.h"

#import "ProductOrder_TwoDetails_ViewController.h"
#import "ProductOrderDetailsViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"


#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)



@interface CreateOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UILabel *namelab;
    UILabel *phonelab;
    UILabel *addresslab;
    
    CGFloat heigh;
    UIButton *btn;
    
    CGFloat zongjiage;
    
    NSString *addressID;
    UITextField *youhuimaText;
    BOOL isno;
    
    NSString *availableSku;
    NSString *availableCatalog;
    NSString *couponMode;//rate price
    NSString *modeValue;
    
    CGFloat totheight;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *totalPrice;

@property(nonatomic,strong)NSMutableArray *idsArray;

@property(nonatomic,strong)TFSheetView *tfSheetView;



@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scro];
    
    
    for (CartModel *model in self.dataArray) {
//        CGFloat price = [model.salePrice doubleValue];
//        NSInteger num = [model.quantity integerValue];
//        zongjiage = zongjiage + num * price;
        [self.idsArray addObject:model.id];
        if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle] != YES) {
            isno = YES;
        }
    }
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-55)];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"CreateOrderCell" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell"];
    [scro addSubview:self.tableview];
    
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    headerV.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableHeaderView = headerV;
    
    UIView *footerV = [[UIView alloc]init];
    footerV.backgroundColor =[UIColor whiteColor];
    self.tableview.tableFooterView = footerV;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 65, 30)];
    lab.text = @"优惠码：";
    lab.font = [UIFont systemFontOfSize:15];
    [footerV addSubview:lab];
    youhuimaText = [[UITextField alloc]initWithFrame:CGRectMake(75, 10, SCREEN_WIDTH-85, 40)];
    youhuimaText.delegate = self;
    youhuimaText.placeholder = @"请输入优惠码";
    youhuimaText.borderStyle = UITextBorderStyleNone;
    [footerV addSubview:youhuimaText];
    UILabel *footline = [[UILabel alloc]initWithFrame:CGRectMake(75, 50, SCREEN_WIDTH-85, 1)];
    footline.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    [footerV addSubview:footline];
    
    if (isno == YES) {
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        lab.hidden = NO;
        youhuimaText.hidden = NO;
        footline.hidden = NO;
    }else{
        footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        lab.hidden = YES;
        youhuimaText.hidden = YES;
        footline.hidden = YES;
    }
    
    
    UIView *bgv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    bgv.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:bgv];
    
    UIImageView *addreimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 25, 25)];
    addreimg.image = [UIImage imageNamed:@"sz1"];
    [bgv addSubview:addreimg];
    
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25, 40, 20, 20)];
    jiantou.image = [UIImage imageNamed:@"箭头3"];
    [bgv addSubview:jiantou];
    
    namelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-180, 20)];
//    namelab.text = @"收货人：吕书涛";
    namelab.font = [UIFont systemFontOfSize:14];
    [bgv addSubview:namelab];
    
    phonelab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 20, 110, 20)];
//    phonelab.text = @"18551049547";
    phonelab.font = [UIFont systemFontOfSize:14];
    phonelab.textAlignment = NSTextAlignmentRight;
    [bgv addSubview:phonelab];
    
    
    addresslab = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, SCREEN_WIDTH-65, 50)];
//    addresslab.text = @"收货地址：江苏省无锡市惠山区智慧路19号五彩科技";
    addresslab.font = [UIFont systemFontOfSize:14];
    addresslab.numberOfLines = 0;
    [bgv addSubview:addresslab];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getaddress) forControlEvents:UIControlEventTouchUpInside];
    [bgv addSubview:btn];
    
    
    [self setupdibuview];
    
    
    [self lodinfo];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (addressID.length > 0 && textField.text.length > 0 && _idsArray.count>0) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"addressId":addressID,@"couponCode":youhuimaText.text,@"productItemIds":_idsArray,};
        [Manager requestPOSTWithURLStr:KURLNSString(@"promotion/coupon") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSLog(@"--%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]){
                self->zongjiage = 0.0;
                NSDictionary *dic = [diction objectForKey:@"object"];
                self->availableSku = [dic objectForKey:@"availableSku"];
                self->availableCatalog = [dic objectForKey:@"availableCatalog"];
                self->couponMode = [dic objectForKey:@"couponMode"];
                self->modeValue = [dic objectForKey:@"modeValue"];
                [weakSelf.tableview reloadData];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"object"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self->zongjiage = 0.0;
                    self->couponMode = @"";
                    [weakSelf.tableview reloadData];
                }];
                [alert addAction:sure];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
            self->zongjiage = 0.0;
            self->couponMode = @"";
            [weakSelf.tableview reloadData];
        }];
    }else{
        zongjiage = 0.0;
        couponMode = @"";
        [self.tableview reloadData];
    }
}





- (void)getaddress{
    AddrViewController *addr = [[AddrViewController alloc]init];
    addr.navigationItem.title = @"收货地址";
    addr.order = @"order";
    [self.navigationController pushViewController:addr animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"CreateOrderCell";
    CreateOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[CreateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.image)]];
    
    cell.lab1.text = model.productName;
    cell.lab1.numberOfLines = 0;
    cell.lab1.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.lab1 sizeThatFits:CGSizeMake(SCREEN_WIDTH-145, MAXFLOAT)];
    cell.lab1height.constant = size.height;
    
    cell.lab2.text = model.productAttr;
    cell.lab4.text = [NSString stringWithFormat:@"X%@",model.quantity];
    
    if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
        cell.lab6.hidden = NO;
        if ([Manager widthForString:model.promotionTitle fontSize:14 andHeight:20] > (SCREEN_WIDTH/2)) {
            cell.lab6width.constant = SCREEN_WIDTH-145;
        }else{
            cell.lab6width.constant = [Manager widthForString:model.promotionTitle fontSize:14 andHeight:20]+20;
        }
         totheight = size.height + 30;
    }else{
        cell.lab6.hidden = YES;
        cell.lab6width.constant = 0;
        totheight = size.height;
    }
    cell.lab6.text = model.promotionTitle;

    
    if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle] != YES) {
        
        if ([Manager judgeWhetherIsEmptyAnyObject:availableSku] != YES && [Manager judgeWhetherIsEmptyAnyObject:availableCatalog] != YES)
        {
            
            if ([couponMode isEqualToString:@"rate"]) {
                double bi = 1-[modeValue doubleValue];
                
                NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue]*bi];
                cell.lab3.text = [Manager jinegeshi:danjia];
                
                NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]*bi];
                cell.lab5.text = [Manager jinegeshi:totalStr];
                
                zongjiage = zongjiage + [totalStr doubleValue];//所有总价
            }else if ([couponMode isEqualToString:@"price"]){
                NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue] - [modeValue doubleValue]];
                cell.lab3.text = [Manager jinegeshi:danjia];
                
                NSString *totalStr = [NSString stringWithFormat:@"%f",[danjia doubleValue] * [model.quantity integerValue]];
                cell.lab5.text = [Manager jinegeshi:totalStr];
                
                zongjiage = zongjiage + [totalStr doubleValue];//所有总价
            }else{
                cell.lab3.text = [Manager jinegeshi:model.salePrice];
                NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
                cell.lab5.text = [Manager jinegeshi:totalStr];
                
                zongjiage = zongjiage + [totalStr doubleValue];//所有总价
            }
            
        }
        else if([Manager judgeWhetherIsEmptyAnyObject:availableSku] == YES)
        {
            
            if ([model.productType isEqualToString:availableSku]) {
                if ([couponMode isEqualToString:@"rate"]) {
                    double bi = 1-[modeValue doubleValue];
                    
                    NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue]*bi];
                    cell.lab3.text = [Manager jinegeshi:danjia];
                    
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]*bi];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }else if ([couponMode isEqualToString:@"price"]){
                    NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue] - [modeValue doubleValue]];
                    cell.lab3.text = [Manager jinegeshi:danjia];
                    
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[danjia doubleValue] * [model.quantity integerValue]];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }else{
                    cell.lab3.text = [Manager jinegeshi:model.salePrice];
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }
            }else{
                cell.lab3.text = [Manager jinegeshi:model.salePrice];
                NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
                cell.lab5.text = [Manager jinegeshi:totalStr];
                
                zongjiage = zongjiage + [totalStr doubleValue];//所有总价
            }
            
        }
        else if([Manager judgeWhetherIsEmptyAnyObject:availableSku] != YES && [Manager judgeWhetherIsEmptyAnyObject:availableCatalog] == YES)
        {
            
            if ([model.productType isEqualToString:availableCatalog]) {
                if ([couponMode isEqualToString:@"rate"]) {
                    double bi = 1-[modeValue doubleValue];
                    
                    NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue]*bi];
                    cell.lab3.text = [Manager jinegeshi:danjia];
                    
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]*bi];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }else if ([couponMode isEqualToString:@"price"]){
                    NSString *danjia = [NSString stringWithFormat:@"%.2f",[model.salePrice doubleValue] - [modeValue doubleValue]];
                    cell.lab3.text = [Manager jinegeshi:danjia];
                    
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[danjia doubleValue] * [model.quantity integerValue]];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }else{
                    cell.lab3.text = [Manager jinegeshi:model.salePrice];
                    NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
                    cell.lab5.text = [Manager jinegeshi:totalStr];
                    zongjiage = zongjiage + [totalStr doubleValue];//所有总价
                }
            }else{
                cell.lab3.text = [Manager jinegeshi:model.salePrice];
                NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
                cell.lab5.text = [Manager jinegeshi:totalStr];
                zongjiage = zongjiage + [totalStr doubleValue];//所有总价
            }
            
        }
        
    }else{
        
        cell.lab3.text = [Manager jinegeshi:model.salePrice];
        NSString *totalStr = [NSString stringWithFormat:@"%f",[model.salePrice doubleValue] * [model.quantity integerValue]];
        cell.lab5.text = [Manager jinegeshi:totalStr];
        
        zongjiage = zongjiage + [totalStr doubleValue];//所有总价
    }
    
    
    
    
    
    
    
    
    self.totalPrice.text = [Manager jinegeshi:[NSString stringWithFormat:@"%.2f",zongjiage]];
    
    
    cell.line1.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    cell.line2.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120 + totheight;
}





- (void)commitOrder{
    if ([Manager judgeWhetherIsEmptyAnyObject:youhuimaText.text] != YES) {
        youhuimaText.text = @"";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认提交？" message:@"温馨提示" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __weak typeof(self) weakSelf = self;
        if (self->_idsArray.count > 0 && self->addressID.length > 0) {
            NSDictionary *dic = @{@"productItemIds":self->_idsArray,
                                  @"addressId":self->addressID,
                                  @"couponCode":self->youhuimaText.text
                                  };
            NSLog(@"=======%@",dic);
            [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/confirm") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                //NSLog(@"--%@",diction);
                NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
                if ([code isEqualToString:@"200"]){
                    
                    weakSelf.tfSheetView = [[TFSheetView alloc]init];
                    //取消
                    weakSelf.tfSheetView.cancelBlock = ^{
                        [weakSelf.dataArray removeAllObjects];
                        [weakSelf.tableview reloadData];
                        ProductOrder_TwoDetails_ViewController *or = [[ProductOrder_TwoDetails_ViewController alloc]init];
                        or.orderNo = [diction objectForKey:@"msg"];
                        or.orderStatus = @"待付款";
                        [self.navigationController pushViewController:or animated:YES];
                        [weakSelf.tfSheetView disMissView];
                    };
                    //微信支付
                    weakSelf.tfSheetView.wxBlock = ^{
                        NSLog(@"微信支付");
                        [weakSelf.dataArray removeAllObjects];
                        [weakSelf.tableview reloadData];
                        [weakSelf.tfSheetView disMissView];
                    };
                    //支付宝支付
                    weakSelf.tfSheetView.zfbBlock = ^{
                        NSLog(@"支付宝支付");
                        [weakSelf.dataArray removeAllObjects];
                        [weakSelf.tableview reloadData];
                        [weakSelf doAPPay:[diction objectForKey:@"msg"]];
                        [weakSelf.tfSheetView disMissView];
                    };
                    [weakSelf.tfSheetView showInView:self.view];
                }
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
        
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
    
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
























- (void)lodinfo{
//    __weak typeof (self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"address") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        
            NSMutableArray *array = (NSMutableArray *)diction;
            if ([Manager judgeWhetherIsEmptyAnyObject:array]==YES && array.count > 0) {
                NSDictionary *dic = [array firstObject];
                self->addressID = [dic objectForKey:@"id"];
                self->namelab.text    = [NSString stringWithFormat:@"收货人：%@",[dic objectForKey:@"person"]];
                self->phonelab.text   = [dic objectForKey:@"phone"];
                self->addresslab.text = [NSString stringWithFormat:@"收货地址：%@",[NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"receiveProvince"],[dic objectForKey:@"receiveCity"],[dic objectForKey:@"receiveDistrict"],[dic objectForKey:@"address"]]];
                if (self->namelab.text.length <= 0) {
                    [self->btn setTitle:@"请选择收货地址" forState:UIControlStateNormal];
                }else{
                    [self->btn setTitle:@"" forState:UIControlStateNormal];
                }
            }
        //NSLog(@"----%@",diction);
    } enError:^(NSError *error) {
        //NSLog(@"----%@",error);
    }];
}










- (void)setupdibuview{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH-120, 0, 120, 55);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"提交订单" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    self.totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-140, 55)];
    self.totalPrice.textColor = [UIColor redColor];
    
    self.totalPrice.text = [Manager jinegeshi:[NSString stringWithFormat:@"%.2f",zongjiage]];
    
    self.totalPrice.font = [UIFont systemFontOfSize:20];
    [view addSubview:self.totalPrice];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if (namelab.text.length <= 0) {
        [btn setTitle:@"请选择收货地址" forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuanzhi:) name:@"chuanzhi" object:nil];
    
}
- (void)chuanzhi:(NSNotification *)text {
    NSDictionary *dic = text.userInfo;
    namelab.text = [NSString stringWithFormat:@"收货人：%@",[dic objectForKey:@"name"]];
    phonelab.text = [dic objectForKey:@"phone"];
    addresslab.text = [NSString stringWithFormat:@"收货地址：%@",[dic objectForKey:@"address"]];
    addressID = [dic objectForKey:@"id"];
    if (namelab.text.length <= 0) {
        [btn setTitle:@"请选择收货地址" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (NSMutableArray *)idsArray{
    if (_idsArray == nil) {
        self.idsArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _idsArray;
}
@end
