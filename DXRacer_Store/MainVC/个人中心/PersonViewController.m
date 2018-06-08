//
//  PersonViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "PersonViewController.h"
#import "AccountEditTableViewController.h"
#import "AddrViewController.h"



#import "TWScrollViewVC.h"
#import "OneVC.h"
#import "TwoVC.h"
#import "ThreeVC.h"
#import "FourVC.h"
#import "FiveVC.h"

#import "CouponsViewController.h"
#import "CouponsOneVC.h"
#import "CouponsTwoVC.h"
#import "CouponsThreeVC.h"

#import "GetACouponViewController.h"
#import "AboutUsViewController.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    SQCustomButton *button1;
    SQCustomButton *button2;
    SQCustomButton *button3;
    SQCustomButton *button4;
    SQCustomButton *button5;
    
    UIView *v;
    UIImageView *imgV;
    UILabel *user1;
    UIImageView *userImg;
    
    UIView *view_bar;
    UILabel *lab;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation PersonViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    
    
    [self getInfomation];
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"phone.text"]] != YES) {
        user1.text = @"登录/注册";
        userImg.image = [UIImage imageNamed:@"tx.jpg"];
    }
}


-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingBlock:^{
        [weakSelf getInfomation];
    }];
    [header beginRefreshing];
    self.tableview.mj_header = header;
}
- (void)getInfomation{
    __weak typeof (self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"account") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"%@",diction);
        
        [Manager writewenjianming:@"img.text" content:[diction objectForKey:@"iconUrl"]];
        [Manager writewenjianming:@"nikname.text" content:[diction objectForKey:@"nickName"]];
        
        [self->userImg sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"iconUrl"]]placeholderImage:[UIImage imageNamed:@"tx.jpg"]];
        
        if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"phone.text"]] == YES) {
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"nickName"]]==YES) {
                self->user1.text = [diction objectForKey:@"nickName"];
            }else{
                self->user1.text = [Manager redingwenjianming:@"phone.text"];
                self->userImg.image = [UIImage imageNamed:@"tx.jpg"];
            }
        }else{
            self->user1.text = @"登录/注册";
            self->userImg.image = [UIImage imageNamed:@"tx.jpg"];
        }
        
        
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"401"]){
            [Manager logout];
            self->user1.text = @"登录/注册";
            self->userImg.image = [UIImage imageNamed:@"tx.jpg"];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的账号已在其他设备登录，请重新登录" message:@"温馨提示" preferredStyle:1];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }];
//            [alert addAction:cancel];
//            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                LoginViewController *login = [[LoginViewController alloc]init];
//                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                [weakSelf presentViewController:login animated:YES completion:nil];
//            }];
//            [alert addAction:sure];
//            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        [weakSelf.tableview.mj_header endRefreshing];
    } enError:^(NSError *error) {
    }];
}



- (void)viewWillDisappear:(BOOL)animated{
}


