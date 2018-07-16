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
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
     [self SetNavBarHidden:YES];
    [self getInfomation];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self SetNavBarHidden:NO];
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    // 返回你所需要的状态栏样式
    return UIStatusBarStyleLightContent;
}
#pragma mark - NavItem
-(void) SetNavBarHidden:(BOOL) isHidden
{
    self.navigationController.navigationBarHidden = isHidden;
}
-(UIView*)NavigationBa
{
    view_bar =[[UIView alloc]init];
    view_bar.frame=CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHAbove7);
    //    view_bar.backgroundColor=[UIColor clearColor];
    [self.view addSubview: view_bar];
    
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view_bar.bounds;
    //    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(65, 105, 225, 1) CGColor],(id)[RGBACOLOR(49, 184, 243, 1) CGColor], nil];
    [view_bar.layer insertSublayer:gradient atIndex:0];
    //    [self.navigationController.navigationBar.layer insertSublayer:gradient above:0];
    
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, kStatusBarHeight, SCREEN_WIDTH-120, 44)];
    lab.text = @"我的";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [view_bar addSubview:lab];
    
    
    UIButton *szbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    szbtn.frame = CGRectMake(SCREEN_WIDTH-40, kStatusBarHeight+7, 30, 30);
    [szbtn setImage:[UIImage imageNamed:@"设置-2"] forState:UIControlStateNormal];
    [szbtn addTarget:self action:@selector(clickedit) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:szbtn];
    
    [self.view bringSubviewToFront:view_bar];
    return view_bar;
}




-(void)setUpReflash
{
    LRWeakSelf(self);
    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingBlock:^{
        [weakSelf getInfomation];
    }];
    [header beginRefreshing];
    self.tableview.mj_header = header;
}
- (void)getInfomation{
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"phone.text"]] != YES) {
        user1.text = @"登录/注册";
        userImg.image = [UIImage imageNamed:@"人"];
    }
    LRWeakSelf(self);
    [Manager requestPOSTWithURLStr:KURLNSString(@"account") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"----%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"401"]){
            [Manager logout];
            self->user1.text = @"登录/注册";
            self->userImg.image = [UIImage imageNamed:@"人"];
        }else{
            [Manager writewenjianming:@"img.text" content:[diction objectForKey:@"iconUrl"]];
            [Manager writewenjianming:@"nikname.text" content:[diction objectForKey:@"nickName"]];
            if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"phone.text"]] == YES) {
                if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"nickName"]]==YES) {
                    self->user1.text = [diction objectForKey:@"nickName"];
                    [self->userImg sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"iconUrl"]]];
                }else{
                    self->user1.text = [Manager redingwenjianming:@"phone.text"];
                    self->userImg.image = [UIImage imageNamed:@"人"];
                }
            }else{
                self->user1.text = @"登录/注册";
                self->userImg.image = [UIImage imageNamed:@"人"];
            }
        }
        [weakSelf.tableview.mj_header endRefreshing];
    } enError:^(NSError *error) {
    }];
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
    
    
//    UIView *btnview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIButton *szbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    szbtn.frame = CGRectMake(14, 7, 30, 30);
//    [szbtn setImage:[UIImage imageNamed:@"设置-2"] forState:UIControlStateNormal];
//    [szbtn addTarget:self action:@selector(clickedit) forControlEvents:UIControlEventTouchUpInside];
//    [btnview addSubview:szbtn];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnview];
//    self.navigationItem.rightBarButtonItem = bar;
    
    
    
   
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT+kStatusBarHeight) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
//    [self NavigationBa];
    
    
    v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+kNavBarHAbove7)];
    v.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    self.tableview.tableHeaderView = v;
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableview.tableFooterView = vv;
    
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+kNavBarHAbove7)];
    imgV.userInteractionEnabled = YES;
