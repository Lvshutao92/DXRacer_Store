//
//  XPPD_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/21.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "XPPD_ViewController.h"
#import "MiaoSha_Cell.h"
#import "MiaoShaXiangqingViewController.h"
@interface XPPD_ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation XPPD_ViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    
    [Manager requestPOSTWithURLStr:KURLNSString(@"account") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //        NSLog(@"%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"401"]){
            [Manager logout];
        }
    } enError:^(NSError *error) {
    }];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[MiaoSha_Cell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    [self setUpReflash];
}


-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodList];
        [weakSelf.tableview.mj_header endRefreshing];
    }];
    [self.tableview.mj_header beginRefreshing];
}



- (void)lodList{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"promotion/crush") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [weakSelf.dataArray removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    
                    Model_A *model1 = [Model_A mj_objectWithKeyValues:model.productItem];
                    model.productItem_model = model1;
                    
                    Model_A *model2 = [Model_A mj_objectWithKeyValues:model.product];
                    model.product_model = model2;
                    
                    Model_A *model3 = [Model_A mj_objectWithKeyValues:model.crush];
                    model.crush_model = model3;
                    
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        [weakSelf.tableview reloadData];
        
        if (weakSelf.dataArray.count == 0) {
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            lab.text = @"暂无秒杀活动";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor lightGrayColor];
            [weakSelf.view addSubview:lab];
            
        }
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}







- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"cell";
    MiaoSha_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[MiaoSha_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Model *model = [self.dataArray objectAtIndex:indexPath.row];

    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:NSString(model.productItem_model.listImg)]];
    
    cell.lab1.text = model.product_model.modelName;
    
    
    NSDate *startDate = [NSDate date];
    
    if ([model.switchs isEqualToString:@"0"]) {
        cell.lab3.text = @"距开始";
        cell.lab3.textColor = [UIColor whiteColor];
        cell.lab3.backgroundColor = RGBACOLOR(0, 174, 10, 1);
        [cell downSecondHandle:model.crush_model.startTime starDate:startDate];
    }else{
        cell.lab3.text = @"距结束";
        cell.lab3.textColor = [UIColor whiteColor];
        cell.lab3.backgroundColor = [UIColor redColor];
        [cell downSecondHandle:model.crush_model.endTime starDate:startDate];
    }
    
    
    cell.lab4.text = [Manager jinegeshi:model.crush_model.salePrice];
    
    NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:[Manager jinegeshi:model.productItem_model.salePrice] attributes:attribtDic2];
    cell.lab5.attributedText = attribtStr2;
    
    
    
    CGFloat tottal = [model.crush_model.totalQuantity integerValue];
    CGFloat yimai  = [model.crush_model.usedQuantity integerValue];
    
    
    //NSLog(@"%ld========%lf========%ld",yimai,yimai/tottal,tottal);
    
    
    cell.myProgressView.progress = yimai/tottal;
    
    
    if(yimai/tottal == 1){
        cell.lab2.text =@"已售完";
    }else{
        cell.lab2.text = [NSString stringWithFormat:@"已售%.2f%%",yimai/tottal*100];
    }
    

    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Model *model = [self.dataArray objectAtIndex:indexPath.row];
    MiaoShaXiangqingViewController *details = [[MiaoShaXiangqingViewController alloc]init];
    details.idStr = model.skuId;
    details.idString = model.productItem_model.productId;
    
    
//    [self presentViewController:details animated:YES completion:nil];
    
    [self.navigationController pushViewController:details animated:YES];
}











































- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


//    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"下划线" attributes:attribtDic];
//
//    label1.attributedText = attribtStr;
//    [self.view addSubview:label1];

//    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
//    NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//
//    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:@"中划线" attributes:attribtDic2];
//    label2.attributedText = attribtStr2;
//
//    [self.view addSubview:label2];
@end
