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
    UIView *centerV;
    UIView *footerV;
    
    UILabel *cenLab1;
    UILabel *cenLab2;
    
    
    UIImageView *img1;
    UIImageView *img2;
    
    NSInteger index_j;
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
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                [weakSelf.lunboArray removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.lunboArray addObject:model];
                }
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
        weakSelf.cycleScrollView.localizationImageNamesGroup = array;
         weakSelf.cycleScrollView.titlesGroup = array1;
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}




- (void)getGuanggao{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"index/advert") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"object"]] == YES) {
                NSMutableArray *arr = [diction objectForKey:@"object"];
                
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
                        imgheight = wid/size.width*size.height;
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(heit, 200+he, wid, imgheight);
                        
                        btn.adjustsImageWhenHighlighted=NO;
                        
                        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                        
                        
                        LRViewBorderRadius(btn, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
                        [btn addTarget:self action:@selector(clickbt:) forControlEvents:UIControlEventTouchUpInside];
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
                //NSLog(@"----%f",he+imgheight+200);
                CGFloat gao = SCREEN_WIDTH/2*18/32;
                //NSLog(@"-------%lf",gao);
                self->img1.frame = CGRectMake(0, he+imgheight+200+10, SCREEN_WIDTH/2, gao);
                self->img2.frame = CGRectMake(SCREEN_WIDTH/2, he+imgheight+200+10, SCREEN_WIDTH/2, gao);
                self->centerV.frame = CGRectMake(0, he+imgheight+200+20+gao, SCREEN_WIDTH, 100);
                self->headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, he+imgheight+300+30+gao);
            }
        }
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        //NSLog(@"------%@",error);
    }];
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
    xppd.navigationItem.title = @"新手特权";
    [self.navigationController pushViewController:xppd animated:YES];
}

- (void)clickbtn2:(UITapGestureRecognizer *)tap{
    XSTP_ViewController *xstp = [[XSTP_ViewController alloc]init];
    xstp.navigationItem.title = @"新品频道";
    [self.navigationController pushViewController:xstp animated:YES];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = -44;
    }else{
        hei = -20;
    }
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, SCREEN_HEIGHT+hei) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"Table_4_Cell" bundle:nil] forCellReuseIdentifier:@"Table_4_Cell"];
    [self.view addSubview:self.tableview];
    
    headerV = [[UIView alloc]init];
    headerV.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableHeaderView = headerV;
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    [headerV addSubview:self.cycleScrollView];
    
    
    img1 = [[UIImageView alloc]init];
    LRViewBorderRadius(img1, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
    img1.image = [UIImage imageNamed:@"xstq.jpg"];
    img1.userInteractionEnabled = YES;
    img1.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbtn1:)];
    [img1 addGestureRecognizer:tap1];
    [self->headerV addSubview:img1];
    
    img2 = [[UIImageView alloc]init];
    LRViewBorderRadius(img2, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
    img2.image = [UIImage imageNamed:@"xppd.jpg"];
    img2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbtn2:)];
    [img2 addGestureRecognizer:tap2];
    [self->headerV addSubview:img2];
    
    
    
    centerV = [[UIView alloc]init];
    centerV.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:centerV];
    cenLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    cenLab1.textAlignment = NSTextAlignmentCenter;
    cenLab1.text = @"8.15中秋佳节";
    cenLab1.font = [UIFont systemFontOfSize:28];
    [centerV addSubview:cenLab1];
    cenLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 20)];
    cenLab2.textAlignment = NSTextAlignmentCenter;
    cenLab2.text = @"预定抢半价 椅子低价秒";
    cenLab2.font = [UIFont systemFontOfSize:16];
    cenLab2.textColor = [UIColor grayColor];
    [centerV addSubview:cenLab2];
    
    
    
    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 900)];
    self.tableview.tableFooterView = footerV;
    footerV.backgroundColor =RGBACOLOR(237, 236, 242, 1);
    UIView *centerFooterV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    centerFooterV.backgroundColor = [UIColor whiteColor];
    [footerV addSubview:centerFooterV];
    
    
    
    [self NavigationBa];
    
    
    [self initCollectionView3];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---------%ld",index);
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



