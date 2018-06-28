//
//  HomePageViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/15.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "HomePageViewController.h"
#import "SearchController.h"
#import "XSTP_ViewController.h"
#import "XPPD_ViewController.h"
#import "ProductXiangqingViewController.h"
#import "Home_fenleilist_ViewController.h"
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,PYSearchViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *view_bar;
    UIView *headerV;
//    UIView *centerV;
    UIView *footerV;
    
//    UILabel *cenLab1;
//    UILabel *cenLab2;
    UILabel *fhlab;
    
    UIImageView *img1;
    UIImageView *img2;
    
    NSInteger index_j;
    
    CGFloat collectionVHeight;
    
}
@property(nonatomic,strong)UISearchBar *customSearchBar;

@property(nonatomic,strong)NSMutableArray *lunboArray;


@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;



@property(nonatomic,strong)UICollectionView *collectionView3;

@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;



@end

@implementation HomePageViewController

- (void)getTopPic{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"index/poster") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [weakSelf.lunboArray removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.lunboArray addObject:model];
                }
                [Manager writewenjianming:@"SY_IMG_huancun.text" content:@"you"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                    NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_IMG_Casher"];
                    [weakSelf.lunboArray writeToFile:filewebCaches atomically:YES];
                });
            }
        }
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
        [array removeAllObjects];
        [array1 removeAllObjects];
        for (Model *mo in weakSelf.lunboArray) {
            [array addObject:NSString(mo.phoneUrl)];
            [array1 addObject:mo.title1];
        }
        
        if (array.count > 0) {
            weakSelf.cycleScrollView.localizationImageNamesGroup = array;
        }
        
        
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}




- (void)getGuanggao{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"index/advert") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"111111******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [Manager writewenjianming:@"SY_GuangGao_huancun.text" content:@"you"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                    NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_GuangGao_Casher"];
                    [arr writeToFile:filewebCaches atomically:YES];
                });
                
                
                
               
                CGFloat he = 0.0;
                CGFloat imgheight= 0.0;

                for (int j = 0; j<arr.count; j++) {
                    self->index_j = j;
                    NSMutableArray *arr1 = [arr[j] objectForKey:@"list"];
                    [weakSelf.dataArray1 removeAllObjects];
                    for (NSDictionary *dic in arr1) {
                        Model *model = [Model mj_objectWithKeyValues:dic];
                        [weakSelf.dataArray1 addObject:model];
                    }
                    CGFloat heit = 0.0;
                    int b = 0;
                    for (int i = 0; i<weakSelf.dataArray1.count; i++) {
                        Model *model = [weakSelf.dataArray1 objectAtIndex:i];
                        
                        if (b == 0) {
                            he =  he + imgheight;
                        }
                        
                       
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:NSString(model.imgUrl)]];
                        UIImage *image = [UIImage imageWithData:data];
                        CGSize size = image.size;
                        CGFloat wid = [model.proportion floatValue]/100*SCREEN_WIDTH;
                        
                        if (size.width>0) {
                            imgheight = wid/size.width*size.height;
                        }
                        
                        
                        
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        
                        btn.frame = CGRectMake(heit, 200+he, wid, imgheight);
                        
                        btn.adjustsImageWhenHighlighted=NO;
                        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                        
                        
                        LRViewBorderRadius(btn, 0, .5, [UIColor colorWithWhite:.9 alpha:.3]);
                        [btn addTarget:weakSelf action:@selector(clickbt:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setTitle:model.linkUrl forState:UIControlStateNormal];
                        
                        
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:NSString(model.imgUrl)]];
                        SDImageCache* cache = [SDImageCache sharedImageCache];
                        //此方法会先从memory中取。
                        [btn setBackgroundImage:[cache imageFromDiskCacheForKey:key] forState:UIControlStateNormal];
                        
                        [btn setBackgroundImage:[Manager imageFromURLString:NSString(model.imgUrl)] forState:UIControlStateNormal];
                        
                        btn.tag = i;
                        [self->headerV addSubview:btn];
                        b++;
                        heit = heit + wid;
                    }
                }
                CGFloat gao = SCREEN_WIDTH/2*18/32;
                self->img1.frame = CGRectMake(0, he+imgheight+200+5, SCREEN_WIDTH/2, gao);
                self->img2.frame = CGRectMake(SCREEN_WIDTH/2, he+imgheight+200+5, SCREEN_WIDTH/2, gao);
                self->headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, he+imgheight+200+5+gao);
            }
        }else{
            CGFloat gao = SCREEN_WIDTH/2*18/32;
            self->img1.frame = CGRectMake(0, 200+5, SCREEN_WIDTH/2, gao);
            self->img2.frame = CGRectMake(SCREEN_WIDTH/2, 200, SCREEN_WIDTH/2, gao);
            self->headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200+gao);
        }
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        //NSLog(@"------%@",error);
    }];
}




- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
//    Model *model = [_lunboArray objectAtIndex:index];
//    Home_fenleilist_ViewController *details = [[Home_fenleilist_ViewController alloc]init];
//
//    details.idstr = model.id;
//
//    details.navigationItem.title = @"分类";
//
//    [self.navigationController pushViewController:details animated:YES];
}













- (void)clickbt:(UIButton *)sender{
//    NSLog(@"---------%@",sender.titleLabel.text);
    Home_fenleilist_ViewController *details = [[Home_fenleilist_ViewController alloc]init];
    details.idstr = sender.titleLabel.text;
    details.navigationItem.title = @"分类";
    [self.navigationController pushViewController:details animated:YES];
}

- (void)clickbtn1:(UITapGestureRecognizer *)tap{
    XPPD_ViewController *xppd = [[XPPD_ViewController alloc]init];
    xppd.navigationItem.title = @"秒杀专场";
    [self.navigationController pushViewController:xppd animated:YES];
}

- (void)clickbtn2:(UITapGestureRecognizer *)tap{
    XSTP_ViewController *xstp = [[XSTP_ViewController alloc]init];
    xstp.navigationItem.title = @"新品频道";
    [self.navigationController pushViewController:xstp animated:YES];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = -44;
    }else{
        hei = -20;
    }
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, SCREEN_HEIGHT+hei+10) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"Table_4_Cell" bundle:nil] forCellReuseIdentifier:@"Table_4_Cell"];
    [self.view addSubview:self.tableview];
    
    
    
    
    
    
    headerV = [[UIView alloc]init];
    headerV.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
    self.tableview.tableHeaderView = headerV;
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [headerV addSubview:self.cycleScrollView];
    
    
    img1 = [[UIImageView alloc]init];
    LRViewBorderRadius(img1, 0, .5, [UIColor colorWithWhite:.9 alpha:.3]);
    img1.image = [UIImage imageNamed:@"miao"];
    img1.userInteractionEnabled = YES;
    img1.backgroundColor = [UIColor whiteColor];
    img1.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbtn1:)];
    [img1 addGestureRecognizer:tap1];
    [self->headerV addSubview:img1];
    
    img2 = [[UIImageView alloc]init];
    LRViewBorderRadius(img2, 0, .5, [UIColor colorWithWhite:.9 alpha:.3]);
    
    img2.image = [UIImage imageNamed:@"xppd"];
    
    img2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbtn2:)];
    [img2 addGestureRecognizer:tap2];
    [self->headerV addSubview:img2];
    
    
    footerV = [[UIView alloc]init];
    self.tableview.tableFooterView = footerV;
    footerV.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
   
    
    [self NavigationBa];
    
    
    
//    LRWeakSelf(self);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        if ([[Manager redingwenjianming:@"SY_IMG_huancun.text"] isEqualToString:@"you"]) {
//            [weakSelf getDataFromlocal1];
//        }
//        if ([[Manager redingwenjianming:@"SY_GuangGao_huancun.text"] isEqualToString:@"you"]) {
//            [weakSelf getDataFromlocal2];
//        }
//        if ([[Manager redingwenjianming:@"SY_bottom_huancun.text"] isEqualToString:@"you"]) {
//            [weakSelf getDataFromlocal3];
//        }
//    });
    
    LRWeakSelf(self);
    if ([[Manager redingwenjianming:@"SY_IMG_huancun.text"] isEqualToString:@"you"]) {
        [weakSelf getDataFromlocal1];
    }
    [self setUpReflash];
}






//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            [weakSelf getTopPic];
            [weakSelf getGuanggao];
            [weakSelf getBottomInfo];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableview reloadData];
                [weakSelf.collectionView3 reloadData];
            });
        });
    }];
    [self.tableview.mj_header beginRefreshing];
}





