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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    
   
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
    
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    [self pinpai];
    [self xilie];
    [self leixing];
    [self fenlei];
    
    
    [self initCollectionView];
    
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
    
    
    
    UIButton *bbb = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 40, 25)];
    //    [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
    [bbb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bbb setTitle:@"筛选" forState:UIControlStateNormal];
    [bbb addTarget:self action:@selector(clickshaixuan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:bbb];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, hei, 50, 44)];
    picBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, 25, 25)];
    [picBtn setImage:[UIImage imageNamed:@"分类2"] forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(clickqiehuan) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:picBtn];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:vv];
    self.navigationItem.rightBarButtonItem = bar1;
    
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-170, 60, 60)];
    LRViewBorderRadius(lab, 30, 0, [UIColor clearColor]);
    lab.backgroundColor = [UIColor colorWithWhite:.97 alpha:.3];
//    [self.view addSubview:lab];
//    [self.view bringSubviewToFront:lab];
    
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
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick2:(UIButton *)sender{
    Model *model = [self.array4 objectAtIndex:sender.tag - 100];
    str2 = model.id;
    for (UIButton *btn in _btn2arr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick3:(UIButton *)sender{
    Model *model = [self.array2 objectAtIndex:sender.tag - 100];
    str3 = model.id;
    for (UIButton *btn in _btn3arr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)handleClick4:(UIButton *)sender{
    Model *model = [self.array3 objectAtIndex:sender.tag - 100];
    str4 = model.id;
    for (UIButton *btn in _btn4arr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}
- (void)chongzhi{
    for (UIButton *btn in _btn1arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn2arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn3arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn4arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
}
- (void)sure{
    [self.window resignKeyWindow];
    [self.upView removeFromSuperview];
    self.window  = nil;
    self.upView = nil;
    [self setUpReflash];
}










- (void)clickshaixuan{
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    window.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    window.windowLevel = UIWindowLevelNormal;
    window.hidden = NO;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [window addGestureRecognizer:tap];
    [window makeKeyAndVisible];
    self.window = window;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, SCREEN_HEIGHT-50)];
    view.backgroundColor = [UIColor whiteColor];
    [window addSubview:view];
    self.upView = view;
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT-50, (SCREEN_WIDTH-100)/2, 50)];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"重置" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100+(SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-50, (SCREEN_WIDTH-100)/2, 50)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:btn2];
    
    [self.btn1arr removeAllObjects];
    [self.btn2arr removeAllObjects];
    [self.btn3arr removeAllObjects];
    [self.btn4arr removeAllObjects];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 30)];
    label1.text = @"品牌";
    [self.upView addSubview:label1];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 60;//用来控制button距离父视图的高
    for (int i = 0; i < self.array1.count; i++) {
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.tag = 100 + i;
        button1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
        button1.layer.masksToBounds = YES;
        button1.layer.cornerRadius = 5.0;
        [button1 addTarget:self action:@selector(handleClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.btn1arr addObject:button1];
        
        
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        
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
        button2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
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
        button3.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
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
        button4.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
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
    
    
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, h4+40, 80, 30)];
    label5.text = @"价格区间";
    [self.upView addSubview:label5];
    CGFloat h5 = h4+80;
    text1 = [[UITextField alloc]initWithFrame:CGRectMake(10, h5, 60, 35)];
    text1.delegate = self;
    text1.text = @"";
    text1.borderStyle = UITextBorderStyleRoundedRect;
    [_upView addSubview:text1];
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(70, h5, 40, 35)];
    lin.text = @"~";
    lin.textAlignment = NSTextAlignmentCenter;
    [self.upView addSubview:lin];
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(110, h5, 60, 35)];
    text2.delegate = self;
    text2.text = @"";
    text2.borderStyle = UITextBorderStyleRoundedRect;
    [_upView addSubview:text2];
    
    _upView.contentSize = CGSizeMake(0, h5+60);
    
    label1.textColor = [UIColor orangeColor];
    label2.textColor = [UIColor orangeColor];
    label3.textColor = [UIColor orangeColor];
    label4.textColor = [UIColor orangeColor];
    label5.textColor = [UIColor orangeColor];
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label2.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label3.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label4.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label5.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
}
- (void)tapAction{
    for (UIButton *btn in _btn1arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn2arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn3arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _btn4arr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    
    
    [self.window resignKeyWindow];
    [self.upView removeFromSuperview];
    self.window  = nil;
    self.upView = nil;
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
    NSString *str = [NSString stringWithFormat:@"product/search?keyWord=%@&startRow=0&pageSize=10&brand=%@&catalog=%@&series=%@&type=%@&price=%@",seacherStr,str1,str3,str2,str4,@""];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [Manager requestGETWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
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
        self->page = 10;
        [weakSelf.goosdCollectionView reloadData];
        [weakSelf.goosdCollectionView.mj_header endRefreshing];
        
        
        if (weakSelf.dataArray.count == 0) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            lab.text = @"抱歉！暂无该商品";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor lightGrayColor];
            [weakSelf.view addSubview:lab];
        }
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
    if (!self.isPermutation){
        FL_1_Cell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FL_1_Cell" forIndexPath:indexPath];
        Model *model = [self.dataArray objectAtIndex:indexPath.row];
        LRViewBorderRadius(cell.bgv, 0, .5, [UIColor colorWithWhite:.8 alpha:.3]);
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.model_img)]placeholderImage:[UIImage imageNamed:@""]];
        cell.lab1.text       = model.model_name;
        cell.lab2.text     = model.sale_price;
        cell.lab3.text = model.series_name;
        
        
        cell.lab4.backgroundColor = [UIColor redColor];
        
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
        
        
        cell.lab4.backgroundColor = [UIColor redColor];
        
        if ([Manager judgeWhetherIsEmptyAnyObject:model.promotionTitle]==YES) {
            cell.lab4.hidden = NO;
            cell.lab2height.constant = 20;
            cell.lab4height.constant = 20;
            LRViewBorderRadius(cell.lab4, 10, 0, [UIColor clearColor]);
            
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
