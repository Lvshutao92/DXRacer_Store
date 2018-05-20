//
//  ProductDetailsViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/14.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "ProductDetailsViewController.h"

@interface ProductDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate, UIScrollViewDelegate , UIWebViewDelegate,SelectAttributesDelegate>
{
    
    NSMutableDictionary *dic_sID;
    NSMutableArray *arr_sID;
    
    NSMutableArray *productItemList_Arr;
    
    NSMutableArray *arr;
    NSString *productCanshu;
    NSString *productnumber;
    NSString *stringID;
    NSString *stringPrice;
    NSString *stringStatus;
    NSString *stringImg;
    NSString *itemNo;
    
    
    UIView *view_bar;
    
    UIView *headerV;
    UIView *footerV;
    
    UILabel *titleLab;
    UILabel *priceLab;
    UILabel *line1;
    
    UILabel *guigeLab;
    UIImageView *guigeimg;
    UIButton *guigeBtn;
    UILabel *line2;
    
    
    
    
    CGFloat titleHeight;
    
    UISegmentedControl *segment;
}


@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)NSArray *standardList;
@property(nonatomic,strong)NSArray *standardValueList;


@property (nonatomic , strong)UIWebView *webView;
@property (nonnull , strong)UILabel *headLab;


@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *lunboArray;


@end

@implementation ProductDetailsViewController





//懒加载 webView 增加流畅度
- (UIWebView *)webView{
    //注意,这里不用 self 防止循环引用
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _tableview.contentSize.height, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dxracer.com.cn"]]];
    }
    return _webView;
}
//监测 scroll 的偏移量
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if([scrollView isKindOfClass:[UITableView class]]) // tableView界面上的滚动
    {
        // 能触发翻页的理想值:tableView整体的高度减去屏幕本省的高度
        CGFloat valueNum = _tableview.contentSize.height - self.view.frame.size.height;
        if ((offsetY - valueNum) > 40)
        {
            [self goToDetailAnimation]; // 进入图文详情的动画
        }
    }
    else // webView页面上的滚动
    {
        if(offsetY < 0 && -offsetY > 40)
        {
            [self backToFirstPageAnimation]; // 返回基本详情界面的动画
        }
    }
}
// 进入详情的动画
- (void)goToDetailAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self->_webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        self->_tableview.frame = CGRectMake(0, -self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}
// 返回第一个界面的动画
- (void)backToFirstPageAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self->_tableview.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.bounds.size.height-35);
        self->_webView.frame = CGRectMake(0, self->_tableview.contentSize.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}
// KVO观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(object == _webView.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
        [self headLabAnimation:[change[@"new"] CGPointValue].y];
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// 头部提示文本动画
- (void)headLabAnimation:(CGFloat)offsetY
{
    _headLab.alpha = -offsetY/60;
    _headLab.center = CGPointMake(self.view.frame.size.width/2, -offsetY/2.f);
    // 图标翻转，表示已超过临界值，松手就会返回上页
    if(-offsetY > 40){
        _headLab.textColor = [UIColor redColor];
        _headLab.text = @"释放，返回详情";
    }else{
        _headLab.textColor = [UIColor blackColor];
        _headLab.text = @"上拉，返回详情";
    }
}








- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    productItemList_Arr = [NSMutableArray arrayWithCapacity:1];
    productnumber = @"1";
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT-35)];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footLabel.text = @"继续拖动，查看图文详情";
    footLabel.font = [UIFont systemFontOfSize:13];
    footLabel.textAlignment = NSTextAlignmentCenter;
    _tableview.tableFooterView = footLabel;
    //注意:懒加载时,只有用 self 才能调其 getter 方法
    [self.view addSubview:self.webView];
    _headLab = [[UILabel alloc] init];
    _headLab.text = @"上拉，返回详情";
    _headLab.textAlignment = NSTextAlignmentCenter;
    _headLab.font = [UIFont systemFontOfSize:13];
    _headLab.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.f);
    _headLab.alpha = 0.f;
    _headLab.textColor = [UIColor blackColor];
    [_webView addSubview:_headLab];
   
    
    
    
    
    
    
    headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 900)];
    self.tableview.tableHeaderView = headerV;
    
    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
    self.tableview.tableFooterView = footerV;
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    [headerV addSubview:self.cycleScrollView];
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.numberOfLines = 0;
    [headerV addSubview:titleLab];
    priceLab = [[UILabel alloc]init];
    priceLab.textColor = [UIColor redColor];
    [headerV addSubview:priceLab];
    line1 = [[UILabel alloc]init];
    line1.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [headerV addSubview:line1];
    
    
    guigeLab = [[UILabel alloc]init];
    guigeLab.textColor = [UIColor grayColor];
    [headerV addSubview:guigeLab];
    if (productCanshu == nil) {
        guigeLab.text = @"请选择规格属性";
    }
    guigeimg = [[UIImageView alloc]init];
    guigeimg.image = [UIImage imageNamed:@"箭头3"];
    [headerV addSubview:guigeimg];
    guigeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guigeBtn addTarget:self action:@selector(chooseViewClick) forControlEvents:UIControlEventTouchUpInside];
    [headerV addSubview:guigeBtn];
    line2 = [[UILabel alloc]init];
    line2.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [headerV addSubview:line2];
    
    
    
    
    
    
    [self getDetailsInfo];
    [self NavigationBa];
    [self setupdibuview];
    
   
    
}
-(void)initSelectView{
    
    self.selectView = [[DWQSelectView alloc] initWithFrame:CGRectMake(0, screen_Height, screen_Width, screen_Height)];
//    self.selectView.headImage.image = [UIImage imageNamed:@"凯迪拉克.jpg"];
//    self.selectView.LB_price.text = @"￥121.00";
//    self.selectView.LB_stock.text = [NSString stringWithFormat:@"库存%@件",@999];
//    self.selectView.LB_showSales.text=@"已销售40件";
    self.selectView.LB_detail.text = @"请选择规格属性";
    
    [self.view addSubview:self.selectView];
    
    CGFloat maxY = 0;
    CGFloat height = 0;
    for (int i = 0; i < self.standardList.count; i ++)
    {
        self.selectAttributes = [[DWQSelectAttributes alloc] initWithTitle:self.standardList[i] titleArr:self.standardValueList[i] andFrame:CGRectMake(0, maxY, screen_Width, 40)];
        maxY = CGRectGetMaxY(self.selectAttributes.frame);
        height += self.selectAttributes.dwq_height;
        self.selectAttributes.tag = 8000+i;
        self.selectAttributes.delegate = self;
        [self.selectView.mainscrollview addSubview:self.selectAttributes];
    }
    self.selectView.mainscrollview.contentSize = CGSizeMake(0, height);
    //加入购物车按钮
    [self.selectView.addBtn addTarget:self action:@selector(addGoodsCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //立即购买
    [self.selectView.buyBtn addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    [self.selectView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.selectView.alphaView addGestureRecognizer:tap];
    
    HJCAjustNumButton *btn = [[HJCAjustNumButton alloc] init];
    btn.frame = CGRectMake(SCREEN_WIDTH-165, SCREEN_HEIGHT-90, 150, 35);
    btn.callBack = ^(NSString *currentNum){
        self->productnumber = currentNum;
    };
    [self.selectView addSubview:btn];
}





-(void)addGoodsCartBtnClick{
    if (stringID.length <=0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该商品已下架" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self addCurt];
    }
    NSLog(@"加入购物车======%@--%@",stringID,productnumber);
    
}
- (void)addCurt{
    NSDictionary *dic = @{@"productItemId":stringID,
                          @"quantity":productnumber};
    
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            [self dismiss];
        }else{
            
        }
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}







#pragma mark --弹出规格属性
-(void)chooseViewClick{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        [UIView animateWithDuration: 0.35 animations: ^{
            self.backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.selectView.frame =CGRectMake(0, 0, screen_Width, screen_Height);
        } completion: nil];
    }
}

/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    //    center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        self.selectView.frame =CGRectMake(0, screen_Height, screen_Width, screen_Height);
        self.backgroundView.transform = CGAffineTransformIdentity;
    } completion: nil];
    
}
-(NSMutableArray *)attributesArray{
    
    if (_attributesArray == nil) {
        
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

-(void)selectBtnTitle:(NSString *)title andBtn:(UIButton *)btn{
    NSString *st;
    [arr_sID removeAllObjects];
    [self.attributesArray removeAllObjects];
    stringID = @"";
    stringPrice = @"";
    stringStatus = @"";
    stringImg = @"";
    itemNo = @"";
    for (int i=0; i < _standardList.count; i++)
    {
        
        DWQSelectAttributes *view = [self.view viewWithTag:8000+i];
        for (UIButton *obj in  view.btnView.subviews)
        {
            if(obj.selected){
                for (NSArray *arr in self.standardValueList)
                {
                    for (NSString *title in arr) {
                        if ([view.selectBtn.titleLabel.text isEqualToString:title]) {
                            if (![self.attributesArray containsObject:view.selectBtn.titleLabel.text]) {
                                [self.attributesArray addObject:view.selectBtn.titleLabel.text];
                                
                                [arr_sID addObject:[dic_sID objectForKey:view.selectBtn.titleLabel.text]];
                                
                               
                                st = [arr_sID componentsJoinedByString:@","];
                                for (NSDictionary *dict in productItemList_Arr) {
                                    if ([[dict objectForKey:@"productModelAttrs"]isEqualToString:st]) {
                                        stringID = [dict objectForKey:@"id"];
                                        stringPrice = [dict objectForKey:@"salePrice"];
                                        stringStatus = [dict objectForKey:@"status"];
                                        stringImg = [dict objectForKey:@"listImg"];
                                        itemNo = [dict objectForKey:@"itemNo"];
                                    }
                                }
                                
                                if (stringID.length <=0){
                                    self.selectView.LB_price.text = [NSString stringWithFormat:@"¥ %@",stringPrice];
                                    self.selectView.LB_stock.text = stringStatus;
                                    self.selectView.LB_showSales.text=itemNo;
                                    [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]];
                                }else{
                                    self.selectView.LB_price.text = [NSString stringWithFormat:@"¥ %@",stringPrice];
                                    self.selectView.LB_stock.text = stringStatus;
                                    self.selectView.LB_showSales.text=itemNo;
                                    [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    productCanshu = [self.attributesArray componentsJoinedByString:@","];
    if (productCanshu == nil) {
        guigeLab.text = @"请选择规格属性";
    }else{
        guigeLab.text = [NSString stringWithFormat:@"已选规格：%@",productCanshu];
    }
    
}












- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    if (section == 0) {
        lab.text = @"——宝贝——";
    }
    else if (section == 1) {
        lab.text = @"——详情——";
    }
    else if (section == 2) {
        lab.text = @"——评论——";
    }
    return lab;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @"dxracer";
    return cell;
}

- (void)getDetailsInfo{
    __weak typeof(self) weakSelf = self;
    //NSString *str = [NSString stringWithFormat:@"product/%@",self.idStr];
    NSString *str = @"product/294b040671dd4865915b77fc8fbbce99";
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Manager requestPOSTWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"productImageList"]] == YES) {
                NSMutableArray *arr = [[diction objectForKey:@"object"]objectForKey:@"productImageList"];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.lunboArray addObject:model];
                }
            }
            
            
            
            self->productItemList_Arr = [[diction objectForKey:@"object"]objectForKey:@"productItemList"];
            
            
            
            NSMutableArray *attrList = [[diction objectForKey:@"object"]objectForKey:@"productAttrList"];
            NSMutableArray *attrList_a = [NSMutableArray arrayWithCapacity:1];
            NSMutableArray *attrList_b = [NSMutableArray arrayWithCapacity:1];
            
            
            self->arr_sID = [NSMutableArray arrayWithCapacity:1];
            
            self->dic_sID = [NSMutableDictionary dictionaryWithCapacity:1];
            
            
            NSMutableArray *abc = [NSMutableArray arrayWithCapacity:1];
            
            for (NSDictionary *dic in attrList) {
                [attrList_a addObject:[[dic objectForKey:@"attrKey"] objectForKey:@"catalogAttrValue"]];
                
                NSMutableArray *aaa = [dic objectForKey:@"attrValues"];
                self->arr = [NSMutableArray arrayWithCapacity:1];
                
                NSDictionary *dict1 = [aaa firstObject];
                //NSLog(@"******%@",[dict1 objectForKey:@"modelAttrValue"]);
                [abc addObject:[dict1 objectForKey:@"modelAttrValue"]];
                
                for (NSDictionary *dicts in aaa) {
                    [self->arr addObject:[dicts objectForKey:@"modelAttrValue"]];
                    [self->dic_sID setValue:[dicts objectForKey:@"id"] forKey:[dicts objectForKey:@"modelAttrValue"]];
                }
                
                [attrList_b addObject:self->arr];
            }
            
            self->productCanshu = [abc componentsJoinedByString:@","];
            self->guigeLab.text = [NSString stringWithFormat:@"已选规格：%@",self->productCanshu];
            weakSelf.standardList = attrList_a;
            weakSelf.standardValueList = (NSArray *)attrList_b;
            
            
            
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"product"]] == YES){
                    NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"product"];
                self->titleHeight = [Manager getLabelHeightWithContent:[dicti objectForKey:@"modelName"] andLabelWidth:SCREEN_WIDTH-30 andLabelFontSize:17];
                            
                self->titleLab.text = [dicti objectForKey:@"modelName"];
                self->priceLab.text = [NSString stringWithFormat:@"¥ %@",[dicti objectForKey:@"salePrice"]];
                            
                self->titleLab.frame = CGRectMake(5, 310, SCREEN_WIDTH-10, self->titleHeight);
                self->priceLab.frame = CGRectMake(5, 310+self->titleHeight+10, SCREEN_WIDTH-10, 20);
                self->line1.frame = CGRectMake(0, 310+self->titleHeight+40, SCREEN_WIDTH, 10);
                
                self->guigeLab.frame = CGRectMake(5, 310+self->titleHeight+60, SCREEN_WIDTH-10, 40);
                self->guigeimg.frame = CGRectMake(SCREEN_WIDTH-30, 310+self->titleHeight+70, 20, 20);
                self->guigeBtn.frame = CGRectMake(0, 310+self->titleHeight+50, SCREEN_WIDTH, 55);
                self->line2.frame = CGRectMake(0, 310+self->titleHeight+105, SCREEN_WIDTH, 5);
                
                
                [weakSelf initSelectView];
                NSDictionary *dicc = self->productItemList_Arr[0];
                [weakSelf.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString([dicc objectForKey:@"listImg"])]];
                weakSelf.selectView.LB_price.text = [NSString stringWithFormat:@"¥ %@",[dicc objectForKey:@"salePrice"]];
                weakSelf.selectView.LB_stock.text = [dicc objectForKey:@"status"];
                weakSelf.selectView.LB_showSales.text=[dicc objectForKey:@"itemNo"];
                self->stringID = [dicc objectForKey:@"id"];
                
               
            }
            
            
        }
        
        
       
        
       
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        [array removeAllObjects];
        for (Model *mo in weakSelf.lunboArray) {
            [array addObject:NSString(mo.listImg)];
        }
        weakSelf.cycleScrollView.localizationImageNamesGroup = array;
        
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---------%ld",index);
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
    
   
    UILabel *lab= [[UILabel alloc]initWithFrame:CGRectMake(60, 20+(hei-30)/2+2, SCREEN_WIDTH-120, 30)];
    lab.text = @"商品详情";
    lab.textAlignment = NSTextAlignmentCenter;
    [view_bar addSubview:lab];
    
    
    
    
    
    
    UIImage *theImage = [UIImage imageNamed:@"circlesmore2_icon"];
    //    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* meBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 20+(hei-30)/2+2, 30, 30)];
    [meBtn setBackgroundImage:theImage forState:UIControlStateNormal];
    //    [meBtn setTintColor:[UIColor blackColor]];
    [meBtn addTarget:self action:@selector(onLeftNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:meBtn];
    
    UIImage *theImage1 = [UIImage imageNamed:@"whirfenxiangt_icone"];
    //    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20+(hei-30)/2+2, 30, 30)];
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
    }else if(self.tableview.contentOffset.y<350){
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:self.tableview.contentOffset.y / 10000];
    }else
    {
        [view_bar setHidden:NO];
        view_bar.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    }
}

- (void)onLeftNavBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onRightNavBtnClick {
    NSLog(@"消息");
}



- (void)setupdibuview{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55)];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH-120, 0, 120, 55);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"立即购买" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(SCREEN_WIDTH-240, 0, 120, 55);
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(cllll) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake((SCREEN_WIDTH-240)/2, 0, (SCREEN_WIDTH-240)/2, 55);
    [btn3 setTitle:@"收藏" forState:UIControlStateNormal];
     btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(cilck3) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0, 0, (SCREEN_WIDTH-240)/2, 55);
    [btn4 setTitle:@"客服" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor whiteColor];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(cilck4) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn4];
}
-(void)cllll{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        if (stringID.length <=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该商品已下架" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self addCurt];
        }
    }
    NSLog(@"加入购物车======%@--%@",stringID,productnumber);
}




- (void)cilck1{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        
    }
}

- (void)cilck3{
    
}
- (void)cilck4{
    
}



- (NSMutableArray *)lunboArray{
    if (_lunboArray == nil) {
        self.lunboArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _lunboArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self SetNavBarHidden:YES];
     [ _webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [_webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self SetNavBarHidden:NO];
}
@end
