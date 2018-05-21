//
//  ProductXiangqingViewController.m
//  商城详情
//
//  Created by 吕书涛 on 2018/5/17.
//  Copyright © 2018年 吕书涛. All rights reserved.
//

#import "ProductXiangqingViewController.h"
#import "FrankDetailDropDelegate.h"
#import "FrankDropBounsView.h"
#import <MJRefresh/MJRefresh.h>
#import "BiaogeTableViewCell.h"
#import "CreateOrderViewController.h"
@interface ProductXiangqingViewController ()<FrankDetailDropDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate, UIScrollViewDelegate , UIWebViewDelegate,SelectAttributesDelegate,LLPhotoBrowserDelegate>
{
    
    CGFloat imgheight;
    
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
    
    
    UIView *headerV;
    UIView *footerV;
    
    UILabel *titleLab;
    UILabel *priceLab;
    UILabel *line1;
    
    UILabel *guigeLab;
    UIImageView *guigeimg;
    UIButton *guigeBtn;
    UILabel *line2;
    
    NSMutableArray *afe;
    
    
    CGFloat titleHeight;
    
    UISegmentedControl *segment;
}
@property(nonatomic,strong)MBProgressHUD *HUD;


@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)NSArray *standardList;
@property(nonatomic,strong)NSArray *standardValueList;



@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *lunboArray;



@property (nonatomic, strong) FrankDropBounsView * dropView;
@property (nonatomic, strong) UILabel * tabbarView;


@property (nonatomic, strong) UITableView * tableview1;
@property (nonatomic, strong) UITableView * tableview2;
@property (nonatomic, strong) UITableView * tableview3;
@property (nonatomic, strong) UITableView * tableview4;

@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;

@end

@implementation ProductXiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"宝贝";
    
    UIImage *theImage1 = [UIImage imageNamed:@"3"];
    UIView *ve = [[UIView alloc]initWithFrame:CGRectMake(0, [Manager returnDianchitiaoHeight], 44, 44)];
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    [readerBtn setBackgroundImage:theImage1 forState:UIControlStateNormal];
    [readerBtn addTarget:self action:@selector(onRightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [ve addSubview:readerBtn];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:ve];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    productItemList_Arr = [NSMutableArray arrayWithCapacity:1];
    productnumber = @"1";
    
    self.tabbarView.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.dropView];
    [self.view addSubview:self.tabbarView];
    
    
    
    
    headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 650)];
    self.tableview1.tableHeaderView = headerV;
    
    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.tableview1.tableFooterView = footerV;
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    
    [self getIndexOneInfomation];
    [self getIndexTwoInfomation];
    
   
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    [array removeAllObjects];
    for (Model *mo in self.lunboArray) {
        [array addObject:NSString(mo.listImg)];
    }
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:(NSArray *)array currentIndex:index];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}


- (void)onRightNavBtnClick {
    self.tabBarController.selectedIndex = 2;
}






