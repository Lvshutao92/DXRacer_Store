//
//  ShoopingCartViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ShoopingCartViewController.h"
#import "CreateOrderViewController.h"
#define  TAG_BACKGROUNDVIEW 100

@interface ShoopingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CAGradientLayer *_gradientLayer;
    UILabel *txlab;//没有选择商品点击结算提示label
    UIView *bgView;//底部视图
    //    UIButton *btn;//编辑按钮
    UITableView *myTableView;
    //全选按钮
    UIButton *selectAll;
    //展示数据源数组
    NSMutableArray *dataArray;
    //是否全选
    BOOL isSelect;
    //已选的商品集合
    NSMutableArray *selectGoods;
    UILabel *priceLabel;
    
    BOOL isedit;
    UIButton *editbtn;
    
    NSMutableArray *deleateArr;
    
    NSInteger totolNum;
    UIButton *btn;
}
@end

@implementation ShoopingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    deleateArr = [NSMutableArray arrayWithCapacity:1];
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 50, 30) ;
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    self.navigationItem.rightBarButtonItem = bar;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 150) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 100;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = RGBCOLOR(245, 246, 248);
    
}
- (void)ciclk{
    LoginViewController *login = [[LoginViewController alloc]init];
    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:login animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    //每次进入购物车的时候把选择的置空
    [deleateArr removeAllObjects];
    [selectGoods removeAllObjects];
    isSelect = NO;
    selectAll.selected = NO;
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    
    [self.view addSubview:myTableView];
    [self setupBottomView];
    [self lodXL:@""];
    
    if ([Manager redingwenjianming:@"token.text"] == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT/2-22.5, 120, 45);
        [btn setTitle:@"去登录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ciclk) forControlEvents:UIControlEventTouchUpInside];
        LRViewBorderRadius(btn, 8, 1, [UIColor colorWithWhite:.7 alpha:.5]);
        [btn setTitleColor:[UIColor colorWithWhite:.7 alpha:.5] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [self.view bringSubviewToFront:btn];
    }
}
- (void)clickEdit {
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    //    [self networkRequest];
    selectAll.selected = NO;
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    [myTableView reloadData];
    
    if (isedit == NO) {
        [deleateArr removeAllObjects];
        [editbtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    isedit = !isedit;;
    [self setupBottomView];
}


//请求列表
- (void)lodXL:(NSString *)st{
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/list") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            NSMutableArray *array = [diction objectForKey:@"object"];
            [self->dataArray removeAllObjects];
            for (NSDictionary *dic in array) {
                Model *model = [Model mj_objectWithKeyValues:dic];
                [self->dataArray addObject:model];
            }
            
            self->dataArray = (NSMutableArray *)[[self->dataArray reverseObjectEnumerator] allObjects];
            [self->myTableView reloadData];
        }
    } enError:^(NSError *error) {
         NSLog(@"%@",error);
    }];
    

}











//提交订单
-(void)goPayBtnClick
{
   
    if (selectGoods.count > 0) {
        CreateOrderViewController *createOrder = [[CreateOrderViewController alloc]init];
        createOrder.navigationItem.title = @"确认订单";
        createOrder.dataArray = selectGoods;
        [self.navigationController pushViewController:createOrder animated:YES];
    }

}





#pragma mark - 设置底部视图

-(void)setupBottomView
{
    
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 83;
    }else{
        hei = 49;
    }
    //底部视图的 背景
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - hei, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = kUIColorFromRGB(0xD5D5D5);
    [bgView addSubview:line];
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn1"] forState:UIControlStateNormal];
    
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn1"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [selectAll setImage:theImage forState:UIControlStateSelected];
    [selectAll setTintColor:[UIColor redColor]];
    
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectAll];
#pragma mark -- 底部视图添加约束
    //全选按钮
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->bgView).offset(10);
        make.top.equalTo(@10);
        make.bottom.equalTo(self->bgView).offset(-10);
        make.width.equalTo(@60);
        
    }];
    
    if (isedit == NO) {
        //合计
        UILabel *label = [[UILabel alloc]init];
        label.text = @"合计: ";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:label];
        
        //价格
        priceLabel = [[UILabel alloc]init];
        priceLabel.text = @"￥0.00";
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        priceLabel.textColor = [UIColor redColor];
        [bgView addSubview:priceLabel];
        
        //结算按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        
        [btn setTitle:@"去结算" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        //结算按钮
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->bgView);
            make.right.equalTo(self->bgView);
            make.bottom.equalTo(self->bgView);
            make.width.equalTo(@100);
            
        }];
        if ([[Manager redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            label.frame = CGRectMake(0, 0, 0, 0);
            priceLabel.frame = CGRectMake(0, 0, 0, 0);
        }else {
            //价格显示
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self->btn.mas_left).offset(-10);
                make.top.equalTo(self->bgView).offset(10);
                make.bottom.equalTo(self->bgView).offset(-10);
                make.left.equalTo(label.mas_right);
            }];
            
            //合计
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self->bgView).offset(10);
                make.bottom.equalTo(self->bgView).offset(-10);
                make.right.equalTo(self->priceLabel.mas_left);
                make.width.equalTo(@60);
            }];
        }
        
    }else {
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"删除" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(clickgodeleate) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn1];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->bgView);
            make.right.equalTo(self->bgView);
            make.bottom.equalTo(self->bgView);
            make.width.equalTo(@150);
            
        }];
    }
    
}

