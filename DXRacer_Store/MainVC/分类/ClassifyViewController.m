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


@interface ClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSInteger page;
    NSInteger number;
    NSString *seacherStr;
    
    UILabel *lab1;
    UILabel *lab2;
    
    UIButton *picBtn;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    
    UITextField *text1;
    UITextField *text2;
    
    
    UIView *view_bar;
    UISearchBar *_customSearchBar;
}
@property (nonatomic, strong) UIScrollView *upView;
@property (nonatomic, strong) UIWindow *window;
@property(nonatomic,strong)NSMutableArray *array1;
@property(nonatomic,strong)NSMutableArray *array2;
@property(nonatomic,strong)NSMutableArray *array3;
@property(nonatomic,strong)NSMutableArray *array4;
@property(nonatomic,strong)NSMutableArray *btn1arr;
@property(nonatomic,strong)NSMutableArray *btn2arr;
@property(nonatomic,strong)NSMutableArray *btn3arr;
@property(nonatomic,strong)NSMutableArray *btn4arr;


@property(nonatomic,strong)DXSearchBar *searchBar;


@property(nonatomic,strong)UICollectionView *goosdCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
//当前排列显示状态
@property (nonatomic, assign) BOOL isPermutation;
@end

@implementation ClassifyViewController







//注册3DTouch
/*
 因为只有在6s及其以上的设备才支持3D Touch,我们可以通过UITraitCollection这个类的UITraitEnvironment协议属性来判断设备是否支持3D Touch。
 UITraitCollection是UIViewController所遵守的其中一个协议，不仅包含了UI界面环境特征，而且包含了3D Touch的特征描述
 */
//-(void)register3DTouch:(UITableViewCell *)cell{
//    if ([self respondsToSelector:@selector(traitCollection)]) {
//        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
//            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
//            }
//        }
//    }
//}







- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.tabBarController.tabBar.hidden = NO;
    [self SetNavBarHidden:YES];
    for (UIButton *btn in _btn1arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn2arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn3arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn4arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self SetNavBarHidden:NO];
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    NSLog(@"搜索");
    //1.创建热门搜索
    NSArray *hotSeaches = @[@"电竞椅", @"电竞桌", @"鼠标垫", @"鼠标", @"显示屏", @"升降器", @"支架",@"键盘"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"商品名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchController *search = [[SearchController alloc] init];
        search.str = searchText;
        [searchViewController.navigationController pushViewController:search animated:YES];
    }];
    
    searchViewController.hotSearchStyle = 4; // 热门搜索风格为默认
    //    PYHotSearchStyleNormalTag,      // 普通标签(不带边框)
    //    PYHotSearchStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    //    PYHotSearchStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    //    PYHotSearchStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    //    PYHotSearchStyleRankTag,        // 带有排名标签
    //    PYHotSearchStyleRectangleTag,   // 矩形标签,此时标签背景色为clearColor
    //    PYHotSearchStyleDefault = PYHotSearchStyleNormalTag // 默认为普通标签
    searchViewController.searchHistoryStyle = 2; // 搜索历史风格根据选择
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
    
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    [self NavigationBa];
    
    LRWeakSelf(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf pinpai];
        [weakSelf xilie];
        [weakSelf leixing];
        [weakSelf fenlei];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.goosdCollectionView reloadData];
        });
    });
    
    
    
    [self initCollectionView];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.window.backgroundColor = [UIColor colorWithWhite:.3 alpha:.5];
    self.window.windowLevel = UIWindowLevelNormal;
    self.window.hidden = NO;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self.window addGestureRecognizer:tap];
    [self.window makeKeyAndVisible];
    
}



















- (void)pinpai{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"product/brand") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSMutableArray *arr = (NSMutableArray *)diction;
        [weakSelf.array1 removeAllObjects];
        for (NSDictionary *dicc in arr) {
            Model *model = [Model mj_objectWithKeyValues:dicc];
            [weakSelf.array1 addObject:model];
        }
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}
- (void)xilie{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"product/series") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSMutableArray *arr = (NSMutableArray *)diction;
        [weakSelf.array4 removeAllObjects];
        for (NSDictionary *dicc in arr) {
            Model *model = [Model mj_objectWithKeyValues:dicc];
            [weakSelf.array4 addObject:model];
        }
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}
- (void)leixing{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"product/type") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSMutableArray *arr = (NSMutableArray *)diction;
        [weakSelf.array3 removeAllObjects];
        for (NSDictionary *dicc in arr) {
            Model *model = [Model mj_objectWithKeyValues:dicc];
            [weakSelf.array3 addObject:model];
        }
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}
- (void)fenlei{
    __weak typeof(self) weakSelf = self;
    [Manager requestGETWithURLStr:KURLNSString(@"product/catalog") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSMutableArray *arr = (NSMutableArray *)diction;
        [weakSelf.array2 removeAllObjects];
        for (NSDictionary *dicc in arr) {
            Model *model = [Model mj_objectWithKeyValues:dicc];
            [weakSelf.array2 addObject:model];
        }
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}


#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    self.isPermutation = YES;
    
    [self registrationCell];
    
    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 40)];//allocate titleView