//    imgV.image = [UIImage imageNamed:@"topUser"];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds=YES;
    [v addSubview:imgV];
    

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = imgV.bounds;
    //    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGB_B CGColor],(id)[RGB_A CGColor],(id)[RGB_B CGColor], nil];
    [imgV.layer insertSublayer:gradient atIndex:0];
    
    UIButton *szbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    szbtn.frame = CGRectMake(SCREEN_WIDTH-45, kStatusBarHeight+7, 30, 30);
    [szbtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [szbtn addTarget:self action:@selector(clickedit) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:szbtn];
    //*************订单*********************
    /*
    UILabel *bgv0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 49)];
    bgv0.backgroundColor = [UIColor whiteColor];
    bgv0.userInteractionEnabled = YES;
    [v addSubview:bgv0];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 49)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"我的订单";
    [bgv0 addSubview:label];
    
    button5 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95, 0, 90, 49)
                                              type:SQCustomButtonRightImageType
                                         imageSize:CGSizeMake(25, 25) midmargin:0];
    button5.isShowSelectBackgroudColor = NO;
    button5.imageView.image = [UIImage imageNamed:@"箭头3"];
    button5.titleLabel.text = @"查看更多";
    button5.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgv0 addSubview:button5];
    [button5 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"已完成"] index:0];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    
    UILabel *bgv = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 100)];
    bgv.backgroundColor = [UIColor whiteColor];
    bgv.userInteractionEnabled = YES;
    [v addSubview:bgv];
    
    button1 = [[SQCustomButton alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/4, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button1.isShowSelectBackgroudColor = NO;
    button1.imageView.image = [UIImage imageNamed:@"待付款"];
    button1.titleLabel.text = @"待付款";
    [bgv addSubview:button1];
    [button1 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"已完成"] index:1];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    button2 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 15, SCREEN_WIDTH/4, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button2.isShowSelectBackgroudColor = NO;
    button2.imageView.image = [UIImage imageNamed:@"待发货"];
    button2.titleLabel.text = @"待发货";
    [bgv addSubview:button2];
    [button2 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"已完成"] index:2];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    
    button3 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*2, 15, SCREEN_WIDTH/4, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button3.isShowSelectBackgroudColor = NO;
    button3.imageView.image = [UIImage imageNamed:@"待收货"];
    button3.titleLabel.text = @"待收货";
    [bgv addSubview:button3];
    [button3 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"已完成"] index:3];
            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
    button4 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 15, SCREEN_WIDTH/4, 70)
                                              type:SQCustomButtonTopImageType
                                         imageSize:CGSizeMake(35, 35) midmargin:10];
    button4.isShowSelectBackgroudColor = NO;
    button4.imageView.image = [UIImage imageNamed:@"已完成"];
    button4.titleLabel.text = @"已完成";
    [bgv addSubview:button4];
    [button4 touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            TWScrollViewVC *scr = [[TWScrollViewVC alloc] initWithAddVCARY:@[[OneVC new],[TwoVC new],[ThreeVC new],[FourVC new],[FiveVC new]]TitleS:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"已完成"] index:4];
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
    
    
    
    
    
    
    
    UILabel *botomV = [[UILabel alloc]initWithFrame:CGRectMake(0, 140+kNavBarHAbove7, SCREEN_WIDTH, 60)];
    botomV.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    botomV.userInteractionEnabled = YES;
    [imgV addSubview:botomV];
    SQCustomButton *btn = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, 5, 100, 50)
                                                              type:SQCustomButtonRightImageType
                                                         imageSize:CGSizeMake(25, 25) midmargin:0];
    btn.isShowSelectBackgroudColor = NO;
    btn.imageView.image = [UIImage imageNamed:@"箭头-2"];
    btn.titleLabel.text = @"去购物抵扣";
    btn.titleLabel.textColor = [UIColor blackColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [botomV addSubview:btn];
    [botomV bringSubviewToFront:btn];
    LRWeakSelf(self);
    [btn touchAction:^(SQCustomButton * _Nonnull button) {
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            [weakSelf dengdaiupdate];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:login animated:YES completion:nil];
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
    
    
    
    userImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 20+kStatusBarHeight, 90, 90)];
    LRViewBorderRadius(userImg, 45, 0, [UIColor clearColor]);
    userImg.userInteractionEnabled = YES;
    [imgV addSubview:userImg];
    
    
    user1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 110+kStatusBarHeight, SCREEN_WIDTH-100, 30)];
    user1.textColor = [UIColor whiteColor];
    user1.textAlignment = NSTextAlignmentCenter;
    user1.numberOfLines = 0;
    [imgV addSubview:user1];
    
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    btns.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    [btns addTarget:self action:@selector(clicktap:) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:btns];
}





- (void)dengdaiupdate{
    MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.text =@"等待更新";
    [hud setMode:MBProgressHUDModeCustomView];
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
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
            [self dengdaiupdate];
//            CouponsViewController *scr = [[CouponsViewController alloc] initWithAddVCARY:@[[CouponsOneVC new],[CouponsTwoVC new],[CouponsThreeVC new]]TitleS:@[@"未使用",@"已使用",@"已过期"] index:0];
//            [self.navigationController pushViewController:scr animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }else if (indexPath.row == 2){
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            [self dengdaiupdate];
//            GetACouponViewController *about = [[GetACouponViewController alloc]init];
//            about.navigationItem.title = @"领券中心";
//            [self.navigationController pushViewController:about animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }else if (indexPath.row == 3){
        if ([Manager redingwenjianming:@"phone.text"]!= nil){
            [self dengdaiupdate];
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
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"051083599633"];
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