- (void)clickgodeleate {
    
    [dataArray removeObjectsInArray:deleateArr];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (Model *model in deleateArr) {
        [arr addObject:model.shoppingcartid];
    }
//    [self lodDelegateSelectsGoods:arr];
    
    [myTableView reloadData];
    if (dataArray.count == 0) {
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
        isedit = NO;
        [self setupBottomView];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",dataArray.count];
}

//删除购物车商品
- (void)lodDelegateSelectsGoods:(NSString *)ids{
    
    
    NSLog(@"ids--------%@",ids);
    NSDictionary *dic = @{@"productItemId":ids,
                          @"quantity":@"0"};
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
 
}




#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    GoodsDetailsViewController *goods = [[GoodsDetailsViewController alloc]init];
    //    [self.navigationController pushViewController:goods animated:YES];
    //    self.tabBarController.tabBar.hidden = YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoopingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoopingcell"];
    if (!cell) {
        cell = [[ShoopingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoopingcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isSelected = isSelect;
    
    
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        cell.isSelected = YES;
    }else{
    }
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        if (isSelec) {
            [self->selectGoods addObject:[self->dataArray objectAtIndex:indexPath.row]];
            [self->deleateArr addObject:[self->dataArray objectAtIndex:indexPath.row]];
        }else{
            [self->selectGoods removeObject:[self->dataArray objectAtIndex:indexPath.row]];
            [self->deleateArr removeObject:[self->dataArray objectAtIndex:indexPath.row]];
        }
        
        
        if (self->selectGoods.count == self->dataArray.count) {
            self->selectAll.selected = YES;
        }else{
            self->selectAll.selected = NO;
        }
        
        [self countPrice];
    };
    
    
    
    __block ShoopingCell *weakCell = cell;
    cell.numAddBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        Model *model = [self->dataArray objectAtIndex:indexPath.row];
        weakCell.numberLabel.text = numStr;
        model.number = count;
        
        [self lodChangeGoodsNumber:[NSString stringWithFormat:@"%ld",model.number] ids:model.id inesp:indexPath];
        
        [self->dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        if ([self->selectGoods containsObject:model]) {
            
            [self->selectGoods removeObject:model];
            [self->selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    cell.numCutBlock =^(){
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count--;
        if(count <= 0){
            return ;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        Model *model = [self->dataArray objectAtIndex:indexPath.row];
        weakCell.numberLabel.text = numStr;
        model.number = count;
        
        [self lodChangeGoodsNumber:[NSString stringWithFormat:@"%ld",model.number] ids:model.id inesp:indexPath];
        
        [self->dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self->selectGoods containsObject:model]) {
            [self->selectGoods removeObject:model];
            [self->selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    
  
    
    
    
    
    [cell reloadDataWith:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}
/**
 *  计算已选中商品金额
 */
-(void)countPrice
{
    double totlePrice = 0.0;
    NSLog(@"%@",selectGoods);
    for (Model *model in selectGoods) {
        double price = [model.salePrice doubleValue];
        
        totlePrice += price*model.number;
    }
    priceLabel.text = [Manager jinegeshi:[NSString stringWithFormat:@"%f",totlePrice]];
}
-(void)selectAllBtnClick:(UIButton*)button
{
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        for (Model *model in dataArray) {
            [selectGoods addObject:model];
        }
        [deleateArr addObjectsFromArray:selectGoods];
    }
    else
    {
        [selectGoods removeAllObjects];
        [deleateArr removeAllObjects];
    }
    [myTableView reloadData];
    [self countPrice];
}




//改变商品数量
- (void)lodChangeGoodsNumber:(NSString *)amount ids:(NSString *)ids inesp:(NSIndexPath *)indexpath{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"productItemId":ids,
                          @"quantity":amount};
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            [weakSelf lodXL:@"str"];
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
}
























- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *xiugai = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            Model *model = [self->dataArray objectAtIndex:indexPath.row];
            
            
            NSDictionary *dic = @{@"productItemId":model.id,
                                  @"quantity":@"0"};
            [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                //NSLog(@"******%@",diction);
                NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
                if ([code isEqualToString:@"200"]){
                    [self->dataArray removeObjectAtIndex:indexPath.row];
                    //删除
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //延迟0.5s刷新一下,否则数据会乱
                    //            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
                    self->myTableView.editing = NO;
                }else{
                    
                }
            } enError:^(NSError *error) {
                
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self->myTableView.editing = NO;
        }];
        
        
        [self countPrice];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
    xiugai.backgroundColor = [UIColor redColor];
    return @[xiugai];
}


-(void)goToMainmenuView
{
    self.tabBarController.selectedIndex = 0;
}
@end
