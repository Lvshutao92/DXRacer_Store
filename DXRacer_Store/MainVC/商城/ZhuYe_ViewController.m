//
//  ZhuYe_ViewController.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/6/26.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ZhuYe_ViewController.h"
#import "SearchController.h"
#import "XSTP_ViewController.h"
#import "XPPD_ViewController.h"

#import "ProductXiangqingViewController.h"
#import "Home_fenleilist_ViewController.h"
@interface ZhuYe_ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate,PYSearchViewControllerDelegate>
{
    UIView *view_bar;
    UIView *headerV;
    UIView *footerV;
}
@property(nonatomic,strong)UISearchBar *customSearchBar;


@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation ZhuYe_ViewController


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
    [self.tableview registerClass:[FLAnimatideImgCell class] forCellReuseIdentifier:@"FLAnimatideImgCell"];
    [self.view addSubview:self.tableview];
    
    headerV = [[UIView alloc]init];
    headerV.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
    self.tableview.tableHeaderView = headerV;
    
    [self NavigationBa];
}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 221;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"FLAnimatideImgCell";
    FLAnimatideImgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[FLAnimatideImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.flanimatedImgView.hidden = YES;
    [cell.imgview sd_setImageWithURL:[NSURL URLWithString:@"http://image-shop.dxracer.com.cn/poster/a15335b2bcf5470b85a42f2c8deb0f8220180515112933449.jpg"]];
    
    
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





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self SetNavBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
@end