- (void)getDataFromlocal1 {
    LRWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_IMG_Casher"];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        if (fileDic == nil) {
            [weakSelf getTopPic];
        }else {
            [weakSelf havecasher1:fileDic];
        }
        LRStrongSelf(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
             [strongSelf.tableview reloadData];
        });
    });
}
- (void)havecasher1:(NSMutableArray *)arr{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    [array removeAllObjects];
    [array1 removeAllObjects];
    for (Model *mo in self.lunboArray) {
        [array addObject:NSString(mo.phoneUrl)];
        [array1 addObject:mo.title1];
    }
    if (array.count > 0) {
        self.cycleScrollView.localizationImageNamesGroup = array;
    }
}

- (void)getDataFromlocal2 {
    LRWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_GuangGao_Casher"];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        if (fileDic == nil) {
            [weakSelf getGuanggao];
        }else {
            [weakSelf havecasher2:fileDic];
        }
        LRStrongSelf(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableview reloadData];
        });
    });
}
- (void)havecasher2:(NSMutableArray *)arr{
    CGFloat he = 0.0;
    CGFloat imgheight= 0.0;
    for (int j = 0; j<arr.count; j++) {
        self->index_j = j;
        NSMutableArray *arr1 = [arr[j] objectForKey:@"list"];
        [self.dataArray1 removeAllObjects];
        for (NSDictionary *dic in arr1) {
            Model *model = [Model mj_objectWithKeyValues:dic];
            [self.dataArray1 addObject:model];
        }
        CGFloat heit = 0.0;
        int b = 0;
        for (int i = 0; i<self.dataArray1.count; i++) {
            Model *model = [self.dataArray1 objectAtIndex:i];
            if (b == 0) {
                he =  he + imgheight;
            }
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:NSString(model.imgUrl)]];
            UIImage *image = [UIImage imageWithData:data];
            CGSize size = image.size;
            CGFloat wid = [model.proportion floatValue]/100*SCREEN_WIDTH;
            if (size.width>0) {
                imgheight = wid/size.width*size.height;
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(heit, 200+he, wid, imgheight);
            btn.adjustsImageWhenHighlighted=NO;
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            LRViewBorderRadius(btn, 0, .5, [UIColor colorWithWhite:.9 alpha:.3]);
            [btn addTarget:self action:@selector(clickbt:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:model.linkUrl forState:UIControlStateNormal];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:NSString(model.imgUrl)]];
            SDImageCache* cache = [SDImageCache sharedImageCache];
            [btn setBackgroundImage:[cache imageFromDiskCacheForKey:key] forState:UIControlStateNormal];
            [btn setBackgroundImage:[Manager imageFromURLString:NSString(model.imgUrl)] forState:UIControlStateNormal];
            btn.tag = i;
            [headerV addSubview:btn];
            b++;
            heit = heit + wid;
        }
    }
    CGFloat gao = SCREEN_WIDTH/2*18/32;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->img1.frame = CGRectMake(0, he+imgheight+200+5, SCREEN_WIDTH/2, gao);
        self->img2.frame = CGRectMake(SCREEN_WIDTH/2, he+imgheight+200+5, SCREEN_WIDTH/2, gao);
        self->headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, he+imgheight+200+5+gao);
    });
    
}



- (void)getDataFromlocal3 {
    LRWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_bottom_Casher"];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        if (fileDic == nil) {
            [weakSelf getTopPic];
        }else {
            [weakSelf havecasher3:fileDic];
        }
        LRStrongSelf(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableview reloadData];
            [strongSelf.collectionView3 reloadData];
        });
    });
}
- (void)havecasher3:(NSMutableArray *)arr{
   
    [self.dataArray3 removeAllObjects];
    for (NSDictionary *dicc in arr) {
        Model *model = [Model mj_objectWithKeyValues:dicc];
        [self.dataArray3 addObject:model];
    }
    
    
    NSInteger hangshu;
    if (self.dataArray3.count%2 == 1) {
        hangshu = self.dataArray3.count/2 + 1;
    }else{
        hangshu = self.dataArray3.count/2;
    }
    if (self.dataArray3.count == 0) {
        hangshu = 0;
    }
    [self initCollectionView3:hangshu];
    [self.tableview reloadData];
    [self.collectionView3 reloadData];
}