#pragma mark - NavItem
-(void) SetNavBarHidden:(BOOL) isHidden
{
    self.navigationController.navigationBarHidden = isHidden;
}
-(UIView*)NavigationBa
{
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 68;
    }else{
        hei = 44;
    }
    view_bar =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar .frame=CGRectMake(0, 0, SCREEN_WIDTH, hei+20);
    }else{
        view_bar .frame=CGRectMake(0, 0, SCREEN_WIDTH, hei);
    }
    view_bar.backgroundColor=[UIColor clearColor];
    [self.view addSubview: view_bar];
    
    _customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH-120, hei)];
    _customSearchBar.delegate = self;
    for (UIView *subview in _customSearchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.alpha = 0.0f;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                NSLog(@"Keep textfiedld bkg color");
            }else{
                grandSonView.alpha = 0.0f;
            }
        }
    }
    
    
    _customSearchBar.placeholder = @"请输入商品名称";
    [view_bar addSubview:self.customSearchBar];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请输入想要搜索的商品";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:.8 alpha:.5];
    label.frame = CGRectMake(0, 0, 0, 45);
    label.backgroundColor = [UIColor whiteColor];
    _customSearchBar.inputAccessoryView = label;
    [self.tableview bringSubviewToFront:label];
    // 由于其子控件是懒加载模式, 所以找之前先将其显示
    [_customSearchBar setShowsCancelButton:NO animated:YES];
    
    UIImage *theImage = [UIImage imageNamed:@"dx"];
    //    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* meBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 20+(hei-30)/2+5, 30, 25)];
    LRViewBorderRadius(meBtn, 15, 0, [UIColor clearColor]);
    [meBtn setBackgroundImage:theImage forState:UIControlStateNormal];
    //    [meBtn setTintColor:[UIColor blackColor]];
    [meBtn addTarget:self action:@selector(onLeftNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:meBtn];
    
    UIImage *theImage1 = [UIImage imageNamed:@"btn_nav_message"];
    //    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20+(hei-30)/2+2, 25, 30)];
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
    }else if(self.tableview.contentOffset.y<250){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:self.tableview.contentOffset.y / 1000];
    }else
    {
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.9];
    }
}


- (void)onLeftNavBtnClick {
    NSLog(@"扫一扫");
}
- (void)onRightNavBtnClick {
    NSLog(@"消息");
}



















#pragma mark  设置CollectionView的的参数

- (void) initCollectionView3
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat itemWidth = self.view.frame.size.width / 2;
    flowLayout.itemSize = CGSizeMake(itemWidth , 320);
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置CollectionView的属性
    self.collectionView3 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 640) collectionViewLayout:flowLayout];
    self.collectionView3.backgroundColor = [UIColor orangeColor];
    self.collectionView3.delegate = self;
    self.collectionView3.dataSource = self;
    self.collectionView3.scrollEnabled = NO;
    [footerV addSubview:self.collectionView3];
    //注册Cell
    //[self.collectionView3 registerClass:[StoreOneCollectionViewCell class] forCellWithReuseIdentifier:@"cell3"];
    [self.collectionView3 registerNib:[UINib nibWithNibName:@"Collec_3_Cell" bundle:nil] forCellWithReuseIdentifier:@"cell3"];
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell3";
    Collec_3_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
    cell.img.image = [UIImage imageNamed:@"yizi.jpg"];
    cell.img.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}


//button2 = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 10, SCREEN_WIDTH/4, 80)
//                                          type:SQCustomButtonTopImageType
//                                     imageSize:CGSizeMake(40, 40) midmargin:10];
//button2.isShowSelectBackgroudColor = NO;
//button2.imageView.image = [UIImage imageNamed:@"002"];
//button2.titleLabel.text = @"电竞椅系列";
//[scrollV addSubview:button2];
//[button2 touchAction:^(SQCustomButton * _Nonnull button) {
//    XiLieViewController *xilie = [[XiLieViewController alloc]init];
//    xilie.navigationItem.title = @"电竞椅系列";
//    [self.navigationController pushViewController:xilie animated:YES];
//}];




























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
    
    [self getTopPic];
    [self getGuanggao];
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
