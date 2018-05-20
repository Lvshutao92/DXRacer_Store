//
//  ClassifyViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/4/28.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ClassifyViewController.h"
#import "SearchController.h"
#import "ProductDetailsViewController.h"


#import "ProductXiangqingViewController.h"


@interface ClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate>
{
    NSInteger page;
    NSInteger number;
    NSString *seacherStr;
    
    UILabel *lab1;
    UILabel *lab2;
    
    UIButton *picBtn;
}


@property(nonatomic,strong)DXSearchBar *searchBar;


@property(nonatomic,strong)UICollectionView *goosdCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
//当前排列显示状态
@property (nonatomic, assign) BOOL isPermutation;
@end

@implementation ClassifyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}


//懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout =[[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 260);
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
    self.goosdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, SCREEN_HEIGHT-30) collectionViewLayout:self.flowLayout];
    self.goosdCollectionView.backgroundColor = [UIColor whiteColor];
    self.goosdCollectionView.delegate = self;
    self.goosdCollectionView.dataSource = self;
    self.goosdCollectionView.scrollEnabled = YES;
    [self.view addSubview:self.goosdCollectionView];
    
    [self.goosdCollectionView registerNib:[UINib nibWithNibName:@"FL_1_Cell" bundle:nil] forCellWithReuseIdentifier:@"FL_1_Cell"];
    [self.goosdCollectionView registerNib:[UINib nibWithNibName:@"FL_2_Cell" bundle:nil] forCellWithReuseIdentifier:@"FL_2_Cell"];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    //1.创建热门搜索
    NSArray *hotSeaches = @[@"电竞椅", @"电竞桌", @"鼠标垫", @"鼠标", @"显示屏", @"升降器", @"支架",@"键盘"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"商品名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchController *search = [[SearchController alloc] init];
        search.str = searchText;
        [searchViewController.navigationController pushViewController:search animated:YES];
    }];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag; // 热门搜索风格为默认
    //    PYHotSearchStyleNormalTag,      // 普通标签(不带边框)
    //    PYHotSearchStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    //    PYHotSearchStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    //    PYHotSearchStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    //    PYHotSearchStyleRankTag,        // 带有排名标签
    //    PYHotSearchStyleRectangleTag,   // 矩形标签,此时标签背景色为clearColor
    //    PYHotSearchStyleDefault = PYHotSearchStyleNormalTag // 默认为普通标签
    searchViewController.searchHistoryStyle = 4; // 搜索历史风格根据选择
    //    PYSearchHistoryStyleCell,           // UITableViewCell 风格
    //    PYSearchHistoryStyleNormalTag,      // PYHotSearchStyleNormalTag 标签风格
    //    PYSearchHistoryStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    //    PYSearchHistoryStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    //    PYSearchHistoryStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    //    PYSearchHistoryStyleDefault = PYSearchHistoryStyleCell // 默认为 PYSearchHistoryStyleCell
    
    searchViewController.delegate = self;
    MainNavigationViewController *nav = [[MainNavigationViewController alloc] initWithRootViewController:searchViewController];
    
    [self presentViewController:nav  animated:NO completion:nil];
    return NO;
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
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-120, 35)];//allocate titleView
    [titleView setBackgroundColor:[UIColor whiteColor]];
    self.searchBar = [[DXSearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入商品名称";
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 35);
    self.searchBar.backgroundColor = [UIColor whiteColor];
    [[[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1] setTintColor:[UIColor clearColor]];
    LRViewBorderRadius(self.searchBar, 15, 1, [UIColor colorWithWhite:.8 alpha:.15]);
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, hei, 50, 44)];
    picBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, 25, 25)];
    [picBtn setImage:[UIImage imageNamed:@"分类1"] forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(clickqiehuan) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:picBtn];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:vv];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-170, 60, 60)];
    LRViewBorderRadius(lab, 30, 0, [UIColor clearColor]);
    lab.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [self.view addSubview:lab];
    [self.view bringSubviewToFront:lab];
    
    lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 29.5)];
    lab1.text = @"1";
    lab1.textAlignment = NSTextAlignmentCenter;
    [lab addSubview:lab1];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 29.5, 60, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    [lab addSubview:line];
    
    
    lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30.5, 60, 30)];
    lab2.textAlignment = NSTextAlignmentCenter;
    [lab addSubview:lab2];
    
    
    seacherStr = @"";
    [self setUpReflash];
 }

