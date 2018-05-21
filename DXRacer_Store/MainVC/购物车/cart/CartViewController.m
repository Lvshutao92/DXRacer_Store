//
//  CartViewController.m
//  CartDemo
//
//  Created by Artron_LQQ on 16/2/18.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "CreateOrderViewController.h"
#define  TAG_BACKGROUNDVIEW 100



@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
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
}


@end

@implementation CartViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
//    [self networkRequest];
    selectAll.selected = NO;
    
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    
    [self creatData];
    
    [myTableView reloadData];
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice
{
    double totlePrice = 0.0;
    
    for (CartModel *model in selectGoods) {
        
        double price = [model.salePrice doubleValue];
        
        totlePrice += price*[model.quantity integerValue];
    }
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",totlePrice];
}

/**
 *  @author LQQ, 16-02-18 11:02:32
 *
 *  创建测试数据源
 */
-(void)creatData
{
    __weak typeof(self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/list") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            NSMutableArray *array = [diction objectForKey:@"object"];
            [self->dataArray removeAllObjects];
            [self->dataArray removeAllObjects];
            for (NSDictionary *dic in array) {
                CartModel *model = [CartModel mj_objectWithKeyValues:dic];
                [self->dataArray addObject:model];
            }
            
            self->dataArray = (NSMutableArray *)[[self->dataArray reverseObjectEnumerator] allObjects];
        }
        if (self->myTableView && self->dataArray.count > 0) {
            [self->myTableView reloadData];
        }
        else
        {
            [weakSelf setupMainView];
        }
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(245, 246, 248);
    
    
    editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 50, 30) ;
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    [self setupMainView];
//    [self creatData];
    self.title = @"购物车";
}
- (void)clickEdit {
    //每次进入购物车的时候把选择的置空
    //[selectGoods removeAllObjects];
    //isSelect = NO;
    //    [self networkRequest];
   // selectAll.selected = NO;
    //priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    //[myTableView reloadData];
    
    if (isedit == NO) {
        [selectGoods removeAllObjects];
        [editbtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    isedit = !isedit;;
    [self setupBottomView];
}





-(void)selectAllBtnClick:(UIButton*)button
{
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        for (CartModel *model in dataArray) {
            [selectGoods addObject:model];
        }
    }
    else
    {
        [selectGoods removeAllObjects];
    }
    
    [myTableView reloadData];
    [self countPrice];
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
//    NSLog(@"%@",selectGoods);
}

#pragma mark - 设置底部视图
-(void)setupBottomView
{
    //底部视图的 背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = kUIColorFromRGB(0xD5D5D5);
    [bgView addSubview:line];
    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectAll];
    //全选按钮
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(bgView).offset(10);
        //        make.top.equalTo(@10);
        //        make.bottom.equalTo(bgView).offset(-10);
        //        make.width.equalTo(@20);
        
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    if (isedit == NO){
        //合计
        UILabel *label = [[UILabel alloc]init];
        label.text = @"合计: ";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:label];
        //价格
        priceLabel = [[UILabel alloc]init];
        priceLabel.text = @"￥0.00";
        priceLabel.font = [UIFont boldSystemFontOfSize:16];
        priceLabel.textColor = [UIColor redColor];
        [bgView addSubview:priceLabel];
        //结算按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"去结算" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        //结算按钮
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.right.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(@100);
            
        }];
        
        //价格显示
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btn.mas_left).offset(-10);
            make.top.equalTo(bgView).offset(10);
            make.bottom.equalTo(bgView).offset(-10);
            make.left.equalTo(label.mas_right);
        }];
        
        //合计
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).offset(10);
            make.bottom.equalTo(bgView).offset(-10);
            make.right.equalTo(priceLabel.mas_left);
            make.width.equalTo(@60);
        }];
        
    }else{
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"删除" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(clickgodeleate) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn1];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.right.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(@150);
        }];
    }
    
    
    
    
    
    
    

    
    
    
}

- (void)clickgodeleate{
    
}






#pragma mark - 设置主视图
-(void)setupMainView
{
    //当购物车为空时,显示默认视图
    if (dataArray.count == 0) {
        [self cartEmptyShow];
    }
    //当购物车不为空时,tableView展示
    else
    {
        UIView *vi = [self.view viewWithTag:TAG_BACKGROUNDVIEW];
        [vi removeFromSuperview];
        
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.rowHeight = 100;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = RGBCOLOR(245, 246, 248);
        
        [self.view addSubview:myTableView];
        
        [self setupBottomView];
    }
    
}
//购物车为空时的默认视图
-(void)cartEmptyShow
{
    
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    backgroundView.tag = TAG_BACKGROUNDVIEW;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_default_bg"]];
    img.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车好空,买点什么呗!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = kUIColorFromRGB(0x706F6F);
    [backgroundView addSubview:warnLabel];
    
    //默认视图按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 + 40);
    btn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_background_red"] forState:UIControlStateNormal];
    [btn setTitle:@"去定制" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToMainmenuView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
}
-(void)goToMainmenuView
{
    NSLog(@"去首页");
}
#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[CartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isSelected = isSelect;
    
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        cell.isSelected = YES;
    }
    
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        
        if (isSelec) {
            [self->selectGoods addObject:[self->dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [self->selectGoods removeObject:[self->dataArray objectAtIndex:indexPath.row]];
        }
        
        if (self->selectGoods.count == self->dataArray.count) {
            self->selectAll.selected = YES;
        }
        else
        {
            self->selectAll.selected = NO;
        }
        
        [self countPrice];
    };
    __block CartTableViewCell *weakCell = cell;
    cell.numAddBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        CartModel *model = [self->dataArray objectAtIndex:indexPath.row];
        
        weakCell.numberLabel.text = numStr;
        model.quantity = [NSString stringWithFormat:@"%ld",count];
        
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
        
        CartModel *model = [self->dataArray objectAtIndex:indexPath.row];
        
        weakCell.numberLabel.text = numStr;
        
        model.quantity = [NSString stringWithFormat:@"%ld",count];
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

-(void)reloadTable
{
    [myTableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            __weak typeof(self) weakSelf = self;
            CartModel *model = [self->dataArray objectAtIndex:indexPath.row];
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
                    [weakSelf performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
                    self->myTableView.editing = NO;
                    
                    
                    if (self->myTableView && self->dataArray.count > 0) {
                    }
                    else
                    {
                        [weakSelf setupMainView];
                    }
                }
            } enError:^(NSError *error) {
            }];
            
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end
