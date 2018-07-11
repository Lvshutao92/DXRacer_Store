//
//  XSTP_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/21.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "XSTP_ViewController.h"
#import "ProductXiangqingViewController.h"
@interface XSTP_ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
{
    NSInteger page;
    NSInteger number;
    
    
    UIButton *picBtn;
}




@property(nonatomic,strong)UICollectionView *goosdCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
//当前排列显示状态
@property (nonatomic, assign) BOOL isPermutation;

@end

@implementation XSTP_ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout =[[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 130);
        //        _flowLayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing      = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    }
    return _flowLayout;
}
-(void)registrationCell{
    
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 88;
    }else{
        hei = 64;
    }
    self.goosdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, SCREEN_HEIGHT-hei) collectionViewLayout:self.flowLayout];
    self.goosdCollectionView.backgroundColor = [UIColor whiteColor];
    self.goosdCollectionView.delegate = self;
    self.goosdCollectionView.dataSource = self;
    self.goosdCollectionView.scrollEnabled = YES;
    [self.view addSubview:self.goosdCollectionView];
    
    [self.goosdCollectionView registerNib:[UINib nibWithNibName:@"FL_1_Cell" bundle:nil] forCellWithReuseIdentifier:@"FL_1_Cell"];
    [self.goosdCollectionView registerNib:[UINib nibWithNibName:@"FL_2_Cell" bundle:nil] forCellWithReuseIdentifier:@"FL_2_Cell"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
    
}

#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    self.isPermutation = YES;
    
    [self registrationCell];
    
    
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 44;
    }else{
        hei = 20;
    }
    
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, hei, 50, 44)];
    picBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, 25, 25)];
    [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(clickqiehuan) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:picBtn];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:vv];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    [self setUpReflash];
}


-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.goosdCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTopPic];
        [weakSelf.goosdCollectionView.mj_header endRefreshing];
    }];
    [self.goosdCollectionView.mj_header beginRefreshing];
}

- (void)clickqiehuan{
    if (self.isPermutation == YES) {
        [picBtn setImage:[UIImage imageNamed:@"分类1"] forState:UIControlStateNormal];
        self.isPermutation = NO;
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 280);
        self.flowLayout.minimumLineSpacing      = 0;
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.goosdCollectionView.collectionViewLayout = self.flowLayout;
    }else{
        [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
        self.isPermutation = YES;
        //行与行之间的间距最小距离
        self.flowLayout.minimumLineSpacing      = 0;
        //列与列之间的间距最小距离
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 130);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.goosdCollectionView.collectionViewLayout = self.flowLayout;
    }
    [self.goosdCollectionView reloadData];
}



- (void)getTopPic{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"index/product/new") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [weakSelf.dataArray removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        [weakSelf.goosdCollectionView reloadData];
        
        if (weakSelf.dataArray.count == 0) {
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            lab.text = @"暂无新产品";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor lightGrayColor];
            [weakSelf.view addSubview:lab];
            
        }
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}






#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isPermutation){
        FL_1_Cell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FL_1_Cell" forIndexPath:indexPath];
        Model *model = [self.dataArray objectAtIndex:indexPath.row];
        LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        });
        cell.lab4.backgroundColor = RGB_AB;
        cell.lab2.textColor = RGB_AB;
        
        cell.lab1.text       = model.model_name;
        cell.lab2.text     = [Manager jinegeshi:model.sale_price];
        cell.lab3.text = model.series_name;
        if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
            cell.lab4.hidden = NO;
            if ([Manager widthForString:model.promotionTitle fontSize:14 andHeight:20] > (SCREEN_WIDTH/2)) {
                cell.lab4width.constant = SCREEN_WIDTH/2;
            }else{
                cell.lab4width.constant = [Manager widthForString:model.promotionTitle fontSize:14 andHeight:20]+20;
            }
            
        }else{
            cell.lab4.hidden = YES;
            cell.lab4width.constant = 0;
        }
        cell.lab4.text = model.promotionTitle;
        return cell;
        
    }else{
        
        FL_2_Cell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FL_2_Cell" forIndexPath:indexPath];
        Model *model = [self.dataArray objectAtIndex:indexPath.row];
        LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        });

        cell.lab1.text       = model.model_name;
        cell.lab3.text     = [Manager jinegeshi:model.sale_price];
        cell.lab2.text = model.series_name;
        
        cell.lab4.backgroundColor =RGB_AB;
        cell.lab3.textColor = RGB_AB;
        
        if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
            cell.lab4.hidden = NO;
            cell.lab2height.constant = 20;
            cell.lab4height.constant = 20;
//            LRViewBorderRadius(cell.lab4, 10, 0, [UIColor clearColor]);
            
            //NSLog(@"-==-=-=-=-=-=-%f",[Manager widthForString:model.promotionTitle fontSize:15 andHeight:20]);
            if ([Manager widthForString:model.promotionTitle fontSize:14 andHeight:20] > (SCREEN_WIDTH-150)) {
                cell.lab4width.constant = SCREEN_WIDTH-150;
            }else{
                cell.lab4width.constant = [Manager widthForString:model.promotionTitle fontSize:14 andHeight:20]+20;
            }
        }else{
            cell.lab4.hidden = YES;
            cell.lab2height.constant = 40;
            cell.lab4height.constant = 0;
            cell.lab4width.constant = 0;
        }
        cell.lab4.text = model.promotionTitle;
        return cell;
        
    }
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"---------------------");
    Model *model = [self.dataArray objectAtIndex:indexPath.row];
    ProductXiangqingViewController *details = [[ProductXiangqingViewController alloc]init];
    details.idStr = model.id;
    [self.navigationController pushViewController:details animated:YES];
}




- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


@end