//    [titleView setBackgroundColor:[UIColor whiteColor]];
//    self.searchBar = [[DXSearchBar alloc] init];
//    self.searchBar.delegate = self;
//    self.searchBar.placeholder = @"请输入商品名称";
//    self.searchBar.frame = CGRectMake(70, 2.5, SCREEN_WIDTH-140, 35);
//    self.searchBar.backgroundColor = [UIColor whiteColor];
//    [[[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1] setTintColor:[UIColor clearColor]];
//    LRViewBorderRadius(titleView, 10, 1, [UIColor colorWithWhite:.99 alpha:2]);
//    [titleView addSubview:self.searchBar];
//    self.navigationItem.titleView = titleView;
//
//    UIButton *bbb = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
//    [bbb setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
//    [bbb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [bbb addTarget:self action:@selector(clickshaixuan) forControlEvents:UIControlEventTouchUpInside];
//    [titleView addSubview:bbb];
//
//    picBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 7, 30, 30)];
//    [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
//    [picBtn addTarget:self action:@selector(clickqiehuan) forControlEvents:UIControlEventTouchUpInside];
//    [titleView addSubview:picBtn];

    
    
    seacherStr = @"";
    
    if ([[Manager redingwenjianming:@"huancun.text"] isEqualToString:@"you"]) {
        [self getDataFromlocal];
    }
    [self setUpReflash];
 }







- (UIStatusBarStyle)preferredStatusBarStyle {
    // 返回你所需要的状态栏样式
    return UIStatusBarStyleLightContent;
}
#pragma mark - NavItem
-(void) SetNavBarHidden:(BOOL) isHidden
{
    self.navigationController.navigationBarHidden = isHidden;
}
-(UIView*)NavigationBa
{
    view_bar =[[UIView alloc]init];
    view_bar .frame=CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHAbove7);
    //    view_bar.backgroundColor=[UIColor clearColor];
    [self.view addSubview: view_bar];
    
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view_bar.bounds;
    //    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGB_A CGColor],(id)[RGB_B CGColor], nil];
    [view_bar.layer insertSublayer:gradient atIndex:0];
    //    [self.navigationController.navigationBar.layer insertSublayer:gradient above:0];
    
    
    _customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, kStatusBarHeight+7, SCREEN_WIDTH-80, 30)];
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
    [view_bar addSubview:_customSearchBar];
    
    
    UIImage *theImage = [UIImage imageNamed:@"筛选1"];
    //theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* meBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kStatusBarHeight+7, 30, 30)];
    LRViewBorderRadius(meBtn, 15, 0, [UIColor clearColor]);
    [meBtn setImage:theImage forState:UIControlStateNormal];
    //[meBtn setTintColor:[UIColor blackColor]];
    [meBtn addTarget:self action:@selector(clickshaixuan) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:meBtn];
    
    UIImage *theImage1 = [UIImage imageNamed:@"分类2"];
    //    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    picBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, kStatusBarHeight+7, 30, 30)];
    [picBtn setImage:theImage1 forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(clickqiehuan) forControlEvents:UIControlEventTouchUpInside];
    //    [readerBtn setTintColor:[UIColor blackColor]];
    [view_bar addSubview:picBtn];
    
    return view_bar;
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_upView])
    {
        return NO;
    }
    return YES;
}