- (void)clickedit {
    if ([Manager redingwenjianming:@"token.text"] != nil) {
        AccountEditTableViewController *addr = [[AccountEditTableViewController alloc]init];
        addr.navigationItem.title = @"设置";
        [self.navigationController pushViewController:addr animated:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }
}
- (void)clicktap:(UIButton *)tap{
    if ([Manager redingwenjianming:@"token.text"] != nil) {
        AccountEditTableViewController *addr = [[AccountEditTableViewController alloc]init];
        addr.navigationItem.title = @"设置";
        [self.navigationController pushViewController:addr animated:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.dataArray = [@[@"我的订单",@"我的优惠券",@"领券中心",@"我的收藏",@"QQ客服",@"联系我们",@"关于我们"]mutableCopy];
    
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(clickedit)];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
   
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    
    
    v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    v.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    self.tableview.tableHeaderView = v;
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableview.tableFooterView = vv;
    
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    imgV.userInteractionEnabled = YES;
    imgV.image = [UIImage imageNamed:@"topUser"];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds=YES;
    [v addSubview:imgV];
    

    
    
     /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 55)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"  我的订单";
    [v addSubview:label];
    UILabel *bgv = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 100)];
    bgv.backgroundColor = [UIColor whiteColor];
    bgv.userInteractionEnabled = YES;
    [v addSubview:bgv];
    
    
    
    
   
    button1 = [[SQCustomButton alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/5, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button1.isShowSelectBackgroudColor = NO;
    button1.imageView.image = [UIImage imageNamed:@"待付款"];
    button1.titleLabel.text = @"待付款";
    [bgv addSubview:button1];
    [button1 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"待付款",@"待发货",@"待收货",@"已完成",@"售后"] index:0];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    button2 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, 15, SCREEN_WIDTH/5, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button2.isShowSelectBackgroudColor = NO;
    button2.imageView.image = [UIImage imageNamed:@"待发货"];
    button2.titleLabel.text = @"待发货";
    [bgv addSubview:button2];
    [button2 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"待付款",@"待发货",@"待收货",@"已完成",@"售后"] index:1];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    
    button3 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*2, 15, SCREEN_WIDTH/5, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button3.isShowSelectBackgroudColor = NO;
    button3.imageView.image = [UIImage imageNamed:@"待收货"];
    button3.titleLabel.text = @"待收货";
    [bgv addSubview:button3];
    [button3 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"待付款",@"待发货",@"待收货",@"已完成",@"售后"] index:2];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    button4 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 15, SCREEN_WIDTH/5, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button4.isShowSelectBackgroudColor = NO;
    button4.imageView.image = [UIImage imageNamed:@"已完成"];
    button4.titleLabel.text = @"已完成";
    [bgv addSubview:button4];
    [button4 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"待付款",@"待发货",@"待收货",@"已完成",@"售后"] index:3];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    button5 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*4, 15, SCREEN_WIDTH/5, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button5.isShowSelectBackgroudColor = NO;
    button5.imageView.image = [UIImage imageNamed:@"售后"];
    button5.titleLabel.text = @"售后";
    [bgv addSubview:button5];
    [button5 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"待付款",@"待发货",@"待收货",@"已完成",@"售后"] index:4];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    button1.backgroundColor = [UIColor whiteColor];
    button2.backgroundColor = [UIColor whiteColor];
    button3.backgroundColor = [UIColor whiteColor];
    button4.backgroundColor = [UIColor whiteColor];
    button5.backgroundColor = [UIColor whiteColor];
    */
    
    UILabel *botomV = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 60)];
    botomV.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    botomV.userInteractionEnabled = YES;
    [imgV addSubview:botomV];
    SQCustomButton *btn = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, 5, 100, 50)
                                                              type:SQCustomButtonRightImageType
                                                         imageSize:CGSizeMake(25, 25) midmargin:0];
    btn.isShowSelectBackgroudColor = NO;
    btn.imageView.image = [UIImage imageNamed:@"箭头3"];
    btn.titleLabel.text = @"去购物抵扣";
    btn.titleLabel.textColor = [UIColor grayColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [botomV addSubview:btn];
    [botomV bringSubviewToFront:btn];
    [btn touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            NSLog(@"去购物抵扣");
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    SQCustomButton *btn1 = [[SQCustomButton alloc]initWithFrame:CGRectMake(10, 5, 100, 50)
                                                          type:SQCustomButtonLeftImageType
                                                     imageSize:CGSizeMake(30, 30) midmargin:10];
    btn1.isShowSelectBackgroudColor = NO;
    btn1.imageView.image = [UIImage imageNamed:@"钱袋"];
    btn1.titleLabel.text = @"积分0";
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [botomV addSubview:btn1];
    
    
    
    userImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 20, 90, 90)];
    LRViewBorderRadius(userImg, 45, 0, [UIColor clearColor]);
    userImg.userInteractionEnabled = YES;
    [imgV addSubview:userImg];
    
    
    user1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 110, 150, 30)];
    user1.textColor = [UIColor whiteColor];
    user1.textAlignment = NSTextAlignmentCenter;
    user1.numberOfLines = 0;
    [imgV addSubview:user1];
    
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    btns.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    [btns addTarget:self action:@selector(clicktap:) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:btns];
}











- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"cell";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%ld",indexPath.row+1]];
    cell.lab.text = self.dataArray[indexPath.row];
    cell.img.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        if ([Manager redingwenjianming:@"phone.text"] == nil){
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }else{
            OneVC *vc = [[OneVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 1){
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            CouponsViewController *scr = [[CouponsViewController alloc] initWithAddVCARY:@[[CouponsOneVC new],[CouponsTwoVC new],[CouponsThreeVC new]]TitleS:@[@"未使用",@"已使用",@"已过期"] index:0];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }else if (indexPath.row == 2){
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            GetACouponViewController *about = [[GetACouponViewController alloc]init];
            about.navigationItem.title = @"领券中心";
            [self.navigationController pushViewController:about animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }else if (indexPath.row == 3){
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }else if (indexPath.row == 4){
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"309718069"];
        NSURL *url = [NSURL URLWithString:qqstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else if (indexPath.row == 5) {
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"4009005033"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        AboutUsViewController *about = [[AboutUsViewController alloc]init];
        about.navigationItem.title = @"关于我们";
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}







- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

@end
