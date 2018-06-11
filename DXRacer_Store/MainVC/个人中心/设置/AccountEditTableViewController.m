//
//  AccountEditTableViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/4.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AccountEditTableViewController.h"
#import "EditPersonInfomationViewController.h"
#import "AddrViewController.h"
#import "UpdatePasswordViewController.h"
#import "ABABViewController.h"
@interface AccountEditTableViewController ()
{
    UIImageView *userImg;
    UILabel *username;
    UILabel *phone;
}
@property(nonatomic,strong)NSMutableArray *arr;

@end

@implementation AccountEditTableViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    
    if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"nikname.text"]]!=YES) {
        username.text = @"*****";
    }else{
        username.text = [Manager redingwenjianming:@"nikname.text"];
    }
    phone.text = [Manager redingwenjianming:@"phone.text"];
    [userImg sd_setImageWithURL:[NSURL URLWithString:[Manager redingwenjianming:@"img.text"]]placeholderImage:[UIImage imageNamed:@"tx.jpg"]];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (NSMutableArray *)arr{
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    
    self.arr = [@[@"地址管理",@"实名认证",@"修改密码",@"清除缓存"]mutableCopy];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //footer
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    self.tableView.tableFooterView = footer;
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    btns.frame = CGRectMake(0, 15, SCREEN_WIDTH, 50);
    btns.backgroundColor = [UIColor whiteColor];
    [btns setTitle:@"退出登录" forState:UIControlStateNormal];
    [btns setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btns addTarget:self action:@selector(cilckFooterImg) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btns];
    //header
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    header.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = header;
    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 10)];
    lin.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [header addSubview:lin];
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25, 30, 20, 20)];
    jiantou.image = [UIImage imageNamed:@"箭头3"];
    [header addSubview:jiantou];
    
    userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 70, 70)];
    LRViewBorderRadius(userImg, 35, 0, [UIColor clearColor]);
    [header addSubview:userImg];
    
    username = [[UILabel alloc]initWithFrame:CGRectMake(85, 20, SCREEN_WIDTH-120, 20)];
    username.font = [UIFont systemFontOfSize:20];
    [header addSubview:username];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(85, 45, SCREEN_WIDTH-120, 20)];
    phone.font = [UIFont systemFontOfSize:16];
    [header addSubview:phone];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    [btn addTarget:self action:@selector(cilckHeaderImg) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];
  
}
- (void)cilckHeaderImg{
    EditPersonInfomationViewController *addr = [[EditPersonInfomationViewController alloc]init];
    addr.navigationItem.title = @"个人信息";
    [self.navigationController pushViewController:addr animated:YES];
}
- (void)cilckFooterImg{
    [Manager logout];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"cell";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lab.font = [UIFont systemFontOfSize:16];
    cell.lab.text = self.arr[indexPath.row];
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"sz%ld",indexPath.row+1]];
    cell.img.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.lab.text isEqualToString:@"地址管理"]) {
        AddrViewController *addr = [[AddrViewController alloc]init];
        addr.navigationItem.title = @"收货地址";
        [self.navigationController pushViewController:addr animated:YES];
    }else if([cell.lab.text isEqualToString:@"清除缓存"]){
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self TextButtonAction];
        }];
        [[SDImageCache sharedImageCache] clearMemory];//可不写
    }else if([cell.lab.text isEqualToString:@"修改密码"]){
        UpdatePasswordViewController *update = [[UpdatePasswordViewController alloc]init];
        update.navigationItem.title = @"修改密码";
        [self.navigationController pushViewController:update animated:YES];
    }else if([cell.lab.text isEqualToString:@"实名认证"]){
//        ABABViewController *update = [[ABABViewController alloc]init];
//        update.navigationItem.title = @"实名认证";
//        [self.navigationController pushViewController:update animated:YES];
    }
    
}

// 只显示文字
- (void)TextButtonAction{
    MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.text =@"清除成功";
    UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dui"]];
    [hud setCustomView:imageview];
    [hud setMode:MBProgressHUDModeCustomView];
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}















































@end