- (void)handleClick1:(UIButton *)sender{
    Model *model = [self.array1 objectAtIndex:sender.tag - 100];
    str1 = model.id;
    for (UIButton *btn in _btn1arr) {
        if (btn.tag == sender.tag) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick2:(UIButton *)sender{
    Model *model = [self.array4 objectAtIndex:sender.tag - 100];
    str2 = model.id;
    for (UIButton *btn in _btn2arr) {
        if (btn.tag == sender.tag) {
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick3:(UIButton *)sender{
    Model *model = [self.array2 objectAtIndex:sender.tag - 100];
    str3 = model.id;
    for (UIButton *btn in _btn3arr) {
        if (btn.tag == sender.tag) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick4:(UIButton *)sender{
    Model *model = [self.array3 objectAtIndex:sender.tag - 100];
    str4 = model.id;
    for (UIButton *btn in _btn4arr) {
        if (btn.tag == sender.tag) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)chongzhi{
    for (UIButton *btn in _btn1arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn2arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn3arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn4arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
}
- (void)sure{
    [UIView animateWithDuration:.3 animations:^{
        self.window.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    [self setUpReflash];
}










- (void)clickshaixuan{
    if ( self.upView != nil) {
        self.upView = nil;
    }
    
    
    self.upView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT-50)];
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.upView];
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    
    [UIView animateWithDuration:.3 animations:^{
        self.window.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT-50, (SCREEN_WIDTH-100)/2, 50)];
//    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"重置" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100+(SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-50, (SCREEN_WIDTH-100)/2, 50)];
//    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:btn2];
    
    
    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
    _gradientLayer.bounds = btn1.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = btn1.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)RGBACOLOR(255, 127, 80, 1.0).CGColor,
                             (id)RGBACOLOR(255, 69, 0, 1.0).CGColor, nil ,nil];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint   = CGPointMake(1.0, 1.0);
    [btn1.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    CAGradientLayer *_gradientLayer2 = [CAGradientLayer layer];
    _gradientLayer2.bounds = btn2.bounds;
    _gradientLayer2.borderWidth = 0;
    _gradientLayer2.frame = btn2.bounds;
    _gradientLayer2.colors = [NSArray arrayWithObjects:
                             (id)RGBACOLOR(220, 20, 60, 1.0).CGColor,
                             (id)RGBACOLOR(255, 0, 0, 1.0).CGColor, nil ,nil];
    _gradientLayer2.startPoint = CGPointMake(0, 0);
    _gradientLayer2.endPoint   = CGPointMake(1.0, 1.0);
    [btn2.layer insertSublayer:_gradientLayer2 atIndex:0];
    
    
    
    
    [self.btn1arr removeAllObjects];
    [self.btn2arr removeAllObjects];
    [self.btn3arr removeAllObjects];
    [self.btn4arr removeAllObjects];
    
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, kStatusBarHeight, 80, 30)];
    label5.text = @"价格区间";
    [self.upView addSubview:label5];
    text1 = [[UITextField alloc]initWithFrame:CGRectMake(10, kStatusBarHeight+40, 80, 35)];
    text1.delegate = self;
    text1.text = @"";
    text1.borderStyle = UITextBorderStyleRoundedRect;
    [_upView addSubview:text1];
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(90, kStatusBarHeight+40, 40, 35)];
    lin.text = @"-";
    lin.textAlignment = NSTextAlignmentCenter;
    [self.upView addSubview:lin];
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(130, kStatusBarHeight+40, 80, 35)];
    text2.delegate = self;
    text2.text = @"";
    text2.borderStyle = UITextBorderStyleRoundedRect;
    [_upView addSubview:text2];
    text1.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
    text2.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
    lin.textColor = [UIColor lightGrayColor];
    
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, kStatusBarHeight+85, 80, 30)];
    label1.text = @"品牌";
    [self.upView addSubview:label1];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 125+kStatusBarHeight;//用来控制button距离父视图的高
    for (int i = 0; i < self.array1.count; i++) {
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.tag = 100 + i;
        
//        LRViewBorderRadius(button1, 5, 1, [UIColor blackColor]);
        button1.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
        button1.layer.masksToBounds = YES;
        button1.layer.cornerRadius = 5.0;
        
        
        [button1 addTarget:self action:@selector(handleClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.btn1arr addObject:button1];
        
        
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        Model *model = [self.array1 objectAtIndex:i];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
        CGSize size = CGSizeMake(MAXFLOAT, 25);
        CGFloat length = [model.brandName boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
        //为button赋值
        [button1 setTitle:model.brandName forState:UIControlStateNormal];
        //设置button的frame
        button1.frame = CGRectMake(10 + w, h, length + 20 , 30);
        //当button的位置超出屏幕边缘时换行 只是button所在父视图的宽度
        if(10 + w + length + 20 > SCREEN_WIDTH-100){
            w = 0; //换行时将w置为0
            h = h + button1.frame.size.height + 10;//距离父视图也变化
            button1.frame = CGRectMake(10 + w, h, length + 20, 30);//重设button的frame
        }
        w = button1.frame.size.width + button1.frame.origin.x;
        [_upView addSubview:button1];
    }
    
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, h+40, 80, 30)];
    label2.text = @"系列";
    [self.upView addSubview:label2];
    CGFloat w2 = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h2 = h+80;//用来控制button距离父视图的高
    for (int i = 0; i < self.array4.count; i++) {
        button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        button2.tag = 100 + i;
        button2.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
        button2.layer.masksToBounds = YES;
        button2.layer.cornerRadius = 5.0;
        [button2 addTarget:self action:@selector(handleClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn2arr addObject:button2];
        
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        Model *model = [self.array4 objectAtIndex:i];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
        CGSize size = CGSizeMake(MAXFLOAT, 25);
        CGFloat length = [model.seriesName boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
        //为button赋值
        [button2 setTitle:model.seriesName forState:UIControlStateNormal];
        //设置button的frame
        button2.frame = CGRectMake(10 + w2, h2, length + 20 , 30);
        //当button的位置超出屏幕边缘时换行 只是button所在父视图的宽度
        if(10 + w2 + length + 20 > SCREEN_WIDTH-100){
            w2 = 0; //换行时将w置为0
            h2 = h2 + button2.frame.size.height + 10;//距离父视图也变化
            button2.frame = CGRectMake(10 + w2, h2, length + 20, 30);//重设button的frame
        }
        w2 = button2.frame.size.width + button2.frame.origin.x;
        [_upView addSubview:button2];
    }
    
    
    
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, h2+40, 80, 30)];
    label3.text = @"类型";
    [self.upView addSubview:label3];
    CGFloat w3 = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h3 = h2+80;//用来控制button距离父视图的高
    for (int i = 0; i < self.array2.count; i++) {
        button3 = [UIButton buttonWithType:UIButtonTypeSystem];
        button3.tag = 100 + i;
        button3.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
        button3.layer.masksToBounds = YES;
        button3.layer.cornerRadius = 5.0;
        [button3 addTarget:self action:@selector(handleClick3:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn3arr addObject:button3];
        
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        Model *model = [self.array2 objectAtIndex:i];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
        CGSize size = CGSizeMake(MAXFLOAT, 25);
        CGFloat length = [model.catalogName boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
        //为button赋值
        [button3 setTitle:model.catalogName forState:UIControlStateNormal];
        //设置button的frame
        button3.frame = CGRectMake(10 + w3, h3, length + 20 , 30);
        //当button的位置超出屏幕边缘时换行 只是button所在父视图的宽度
        if(10 + w3 + length + 20 > SCREEN_WIDTH-100){
            w3 = 0; //换行时将w置为0
            h3 = h3 + button3.frame.size.height + 10;//距离父视图也变化
            button3.frame = CGRectMake(10 + w3, h3, length + 20, 30);//重设button的frame
        }
        w3 = button3.frame.size.width + button3.frame.origin.x;
        [_upView addSubview:button3];
    }
    
    
    
    
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, h3+40, 80, 30)];
    label4.text = @"分类";
    [self.upView addSubview:label4];
    CGFloat w4 = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h4 = h3+80;//用来控制button距离父视图的高
    for (int i = 0; i < self.array3.count; i++) {
        button4 = [UIButton buttonWithType:UIButtonTypeSystem];
        button4.tag = 100 + i;
        button4.backgroundColor = [UIColor colorWithWhite:.9 alpha:.3];
        button4.layer.masksToBounds = YES;
        button4.layer.cornerRadius = 5.0;
        [button4 addTarget:self action:@selector(handleClick4:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn4arr addObject:button4];
        
        [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        Model *model = [self.array3 objectAtIndex:i];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:22.f]};
        CGSize size = CGSizeMake(MAXFLOAT, 25);
        CGFloat length = [model.typeName boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
        //为button赋值
        [button4 setTitle:model.typeName forState:UIControlStateNormal];
        //设置button的frame
        button4.frame = CGRectMake(10 + w4, h4, length + 20 , 30);
        //当button的位置超出屏幕边缘时换行 只是button所在父视图的宽度
        if(10 + w4 + length + 20 > SCREEN_WIDTH-100){
            w4 = 0; //换行时将w置为0
            h4 = h4 + button3.frame.size.height + 10;//距离父视图也变化
            button4.frame = CGRectMake(10 + w4, h4, length + 20, 30);//重设button的frame
        }
        w4 = button4.frame.size.width + button4.frame.origin.x;
        [_upView addSubview:button4];
    }
    
    
    
    _upView.contentSize = CGSizeMake(0, h4+60);
    
    label1.textColor = RGB_AB;
    label2.textColor = RGB_AB;
    label3.textColor = RGB_AB;
    label4.textColor = RGB_AB;
    label5.textColor = RGB_AB;
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label2.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label3.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label4.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label5.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
}
- (void)tapAction{
    for (UIButton *btn in _btn1arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn2arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn3arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn4arr) {
        btn.backgroundColor =  [UIColor colorWithWhite:.9 alpha:.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";

    
    [UIView animateWithDuration:.3 animations:^{
        self.window.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}



- (void)getDataFromlocal {
    LRWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"FL_Casher"];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        if (fileDic == nil) {
            [weakSelf setUpReflash];
        }else {
            [weakSelf havecasher:fileDic];
        }
        //回到主线程刷新ui
        LRStrongSelf(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.goosdCollectionView reloadData];
        });
    });
}
- (void)havecasher:(NSMutableArray *)arr{
    [self.dataArray removeAllObjects];
    for (NSDictionary *dicc in arr) {
        Model *model = [Model mj_objectWithKeyValues:dicc];
        [self.dataArray addObject:model];
    }
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
        if (weakSelf.dataArray.count == self->number) {
            [weakSelf.goosdCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loddeSLList];
        }
    }];
}
- (void)loddeList{
   
    
    [self.goosdCollectionView.mj_footer endRefreshing];
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/search?keyWord=%@&startRow=0&pageSize=10&brand=%@&catalog=%@&series=%@&type=%@&price=%@",seacherStr,str1,str3,str2,str4,@""];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        
        //NSLog(@"******%@",diction);
        [weakSelf.dataArray removeAllObjects];
        self->number = [[diction objectForKey:@"total"] integerValue];
        
        
        if ([Manager judgeWhetherIsEmptyAnyObject:[diction objectForKey:@"itemsList"]] == YES) {
            NSMutableArray *arr = [diction objectForKey:@"itemsList"];
             [Manager writewenjianming:@"huancun.text" content:@"you"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:@"FL_Casher"];
                [arr writeToFile:filewebCaches atomically:YES];
            });
            
            for (NSDictionary *dicc in arr) {
                Model *model = [Model mj_objectWithKeyValues:dicc];
                [weakSelf.dataArray addObject:model];
            }
        }
        self->page = 10;
        [weakSelf.goosdCollectionView reloadData];
        [weakSelf.goosdCollectionView.mj_header endRefreshing];
    } enError:^(NSError *error) {
//        NSLog(@"------%@",error);
    }];
}