//-(void)setUpReflash
//{
//    LRWeakSelf(self)
//    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingBlock:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 处理耗时操作的代码块...
//            [weakSelf getTopPic];
//            [weakSelf getGuanggao];
//            [weakSelf getBottomInfo];
//            //通知主线程刷新
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableview reloadData];
//            });
//        });
//    }];
//    [header beginRefreshing];
//    self.tableview.mj_header = header;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"Table_4_Cell";
    Table_4_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[Table_4_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.line.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.img.image = [UIImage imageNamed:@""];
    cell.img.contentMode = UIViewContentModeScaleAspectFill;
    cell.img.clipsToBounds = YES;
    return cell;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self getHotSearch];
    return NO;
}

- (void)getHotSearch{
    //1.创建热门搜索
    NSArray *hotSeaches = @[@"电竞椅", @"电竞桌", @"电竞服",  @"赛车椅", @"办公桌",@"搁脚凳", @"游戏支架", @"工作服", @"游戏周边",@"办公椅"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"商品名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchController *search = [[SearchController alloc] init];
        search.str = searchText;
        [searchViewController.navigationController pushViewController:search animated:YES];
    }];
    searchViewController.hotSearchStyle = 4; // 热门搜索风格为默认【1，7】
    searchViewController.searchHistoryStyle = 2; // 搜索历史风格根据选择【1，6】
    searchViewController.delegate = self;
    MainNavigationViewController *nav = [[MainNavigationViewController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}








#pragma mark - NavItem
-(void) SetNavBarHidden:(BOOL) isHidden
{
    self.navigationController.navigationBarHidden = isHidden;
}
-(UIView*)NavigationBa
{
    view_bar =[[UIView alloc]init];
    CGFloat hei;
    CGFloat hh;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 88;
        hh = 44;
    }else{
        hei = 64;
        hh = 20;
    }
   
    view_bar .frame=CGRectMake(0, 0, SCREEN_WIDTH, hei);
    
    
    view_bar.backgroundColor=[UIColor clearColor];
    [self.view addSubview: view_bar];
    
    _customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, hh+7, SCREEN_WIDTH-80, 30)];
    _customSearchBar.delegate = self;
    for (UIView *subview in _customSearchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                //NSLog(@"Keep textfiedld bkg color");
            }else{
                grandSonView.alpha = 0.0f;
            }
        }
    }
    
    UITextField *searchField = [_customSearchBar valueForKey:@"searchField"];
    if (searchField) {
        LRViewBorderRadius(searchField, 19, 0, [UIColor clearColor]);
    }
    LRViewBorderRadius(_customSearchBar, 22, 0, [UIColor clearColor]);
    _customSearchBar.placeholder = @"请输入商品名称";
    [view_bar addSubview:self.customSearchBar];

    
    UIImage *theImage = [UIImage imageNamed:@"dx"];
    //theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* meBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, hh+7, 30, 30)];
    LRViewBorderRadius(meBtn, 15, 0, [UIColor clearColor]);
    [meBtn setBackgroundImage:theImage forState:UIControlStateNormal];
    //[meBtn setTintColor:[UIColor blackColor]];
    [meBtn addTarget:self action:@selector(onLeftNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:meBtn];
    
    UIImage *theImage1 = [UIImage imageNamed:@"客服"];
    //    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, hh+7, 30, 30)];
    [readerBtn setBackgroundImage:theImage1 forState:UIControlStateNormal];
    [readerBtn addTarget:self action:@selector(onRightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [readerBtn setTintColor:[UIColor blackColor]];
    [view_bar addSubview:readerBtn];
    
    return view_bar;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 44;
    }else{
        hei = 20;
    }
    if(self.tableview.contentOffset.y<-hei) {
        [view_bar setHidden:YES];
    }else if(self.tableview.contentOffset.y<=0){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.0001];
    }else if(self.tableview.contentOffset.y<10){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    }else if(self.tableview.contentOffset.y<20){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
    }else if(self.tableview.contentOffset.y<30){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    }else if(self.tableview.contentOffset.y<40){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    }else if(self.tableview.contentOffset.y<50){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    }else if(self.tableview.contentOffset.y<60){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    }else if(self.tableview.contentOffset.y<70){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    }else if(self.tableview.contentOffset.y<80){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    }else if(self.tableview.contentOffset.y<90){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.9];
    }else{
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
}