-(void)initSelectView{
    
    self.selectView = [[DWQSelectView alloc] initWithFrame:CGRectMake(0, screen_Height, screen_Width, screen_Height)];
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
                                    
                                    self.selectView.LB_stock.text = itemNo;
                                    //self.selectView.LB_showSales.text=stringStatus;
                                    
                                    [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]];
                                }else{
                                    self.selectView.LB_price.text = [NSString stringWithFormat:@"¥ %@",stringPrice];
                                    
                                    
                                    self.selectView.LB_stock.text = itemNo;
                                    //self.selectView.LB_showSales.text=stringStatus;
                                    
                                    
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

- (void)getDetailsInfo{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/%@",self.idStr];
//    NSString *str = @"product/294b040671dd4865915b77fc8fbbce99";
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Manager requestPOSTWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
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
            NSString *string;
            
            
            for (NSDictionary *dic in attrList) {
                [attrList_a addObject:[[dic objectForKey:@"attrKey"] objectForKey:@"catalogAttrValue"]];
                
                NSMutableArray *aaa = [dic objectForKey:@"attrValues"];
                self->arr = [NSMutableArray arrayWithCapacity:1];
                
                NSDictionary *dict1 = [aaa firstObject];
                //NSLog(@"******%@",[dict1 objectForKey:@"modelAttrValue"]);
                [abc addObject:[dict1 objectForKey:@"modelAttrValue"]];
                
                
                
                self->afe = [NSMutableArray arrayWithCapacity:1];
                int i = 0;
                
                for (NSDictionary *dicts in aaa) {
                    [self->arr addObject:[dicts objectForKey:@"modelAttrValue"]];
                    [self->dic_sID setValue:[dicts objectForKey:@"id"] forKey:[dicts objectForKey:@"modelAttrValue"]];
                    if (i==0) {
                        [self->afe addObject:[dicts objectForKey:@"id"]];
                    }
                    i++;
                }
                
                
                
                [attrList_b addObject:self->arr];
            }
            
          
           
            string = [self->afe componentsJoinedByString:@","];
            
            
            
//            self->productCanshu = [abc componentsJoinedByString:@","];
//            self->guigeLab.text = [NSString stringWithFormat:@"已选规格：%@",self->productCanshu];
            
            weakSelf.standardList = attrList_a;
            weakSelf.standardValueList = (NSArray *)attrList_b;
            
            
            
            
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"product"]] == YES){
                NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"product"];
                self->titleHeight = [Manager getLabelHeightWithContent:[dicti objectForKey:@"modelName"] andLabelWidth:SCREEN_WIDTH-30 andLabelFontSize:17];
                
                self->titleLab.text = [dicti objectForKey:@"modelName"];
                self->priceLab.text = [NSString stringWithFormat:@"¥ %@",[dicti objectForKey:@"salePrice"]];
                
                
                self->titleLab.frame = CGRectMake(5, 10+SCREEN_WIDTH, SCREEN_WIDTH-10, self->titleHeight);
                self->priceLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+10, SCREEN_WIDTH-10, 20);
                self->line1.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+40, SCREEN_WIDTH, 10);
                
                self->guigeLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+60, SCREEN_WIDTH-10, 40);
                self->guigeimg.frame = CGRectMake(SCREEN_WIDTH-30, 10+SCREEN_WIDTH+self->titleHeight+70, 20, 20);
                self->guigeBtn.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+50, SCREEN_WIDTH, 55);
                self->line2.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+105, SCREEN_WIDTH, 5);
                
                
                [weakSelf initSelectView];
                
//                NSLog(@"##########%@",string);
//                NSDictionary *dicc = [self->productItemList_Arr lastObject];
//                for (NSDictionary *dicc in self->productItemList_Arr) {
//                    if ([[dicc objectForKey:@"productModelAttrs"] isEqualToString:string]) {
//                        [weakSelf.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString([dicc objectForKey:@"listImg"])]];
//                        weakSelf.selectView.LB_price.text = [NSString stringWithFormat:@"¥ %@",[dicc objectForKey:@"salePrice"]];
//                        weakSelf.selectView.LB_stock.text = [dicc objectForKey:@"status"];
//                        weakSelf.selectView.LB_showSales.text=[dicc objectForKey:@"itemNo"];
//                        self->stringID = [dicc objectForKey:@"id"];
//                    }
//                }
                
                
                
                
            }
           
            
        }
        
        
        
        
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        [array removeAllObjects];
        for (Model *mo in weakSelf.lunboArray) {
            [array addObject:NSString(mo.listImg)];
        }
        weakSelf.cycleScrollView.localizationImageNamesGroup = array;
        
        [weakSelf.tableview1 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}