- (void)loddeSLList{
    [self.goosdCollectionView.mj_header endRefreshing];
    __weak typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:@"product/search?keyWord=%@&startRow=%ld&pageSize=10&brand=%@&catalog=%@&series=%@&type=%@&price=%@",seacherStr,page,str1,str3,str2,str4,@""];
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
        self->page+=10;
        [weakSelf.goosdCollectionView reloadData];
        [weakSelf.goosdCollectionView.mj_footer endRefreshing];
    } enError:^(NSError *error) {
//        NSLog(@"------%@",error);
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
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        cell.lab1.text       = model.model_name;
        cell.lab2.text     = model.sale_price;
        cell.lab3.text = model.series_name;
        
        
        cell.lab4.backgroundColor = RGB_AB;
        cell.lab2.textColor = RGB_AB;
        
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
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        cell.lab1.text       = model.model_name;
        cell.lab3.text     = model.sale_price;
        cell.lab2.text = model.series_name;
        
        
        cell.lab4.backgroundColor = RGB_AB;
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
    
//    [self presentViewController:details animated:YES completion:nil];
    

    [self.navigationController pushViewController:details animated:YES];
}




- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (NSMutableArray *)array1{
    if (_array1 == nil) {
        self.array1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _array1;
}
- (NSMutableArray *)array2{
    if (_array2 == nil) {
        self.array2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _array2;
}
- (NSMutableArray *)array3{
    if (_array3 == nil) {
        self.array3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _array3;
}
- (NSMutableArray *)array4{
    if (_array4 == nil) {
        self.array4 = [NSMutableArray arrayWithCapacity:1];
    }
    return _array4;
}
- (NSMutableArray *)btn1arr{
    if (_btn1arr == nil) {
        self.btn1arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _btn1arr;
}
- (NSMutableArray *)btn2arr{
    if (_btn2arr == nil) {
        self.btn2arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _btn2arr;
}
- (NSMutableArray *)btn3arr{
    if (_btn3arr == nil) {
        self.btn3arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _btn3arr;
}
- (NSMutableArray *)btn4arr{
    if (_btn4arr == nil) {
        self.btn4arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _btn4arr;
}
@end
