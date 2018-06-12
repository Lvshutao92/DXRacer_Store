//
//  YiQianShou_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/5.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "YiQianShou_ViewController.h"
#import "DZFOrderCell.h"
@interface YiQianShou_ViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    UIButton *btn;
    UIView *v;
}

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源

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
@end

@implementation YiQianShou_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.navigationItem.title = @"订单详情";
    
    btn1Title = @"编辑发票";
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"DZFOrderCell" bundle:nil] forCellReuseIdentifier:@"DZFOrderCell"];
    [self.view addSubview:self.tableview];
    
    
    UIView *vvv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
    self.tableview.tableFooterView = vvv;
    
    [self setUpHeaderView];
    [self setUpFooterView];
    
    
    [self setupDibuView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [self getOrderDetailsInfomation];
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
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付款：%@",[Manager jinegeshi:[orderDic objectForKey:@"orderTotalFee"]]]];
        NSRange range1 = NSMakeRange(0, 4);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
        [self->shifukuanLab setAttributedText:noteStr];
        
        
        
        
       
        self->payTypeLab.text = [Manager TimeCuoToTimes:[orderDic objectForKey:@"receiveTime"]];
        
        
        
        //发票
        if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"shippingInvoice"]]==YES) {
            NSDictionary *invDic = [diction objectForKey:@"shippingInvoice"];
            self->invioceTypeLab.text = [invDic objectForKey:@"invoiceType"];
            self->invioceTitleLab.text = [invDic objectForKey:@"invoiceTitle"];
            
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
                self->v.hidden = YES;
            }
        }
       
        
        
        
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 315)];
    footerV.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableFooterView = footerV;
    
    UIView *footerBgv = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 200)];
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
    orderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-100, 30)];
    orderNumLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:orderNumLab];
    orderCreatetimeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, SCREEN_WIDTH-100, 30)];
    orderCreatetimeLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:orderCreatetimeLab];
    orderNumLab.font = [UIFont systemFontOfSize:14];
    orderCreatetimeLab.font = [UIFont systemFontOfSize:14];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    line1.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [footerBgv addSubview:line1];
    
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 30)];
    lab3.text = @"签收时间：";
    lab3.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab3];
    payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 70, SCREEN_WIDTH-100, 30)];
    payTypeLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:payTypeLab];
    payTypeLab.font = [UIFont systemFontOfSize:14];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 1)];
    line2.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [footerBgv addSubview:line2];
    
    
    
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 80, 30)];
    lab5.text = @"发票类型：";
    lab5.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab5];
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 80, 30)];
    lab6.text = @"发票抬头：";
    lab6.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab6];
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 80, 30)];
    lab7.text = @"发票内容：";
    lab7.font = [UIFont systemFontOfSize:15];
    [footerBgv addSubview:lab7];
    invioceTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 110, SCREEN_WIDTH-100, 30)];
    invioceTypeLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceTypeLab];
    invioceTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 140, SCREEN_WIDTH-100, 30)];
    invioceTitleLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceTitleLab];
    invioceContentLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 170, SCREEN_WIDTH-100, 30)];
    invioceContentLab.textColor = [UIColor grayColor];
    [footerBgv addSubview:invioceContentLab];
    invioceTypeLab.font = [UIFont systemFontOfSize:14];
    invioceTitleLab.font = [UIFont systemFontOfSize:14];
    invioceContentLab.font = [UIFont systemFontOfSize:14];
    
    
    
    UIView *footerBgv1 = [[UIView alloc]initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, 100)];
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







- (void)click{
    
}










- (void)setupDibuView{
    v = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
    [btn setTitle:@"编辑发票" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    LRViewBorderRadius(btn, 13, 1, [UIColor blackColor]);
    [btn addTarget:self action:@selector(clickEditInvioce) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
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
    [self.navigationController pushViewController:fapiao animated:YES];
}








- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


@end