- (void)clickqiehuan{
    if (self.isPermutation == YES) {
        [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
        self.isPermutation = NO;
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 130);
        self.flowLayout.minimumLineSpacing      = 0;
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.goosdCollectionView.collectionViewLayout = self.flowLayout;
    }else{
        [picBtn setImage:[UIImage imageNamed:@"分类1"] forState:UIControlStateNormal];
        self.isPermutation = YES;
        //行与行之间的间距最小距离
        self.flowLayout.minimumLineSpacing      = 0;
        //列与列之间的间距最小距离
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 260);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.goosdCollectionView.collectionViewLayout = self.flowLayout;
    }
    [self.goosdCollectionView reloadData];
}






//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.goosdCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loddeList];
    }];
    [self.goosdCollectionView.mj_header beginRefreshing];
    self.goosdCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == self->number) {
            [self.goosdCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loddeSLList];
        }
    }];
}
- (void)loddeList{
    [self.goosdCollectionView.mj_footer endRefreshing];
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/search?keyword=%@&startRow=0&pageSize=10",seacherStr];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",diction);
        [weakSelf.dataArray removeAllObjects];
        self->number = [[diction objectForKey:@"total"] integerValue];
        
        NSInteger yeshu;
        if (self->number % 10 != 0) {
            yeshu = self->number/10+1;
        }else{
            yeshu = self->number/10;
        }
        if (yeshu == 0) {
            yeshu = 1;
        }
        self->lab2.text = [NSString stringWithFormat:@"%ld",yeshu];
        
        if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"itemsList"]] == YES) {
            NSMutableArray *arr = [diction objectForKey:@"itemsList"];
            for (NSDictionary *dicc in arr) {
                Model *model = [Model mj_objectWithKeyValues:dicc];
                [weakSelf.dataArray addObject:model];
            }
        }
        self->page = 1;
        [weakSelf.goosdCollectionView reloadData];
        [weakSelf.goosdCollectionView.mj_header endRefreshing];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}
- (void)loddeSLList{
    [self.goosdCollectionView.mj_header endRefreshing];
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/search?keyword=%@&startRow=%ld&pageSize=10",seacherStr,page];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"itemsList"]] == YES) {
            NSMutableArray *arr = [diction objectForKey:@"itemsList"];
            for (NSDictionary *dicc in arr) {
                Model *model = [Model mj_objectWithKeyValues:dicc];
                [weakSelf.dataArray addObject:model];
            }
        }
        self->page++;
        [weakSelf.goosdCollectionView reloadData];
        [weakSelf.goosdCollectionView.mj_footer endRefreshing];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}







- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *firstIndexPath = [[self.goosdCollectionView indexPathsForVisibleItems] firstObject];
    // 赋值给记录当前坐标的变量
    NSInteger yeshu;
    if (firstIndexPath.row % 10 != 0) {
        yeshu = firstIndexPath.row/10+1;
    }else{
        yeshu = firstIndexPath.row/10;
    }
    
    if (yeshu == 0) {
        yeshu = 1;
    }
    
    self->lab1.text = [NSString stringWithFormat:@"%ld",yeshu];
    
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
    if (self.isPermutation){
        FL_1_Cell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FL_1_Cell" forIndexPath:indexPath];
        Model *model = [self.dataArray objectAtIndex:indexPath.row];
        LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        
        cell.lab1.text       = model.model_name;
        cell.lab2.text     = model.sale_price;
        cell.lab3.text = model.series_name;
        return cell;
        
    }else{
        
        FL_2_Cell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FL_2_Cell" forIndexPath:indexPath];
        Model *model = [self.dataArray objectAtIndex:indexPath.row];
        LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        
        cell.lab1.text       = model.model_name;
        cell.lab3.text     = model.sale_price;
        cell.lab2.text = model.series_name;
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
