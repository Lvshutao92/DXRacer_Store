//
//  AddrViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/2.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AddrViewController.h"
#import "AddAddressViewController.h"
@interface AddrViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat hei;
    BOOL isno;
}
@property(nonatomic,strong)NSMutableArray *arr;
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation AddrViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self lodinfo];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    btn.backgroundColor = RGB_AB;
    [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAddAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
  
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];

}

- (void)click1:(UIButton *)sender{
    AddressCell *cell = (AddressCell *)[[sender superview] superview];
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    Model *model = [self.arr objectAtIndex:indexpath.row];
    NSString *isDef;
    if ([model.isDefault isEqualToString:@"Y"]) {
        //isDef = @"N";
    }else{
        isDef = @"Y";
        __weak typeof (self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"address/updateDefault?id=%@&isDefault=%@",model.id,isDef];
        [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"%@----%@",isDef,diction);
            if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]) {
                [weakSelf lodinfo];
            }
            //定位到cell
//            [weakSelf.tableview scrollToRowAtIndexPath:indexpath
//                                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } enError:^(NSError *error) {
            //NSLog(@"----%@",error);
        }];
    }
}
- (void)click2:(UIButton *)sender{
    AddressCell *cell = (AddressCell *)[[sender superview] superview];
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    Model *model = [self.arr objectAtIndex:indexpath.row];
    
    AddAddressViewController *edit = [[AddAddressViewController alloc]init];
    edit.navigationItem.title = @"编辑";
    
    edit.idstr = model.id;
    edit.string1 = model.person;
    edit.string2 = model.phone;
    edit.string3 = model.receiveProvince;
    edit.string4 = model.receiveCity;
    edit.string5 = model.receiveDistrict;
    edit.string6 = model.address;
    
    [self.navigationController pushViewController:edit animated:YES];
}
- (void)click3:(UIButton *)sender{
    AddressCell *cell = (AddressCell *)[[sender superview] superview];
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    Model *model = [self.arr objectAtIndex:indexpath.row];
    __weak typeof (self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"address/delete?id=%@",model.id];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]) {
            [weakSelf.arr removeObjectAtIndex:indexpath.row];
            [weakSelf.tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableview reloadData];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
       
        //NSLog(@"----%@",diction);
    } enError:^(NSError *error) {
        //NSLog(@"----%@",error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.order isEqualToString:@"order"]) {
        Model *model = [self.arr objectAtIndex:indexPath.row];
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",model.receiveProvince,model.receiveCity,model.receiveDistrict,model.address];
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = @{@"name":model.person,
                 @"phone":model.phone,
                 @"address":address,
                 @"id":model.id,
                 };
        NSNotification *notification =[NSNotification notificationWithName:@"chuanzhi" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"cell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.lin.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    Model *model = [self.arr objectAtIndex:indexPath.row];
    cell.lab1.text = [NSString stringWithFormat:@"%@  %@",model.person,model.phone];
    
    
    cell.lab2.text = [NSString stringWithFormat:@"%@%@%@%@",model.receiveProvince,model.receiveCity,model.receiveDistrict,model.address];
    cell.lab2.numberOfLines = 0;
    cell.lab2.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.lab2 sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)];
    cell.lab2height.constant = size.height;
    if (size.height <= 20) {
        hei = 20;
    }else{
        hei = size.height;
    }
    
    if ([model.isDefault isEqualToString:@"N"]) {
        cell.img1.image = [UIImage imageNamed:@"yuanhuan"];
    }else{
        UIImage *theImage = [UIImage imageNamed:@"seleyuanhuan"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.img1.image = theImage;
        [cell.img1 setTintColor:RGB_AB];
    }
    
    
    [cell.btn1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100+hei;
}
















- (void)lodinfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"加载中....", @"HUD loading title");
//    NSLog(@"%@      %@",[Manager redingwenjianming:@"token.text"],[Manager redingwenjianming:@"userid.text"]);
    __weak typeof (self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"address") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"%@",diction);
        NSMutableArray *array = (NSMutableArray *)diction;
        [weakSelf.arr removeAllObjects];
        if ([Manager judgeWhetherIsEmptyAnyObject:weakSelf.arr]==YES) {
            for (NSDictionary *dic in array) {
                Model *model = [Model mj_objectWithKeyValues:dic];
                [weakSelf.arr addObject:model];
            }
        }
        [weakSelf.tableview reloadData];
        [hud hideAnimated:YES];
    } enError:^(NSError *error) {
        [hud hideAnimated:YES];
        //NSLog(@"----%@",error);
    }];
}


- (void)clickAddAddress{
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    add.navigationItem.title = @"新增";
    [self.navigationController pushViewController:add animated:YES];
}



- (NSMutableArray *)arr{
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}



@end