-(void)cllll{
    
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        if (stringID.length <=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择商品属性" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self addCurt];
        }
    }
    
}
-(void)addGoodsCartBtnClick{
    if (productCanshu.length > 0 && stringID.length > 0) {
        [self addCurt];
    }else{
        if (productCanshu.length <=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择商品属性" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (stringID.length <=0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无该商品" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}
- (void)addCurt{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"productItemId":stringID,
                          @"quantity":productnumber};
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            [weakSelf dismiss];
            [weakSelf TextButtonAction];
        }else{
        }
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}




// 只显示文字
- (void)TextButtonAction{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"已加入购物车";
    _HUD.mode = MBProgressHUDModeText;
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }
       completionBlock:^{
           [_HUD removeFromSuperview];
           _HUD = nil;
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



- (void)cilck1{
    if ([Manager redingwenjianming:@"token.text"]==nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:nil];
    }else{
//        CreateOrderViewController *createOrder = [[CreateOrderViewController alloc]init];
//        createOrder.navigationItem.title = @"确认订单";
//        createOrder.dataArray = selectGoods;
//        [self.navigationController pushViewController:createOrder animated:YES];
        if (productCanshu.length > 0 && stringID.length > 0) {
            NSLog(@"%@---%@",productCanshu,stringID);
        }else{
            if (productCanshu.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择商品属性" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            if (stringID.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无该商品" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

- (void)cilck3{
    
}
- (void)cilck4{
    self.tabBarController.selectedIndex = 0;
}



- (NSMutableArray *)lunboArray{
    if (_lunboArray == nil) {
        self.lunboArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _lunboArray;
}















- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 消除导航影响
    //[self.dropView viewControllerWillAppear];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    // 消除导航影响
    //[self.dropView viewControllerWillDisappear];
}


- (UILabel *)tabbarView{
    
    if (!_tabbarView) {
        _tabbarView = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        _tabbarView.textAlignment = NSTextAlignmentCenter;
        
        _tabbarView.userInteractionEnabled = YES;
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH-120, 0, 120, 55);
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"立即购买" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH-240, 0, 120, 55);
        btn2.backgroundColor = [UIColor orangeColor];
        [btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(cllll) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn2];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake((SCREEN_WIDTH-240)/2, 0, (SCREEN_WIDTH-240)/2, 55);
        [btn3 setTitle:@"收藏" forState:UIControlStateNormal];
        btn3.backgroundColor = [UIColor whiteColor];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(cilck3) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn3];
        
        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(0, 0, (SCREEN_WIDTH-240)/2, 55);
        [btn4 setTitle:@"首页" forState:UIControlStateNormal];
        btn4.backgroundColor = [UIColor whiteColor];
        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(cilck4) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn4];
        
    }
    return _tabbarView;
}
- (FrankDropBounsView *)dropView{
    
    if (!_dropView) {
        
        CGFloat height = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.tabbarView.frame) - [Manager returnDaohanglanHeight];
        _dropView = [FrankDropBounsView createFrankDropBounsViewWithFrame:CGRectMake(0, [Manager returnDaohanglanHeight], CGRectGetWidth(self.view.frame), height) withDelegate:self];
        _dropView.needShowAlertView = NO;// 设置是否显示提示文字
        _dropView.backgroundColor = [UIColor clearColor];
        _dropView.alertTitle = @"";
    }
    
    return _dropView;
}


- (void)pullDownToReloadData:(MJRefreshNormalHeader *)table{
    NSLog(@"--- 下拉");
    
    [self.dropView showTopPageViewWithCompleteBlock:^{
        
        [table endRefreshing];
    }];
}
- (void)pullUpToReloadMoreData:(MJRefreshBackNormalFooter *)table{
    NSLog(@"--- 上拉");
    
    [self.dropView showBottomPageViewWithCompleteBlock:^{
        
        [table endRefreshing];
    }];
}
#pragma mark ---------  TripDetailDropDelegate  -------------
/**
 自定义上部展示视图模块 代理方法
 */