- (void)onLeftNavBtnClick {
    //NSLog(@"扫一扫");
}
- (void)onRightNavBtnClick {
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"309718069"];
    NSURL *url = [NSURL URLWithString:qqstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    
}



















#pragma mark  设置CollectionView的的参数

- (void) initCollectionView3:(NSInteger )hangshu
{
    
    footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10+hangshu * 255);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat itemWidth = self.view.frame.size.width / 2;
    flowLayout.itemSize = CGSizeMake(itemWidth , 255);
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置CollectionView的属性
    self.collectionView3 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 255*hangshu) collectionViewLayout:flowLayout];
    self.collectionView3.backgroundColor = [UIColor whiteColor];
    self.collectionView3.delegate = self;
    self.collectionView3.dataSource = self;
    self.collectionView3.scrollEnabled = NO;
    [footerV addSubview:self.collectionView3];
    //注册Cell
    [self.collectionView3 registerNib:[UINib nibWithNibName:@"Collec_3_Cell" bundle:nil] forCellWithReuseIdentifier:@"cell3"];
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray3.count;
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell3";
    Collec_3_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
    cell.img.contentMode = UIViewContentModeScaleAspectFit;
    Model *model = [self.dataArray3 objectAtIndex:indexPath.row];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]];
    
    if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
        cell.lab1.hidden = NO;
        if ([Manager widthForString:model.promotionTitle fontSize:14 andHeight:20] > (SCREEN_WIDTH/2)) {
            cell.lab1width.constant = SCREEN_WIDTH/2;
        }else{
            cell.lab1width.constant = [Manager widthForString:model.promotionTitle fontSize:14 andHeight:20]+20;
        }
    }else{
        cell.lab1.hidden = YES;
        cell.lab1width.constant = 0;
    }
    
    cell.lab1.text = model.promotionTitle;
    cell.lab2.text = model.model_name;
    cell.lab4.text = model.model_no;
    cell.lab3.text = [Manager jinegeshi:model.sale_price];
    
    
    cell.lab1.backgroundColor = RGBACOLOR(49, 184, 243, 1);
    cell.lab3.textColor = RGBACOLOR(49, 184, 243, 1);
    return cell;
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Model *model = [self.dataArray3 objectAtIndex:indexPath.row];
    ProductXiangqingViewController *details = [[ProductXiangqingViewController alloc]init];
    details.idStr = model.id;
    [self.navigationController pushViewController:details animated:YES];
}


- (void)getBottomInfo{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"index/index/product") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",[diction objectForKey:@"object"]);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
           
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [weakSelf.dataArray3 removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.dataArray3 addObject:model];
                }
            }
            
            [Manager writewenjianming:@"SY_bottom_huancun.text" content:@"you"];
            LRStrongSelf(weakSelf);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:@"SY_bottom_Casher"];
                [strongSelf.dataArray3 writeToFile:filewebCaches atomically:YES];
            });
        }
        NSInteger hangshu;
        if (weakSelf.dataArray3.count%2 == 1) {
            hangshu = weakSelf.dataArray3.count/2 + 1;
        }else{
            hangshu = weakSelf.dataArray3.count/2;
        }
        if (weakSelf.dataArray3.count == 0) {
            hangshu = 0;
        }
        [weakSelf initCollectionView3:hangshu];
        
        [weakSelf.tableview reloadData];
        [weakSelf.collectionView3 reloadData];
    } enError:^(NSError *error) {
//        NSLog(@"------%@",error);
    }];
}




- (NSMutableArray *)dataArray3{
    if (_dataArray3 == nil) {
        self.dataArray3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray3;
}
- (NSMutableArray *)dataArray1{
    if (_dataArray1 == nil) {
        self.dataArray1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray1;
}
- (NSMutableArray *)dataArray2{
    if (_dataArray2 == nil) {
        self.dataArray2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray2;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self SetNavBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    
//    [self getTopPic];
//    [self getGuanggao];
//    [self getBottomInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self SetNavBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (NSMutableArray *)lunboArray{
    if (_lunboArray == nil) {
        self.lunboArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _lunboArray;
}
@end