- (UIView *)frankDropBounsViewResetTopView{
    
    self.tableview1 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview1.backgroundColor = [UIColor whiteColor];
    
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
     [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    self.tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
    
    
    return self.tableview1;
}
#pragma mark ---------  TripDetailDropDelegate  -------------
/**
 自定义切换标题模块 代理方法
 */
- (NSArray *) resetToolbarTitles{
    return @[@"图片",@"参数",@"评价"];
}
/**
 自定义底部展示视图模块 代理方法
 */
- (UIView *)resetBottomViewsWithIndex:(NSInteger)index{
    
    if (index == 1) {
        self.tableview2 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableview2.delegate = self;
        self.tableview2.dataSource = self;
        [self.tableview2 registerNib:[UINib nibWithNibName:@"BigImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
        self.tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
        return self.tableview2;
    }
    if (index == 2) {
        self.tableview3 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableview3.delegate = self;
        self.tableview3.dataSource = self;
        [self.tableview3 registerNib:[UINib nibWithNibName:@"BiaogeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
        [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
        self.tableview3.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
        return self.tableview3;
    }
    
    
   self.tableview4 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview4.delegate = self;
    self.tableview4.dataSource = self;
    [self.tableview4 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell4"];
    [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToReloadMoreData:)];
    self.tableview4.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview4.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToReloadData:)];
    
 
    
    return self.tableview4;
}



- (void)getIndexTwoInfomation{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/desc/%@",self.idStr];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//             NSLog(@"******%@",diction);
        [weakSelf.dataArray2 removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)diction;
        for (NSDictionary *dic in arr) {
            Model *model = [Model mj_objectWithKeyValues:dic];
//            NSLog(@"%@---%@",model.attrCode,model.attrValue);
            [weakSelf.dataArray2 addObject:model];
        }
        [weakSelf.tableview3 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)getIndexOneInfomation{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/img/%@",self.idStr];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",diction);
        [weakSelf.dataArray1 removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)diction;
        for (NSDictionary *dic in arr) {
            Model *model = [Model mj_objectWithKeyValues:dic];
            [weakSelf.dataArray1 addObject:model];
        }
        
        [weakSelf.tableview2 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview2]) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (Model *mo in self.dataArray1) {
            [arr addObject:NSString(mo.imgUrl)];
        }
        LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:(NSArray *)arr currentIndex:indexPath.row];
        photoBrowser.delegate = self;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview2]) {
        if (imgheight == 0) {
            imgheight = 250;
        }
        return imgheight;
    }else
    if ([tableView isEqual:self.tableview3]) {
        return 60;
    }
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableview2]) {
        return self.dataArray1.count;
    }else
    if ([tableView isEqual:self.tableview3]) {
        return self.dataArray2.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview1]) {
        static NSString *identifierCell = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([tableView isEqual:self.tableview2]) {
        static NSString *identifierCell = @"cell2";
        BigImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[BigImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        Model *model = [self.dataArray1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.imgUrl)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            self->imgheight = SCREEN_WIDTH/size.width*size.height;
        }];
        
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:NSString(model.imgUrl)]];
//        UIImage *image = [UIImage imageWithData:data];
//        CGSize size = image.size;
//        imgheight = SCREEN_WIDTH/size.width*size.height;
//        [cell.img sd_setImageWithURL:[NSURL URLWithString:NSString(model.imgUrl)] placeholderImage:[UIImage imageNamed:@""]];
        return cell;
    }
    if ([tableView isEqual:self.tableview3]) {
        static NSString *identifierCell = @"cell3";
        BiaogeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[BiaogeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Model *model = [self.dataArray2 objectAtIndex:indexPath.row];
        cell.lab1.text = model.attrCode;
        cell.lab2.text = model.attrValue;
        cell.lab1.numberOfLines = 0;
        cell.lab2.numberOfLines = 0;
        return cell;
    }
    static NSString *identifierCell = @"cell4";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"44444";
    return cell;
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

- (NSMutableArray *)dataArray3{
    if (_dataArray3 == nil) {
        self.dataArray3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray3;
}


@end
