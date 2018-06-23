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


#import "LZProductDetails.h"

@interface ProductXiangqingViewController ()<FrankDetailDropDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate, UIScrollViewDelegate , UIWebViewDelegate,SelectAttributesDelegate,LLPhotoBrowserDelegate>
{
    CAGradientLayer *_gradientLayer;
    
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
    UILabel *activityNameLab;
    UILabel *activityPriceLab;
    UILabel *line1;
    
    UILabel *guigeLab;
    UIImageView *guigeimg;
    UIButton *guigeBtn;
    UILabel *line2;
    
    NSMutableArray *afe;
    NSMutableArray *abc;
    
    CGFloat titleHeight;
    
    UISegmentedControl *segment;
    
    UIButton *btn2;
    
}


@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)NSArray *standardList;
@property(nonatomic,strong)NSArray *standardValueList;

@property(nonatomic,strong)NSMutableArray *kucunArray;;

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *lunboArray;

@property(nonatomic,strong)LZProductDetails *detailsV;

@property (nonatomic, strong) FrankDropBounsView * dropView;
@property (nonatomic, strong) UILabel * tabbarView;


@property (nonatomic, strong) UITableView * tableview1;
@property (nonatomic, strong) UITableView * tableview2;
@property (nonatomic, strong) UITableView * tableview3;
@property (nonatomic, strong) UITableView * tableview4;

@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;



@property(nonatomic,strong)NSMutableArray *cuxiaoArr;




@end

@implementation ProductXiangqingViewController
- (NSMutableArray *)cuxiaoArr{
    if (_cuxiaoArr == nil) {
        self.cuxiaoArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _cuxiaoArr;
}









- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"宝贝";
    
    UIImage *theImage1 = [UIImage imageNamed:@"3"];
    UIView *ve = [[UIView alloc]initWithFrame:CGRectMake(0, [Manager returnDianchitiaoHeight], 44, 44)];
    ve.userInteractionEnabled = YES;
    UIButton * readerBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
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
    
    
    
    
    headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 580)];
    self.tableview1.tableHeaderView = headerV;
    
    footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableview1.tableFooterView = footerV;
    
    
    
    
    
    
    titleLab = [[UILabel alloc]init];
    titleLab.numberOfLines = 0;
    [headerV addSubview:titleLab];
    priceLab = [[UILabel alloc]init];
    priceLab.textColor = [UIColor redColor];
    [headerV addSubview:priceLab];
    
    activityNameLab = [[UILabel alloc]init];
    activityNameLab.textColor = [UIColor blackColor];
    activityNameLab.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:activityNameLab];
    
    activityPriceLab = [[UILabel alloc]init];
    activityPriceLab.textColor = [UIColor redColor];
    activityPriceLab.textAlignment = NSTextAlignmentLeft;
    [headerV addSubview:activityPriceLab];
    
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
    
    
    
//    LRWeakSelf(self)
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [weakSelf getDetailsInfo];
//        [weakSelf getIndexOneInfomation];
//        [weakSelf getIndexTwoInfomation];
//                //通知主线程刷新
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableview1 reloadData];
//                });
//    });
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
    self.selectView.LB_detail.text = @"";
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
    
    
    self.selectView.mainscrollview.contentSize = CGSizeMake(0, [Manager sharedManager].gouwuNumHeight+130);
    //加入购物车按钮
    [self.selectView.addBtn addTarget:self action:@selector(addGoodsCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //立即购买
    [self.selectView.buyBtn addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    [self.selectView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.selectView.alphaView addGestureRecognizer:tap];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, [Manager sharedManager].gouwuNumHeight+10, 90, 40)];
    lab.text = @"购买数量：";
    [self.selectView.mainscrollview addSubview:lab];

    HJCAjustNumButton *btn = [[HJCAjustNumButton alloc] init];
    btn.frame = CGRectMake(100, [Manager sharedManager].gouwuNumHeight+10, 150, 40);
    btn.callBack = ^(NSString *currentNum){
        self->productnumber = currentNum;
    };
    [self.selectView.mainscrollview addSubview:btn];
    [self.selectView.mainscrollview bringSubviewToFront:btn];
    
    
}


-(void)cllll:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"加入购物车"]){
        if ([Manager judgeWhetherIsEmptyAnyObject:[Manager redingwenjianming:@"token.text"]] != YES) {
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }else{
            if (stringID.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择商品属性" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self addCurt];
            }
        }
    }
}
-(void)addGoodsCartBtnClick{
    if ([self.selectView.addBtn.titleLabel.text isEqualToString:@"加入购物车"]) {
        if (productCanshu.length > 0 && stringID.length > 0) {
            [self addCurt];
        }else{
            if (productCanshu.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择商品属性" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            if (stringID.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂无该商品" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}
- (void)addCurt{
     LRWeakSelf(self);
    NSDictionary *dic = @{@"productItemId":stringID,
                          @"quantity":productnumber};
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/shopping/add") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            [weakSelf dismiss];
            [weakSelf TextButtonAction];
        }else  if ([code isEqualToString:@"401"]){
            [Manager logout];
            LoginViewController *login = [[LoginViewController alloc]init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:login animated:YES completion:nil];
        }
    } enError:^(NSError *error) {
        NSLog(@"=-=-====%@",error);
    }];
    
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
    activityPriceLab.text= @"";
    activityNameLab.text= @"";
    [arr_sID removeAllObjects];
    [self.attributesArray removeAllObjects];
    stringID = @"";
    stringPrice = @"";
    stringStatus = @"";
    stringImg = @"";
    itemNo = @"";
    priceLab.text = @"";
    self.selectView.LB_price.text = @"";
    self.selectView.LB_detail.text = @"";
    self.selectView.LB_showSales.text = @"";
    self.selectView.LB_kucun.text= @"";
    
    
    
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
                                [afe replaceObjectAtIndex:i withObject:[dic_sID objectForKey:view.selectBtn.titleLabel.text]];
                                [abc replaceObjectAtIndex:i withObject:view.selectBtn.titleLabel.text];
                                st = [afe componentsJoinedByString:@","];
                                
                                priceLab.text = @"";
                                self.selectView.LB_price.text = @"";
                                self.selectView.LB_detail.text = @"";
                                self.selectView.LB_showSales.text = @"";
                                self.selectView.LB_kucun.text= @"";
                                self.selectView.LB_stock.text = @"";
                                self.selectView.headImage.image = [UIImage imageNamed:@"yxj"];
                                stringID = @"";
                                
                                
                                for (NSDictionary *dict in productItemList_Arr) {
                                    if ([[dict objectForKey:@"productModelAttrs"]isEqualToString:st]) {
                                        stringID = [dict objectForKey:@"id"];
                                        stringPrice = [dict objectForKey:@"salePrice"];
                                        stringStatus = [dict objectForKey:@"status"];
                                        stringImg = [dict objectForKey:@"listImg"];
                                        itemNo = [dict objectForKey:@"itemNo"];
                                        self.selectView.LB_kucun.text= @"库存:0";
                                        
                                        
                                        if (self.kucunArray>0) {
                                            for (Model *model in self.kucunArray) {
                                                if ([model.skuId isEqualToString:self->stringID]) {
                                                    if ([model.quantity integerValue]-[model.lockQuantity integerValue] > 0) {
                                                        [self.selectView.addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
                                                        [btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
                                                        self.selectView.LB_kucun.text= [NSString stringWithFormat:@"库存:%ld",[model.quantity integerValue]-[model.lockQuantity integerValue]];
                                                        
                                                    }else{
                                                        [self.selectView.addBtn setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                                                        [btn2 setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                                                        self.selectView.LB_kucun.text= @"库存:0";
                                                    }
                                                }
                                            }
                                        }else{
                                            [self.selectView.addBtn setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                                            [btn2 setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                                            self.selectView.LB_kucun.text= @"库存:0";
                                        }
                                        
                                        
                                        if ([stringPrice floatValue]>0) {
                                            self.selectView.LB_price.text = [Manager jinegeshi:stringPrice];
                                            priceLab.text = [Manager jinegeshi:stringPrice];
                                        }else{
                                            self.selectView.LB_price.text = @"";
                                            priceLab.text = @"";
                                        }
                                        
                                        self.selectView.LB_stock.text = itemNo;
                                        //self.selectView.LB_showSales.text=stringStatus;
                                        [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]placeholderImage:[UIImage imageNamed:@"zw"]];
                                        
                                        break;
                                    }
                                }
                                
                                
                                
//                                NSLog(@"-----%@",stringID);
                                
                                
//                                if (stringID.length <=0){
//                                    if ([stringPrice floatValue]>0) {
//                                        self.selectView.LB_price.text = [Manager jinegeshi:stringPrice];
//                                        priceLab.text = [Manager jinegeshi:stringPrice];
//                                    }else{
//                                        self.selectView.LB_price.text = @"";
//                                        priceLab.text = @"";
//                                    }
//
//                                    self.selectView.LB_stock.text = itemNo;
//                                    //self.selectView.LB_showSales.text=stringStatus;
//
//                                    [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]placeholderImage:[UIImage imageNamed:@"zw"]];
//                                }else{
//                                    if ([stringPrice floatValue]>0) {
//                                        self.selectView.LB_price.text = [Manager jinegeshi:stringPrice];
//                                        priceLab.text = [Manager jinegeshi:stringPrice];
//                                    }else{
//                                        self.selectView.LB_price.text = @"";
//                                        priceLab.text = @"";
//                                    }
//
//                                    self.selectView.LB_stock.text = itemNo;
//                                    [self.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString(stringImg)]];
//                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    productCanshu = [abc componentsJoinedByString:@","];
    
    if (productCanshu == nil) {
        guigeLab.text = @"请选择规格属性";
    }else{
        guigeLab.text = [NSString stringWithFormat:@"已选：%@",productCanshu];
    }
    
    
    
   
    
    
    
    for (Model *model in self.cuxiaoArr) {
        //NSLog(@"%@----%@",stringID,model.productItemId);
        if ([model.productItemId isEqualToString:stringID]) {
            activityNameLab.text =model.activityName;
            activityPriceLab.text = [Manager jinegeshi:model.onSalePrice];
            
            self.selectView.LB_showSales.text = model.activityName;
            self.selectView.LB_detail.text= [Manager jinegeshi:model.onSalePrice];
            
            
            NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString: self.selectView.LB_price.text attributes:attribtDic2];
            self.selectView.LB_price.attributedText = attribtStr2;
            
            
            NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString: priceLab.text attributes:attribtDic1];
            priceLab.attributedText = attribtStr1;
        }
    }
    
    
}

- (void)getDetailsInfo{
   
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"product/%@",self.idStr];
    NSString *utf = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Manager requestPOSTWithURLStr:KURLNSString(utf) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
//        NSLog(@"******%@",diction);
        NSString *videoId;
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            //库存
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"inventory"]] == YES) {
                NSMutableArray *arrs = [[diction objectForKey:@"object"]objectForKey:@"inventory"];
                [weakSelf.kucunArray removeAllObjects];
                for (NSDictionary *diccc in arrs) {
                    Model *model = [Model mj_objectWithKeyValues:diccc];
                    [weakSelf.kucunArray addObject:model];
                }
            }
            //轮播图
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"productImageList"]] == YES) {
                NSMutableArray *arr = [[diction objectForKey:@"object"]objectForKey:@"productImageList"];
                [weakSelf.lunboArray removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.lunboArray addObject:model];
                }
            }
            //-------------
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"promotions"]] == YES) {
                NSMutableArray *arr = [[diction objectForKey:@"object"]objectForKey:@"promotions"];
                [weakSelf.cuxiaoArr removeAllObjects];
                for (NSDictionary *dicc in arr) {
                    Model *model = [Model mj_objectWithKeyValues:dicc];
                    [weakSelf.cuxiaoArr addObject:model];
                }
            }
            
            
            //----------------
            self->productItemList_Arr = [[diction objectForKey:@"object"]objectForKey:@"productItemList"];
            NSMutableArray *attrList = [[diction objectForKey:@"object"]objectForKey:@"productAttrList"];
            NSMutableArray *attrList_a = [NSMutableArray arrayWithCapacity:1];
            NSMutableArray *attrList_b = [NSMutableArray arrayWithCapacity:1];
            self->arr_sID = [NSMutableArray arrayWithCapacity:1];
            self->dic_sID = [NSMutableDictionary dictionaryWithCapacity:1];
            self->abc = [NSMutableArray arrayWithCapacity:1];
            NSString *string;
            self->afe = [NSMutableArray arrayWithCapacity:1];
            
            
            
            
            for (int k = 0; k<attrList.count; k++) {
                NSDictionary *dic = attrList[k];
                [attrList_a addObject:[[dic objectForKey:@"attrKey"] objectForKey:@"catalogAttrValue"]];
                NSMutableArray *aaa = [dic objectForKey:@"attrValues"];
                
                self->arr = [NSMutableArray arrayWithCapacity:1];
                NSDictionary *dict1 = [aaa firstObject];
                //NSLog(@"******%@",[dict1 objectForKey:@"modelAttrValue"]);
                [self->abc addObject:[dict1 objectForKey:@"modelAttrValue"]];
                
                for (int i = 0; i<aaa.count; i++) {
                    NSDictionary *dicts = aaa[i];
                    
                    
                    [self->arr addObject:[dicts objectForKey:@"modelAttrValue"]];
                    [self->dic_sID setValue:[dicts objectForKey:@"id"] forKey:[dicts objectForKey:@"modelAttrValue"]];
                    if (i==0) {
                        [self->afe addObject:[dicts objectForKey:@"id"]];
                    }
                }
                [attrList_b addObject:self->arr];
            }
            string = [self->afe componentsJoinedByString:@","];
            
            
            
            
            
            
            
            self->productCanshu = [self->abc componentsJoinedByString:@","];
            self->guigeLab.text = [NSString stringWithFormat:@"已选：%@",self->productCanshu];
            
            
            weakSelf.standardList = attrList_a;
            weakSelf.standardValueList = (NSArray *)attrList_b;
            
            if ([Manager judgeWhetherIsEmptyAnyObject:[[diction objectForKey:@"object"]objectForKey:@"product"]] == YES){
                NSDictionary *dicti = [[diction objectForKey:@"object"]objectForKey:@"product"];
                self->titleHeight = [Manager getLabelHeightWithContent:[dicti objectForKey:@"modelName"] andLabelWidth:SCREEN_WIDTH-30 andLabelFontSize:17];
                
                self->titleLab.text = [dicti objectForKey:@"modelName"];
                
                videoId = [dicti objectForKey:@"video"];
                
                self->priceLab.text = [Manager jinegeshi:[dicti objectForKey:@"salePrice"]];
                
                
                
                
                self->titleLab.frame = CGRectMake(5, 10+SCREEN_WIDTH, SCREEN_WIDTH-10, self->titleHeight);
                self->priceLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+10, 100, 20);
                
                self->activityNameLab.frame = CGRectMake(85, 10+SCREEN_WIDTH+self->titleHeight+10, SCREEN_WIDTH-190, 20);
                self->activityPriceLab.frame = CGRectMake(SCREEN_WIDTH-105, 10+SCREEN_WIDTH+self->titleHeight+10, 100, 20);
                
                
                
                self->line1.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+40, SCREEN_WIDTH, 10);
                
                self->guigeLab.frame = CGRectMake(5, 10+SCREEN_WIDTH+self->titleHeight+60, SCREEN_WIDTH-10, 40);
                self->guigeimg.frame = CGRectMake(SCREEN_WIDTH-30, 10+SCREEN_WIDTH+self->titleHeight+70, 20, 20);
                self->guigeBtn.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+50, SCREEN_WIDTH, 55);
                self->line2.frame = CGRectMake(0, 10+SCREEN_WIDTH+self->titleHeight+105, SCREEN_WIDTH, 5);
                
                [weakSelf initSelectView];
                
//                NSDictionary *dicc = [self->productItemList_Arr lastObject];
                for (NSDictionary *dicc in self->productItemList_Arr) {
                    if ([[dicc objectForKey:@"productModelAttrs"] isEqualToString:string]) {
                        [weakSelf.selectView.headImage sd_setImageWithURL:[NSURL URLWithString:NSString([dicc objectForKey:@"listImg"])]placeholderImage:[UIImage imageNamed:@"zw"]];
                        
//                        NSLog(@"---%@",NSString([dicc objectForKey:@"listImg"]));
                        
                        weakSelf.selectView.LB_price.text = [Manager jinegeshi:[dicc objectForKey:@"salePrice"]];
                        weakSelf.selectView.LB_stock.text = [dicc objectForKey:@"itemNo"];
                        //weakSelf.selectView.LB_showSales.text=[dicc objectForKey:@"status"];
                        self->stringID = [dicc objectForKey:@"id"];
                    }
                }
                
                
            }
        }
    
        
        if (self.kucunArray.count > 0) {
            for (Model *model in self.kucunArray) {
                if ([model.skuId isEqualToString:self->stringID]) {
                    if ([model.quantity integerValue]-[model.lockQuantity integerValue] > 0) {
                        [weakSelf.selectView.addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
                        [self->btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
                        weakSelf.selectView.LB_kucun.text= [NSString stringWithFormat:@"库存:%ld",[model.quantity integerValue]-[model.lockQuantity integerValue]];
                    }else{
                        [weakSelf.selectView.addBtn setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                        [self->btn2 setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
                        weakSelf.selectView.LB_kucun.text= @"库存:0";
                    }
                }
            }
        }else{
            [weakSelf.selectView.addBtn setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
            [self->btn2 setTitle:@"暂缺货，您可以选择其他规格" forState:UIControlStateNormal];
            weakSelf.selectView.LB_kucun.text= @"库存:0";
        }
        
        if (self->stringID.length <= 0) {
             weakSelf.selectView.LB_price.text = @"";
             weakSelf.selectView.LB_kucun.text= @"";
            weakSelf.selectView.headImage.image = [UIImage imageNamed:@"yxj"];
        }
        
        for (Model *model in self.cuxiaoArr) {
            //NSLog(@"%@----%@",stringID,model.productItemId);
            if ([model.productItemId isEqualToString:self->stringID]) {
                self->activityNameLab.text =model.activityName;
                self->activityPriceLab.text = [Manager jinegeshi:model.onSalePrice];
                
                weakSelf.selectView.LB_showSales.text = model.activityName;
                weakSelf.selectView.LB_detail.text= [Manager jinegeshi:model.onSalePrice];
                
                NSDictionary *attribtDic2 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString: weakSelf.selectView.LB_price.text attributes:attribtDic2];
                weakSelf.selectView.LB_price.attributedText = attribtStr2;
                
                NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString: self->priceLab.text attributes:attribtDic1];
                self->priceLab.attributedText = attribtStr1;
            }
        }
        
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        [array removeAllObjects];
        for (Model *mo in weakSelf.lunboArray) {
            [array addObject:NSString(mo.listImg)];
        }

        if (videoId.length > 0) {
            self.detailsV = [[LZProductDetails alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
            [self->headerV addSubview:self.detailsV];
            __weak typeof(self) weakSelf = self;
            self.detailsV.scrollOptBlock = ^(NSInteger index) {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                [array removeAllObjects];
                for (Model *mo in weakSelf.lunboArray) {
                    [array addObject:NSString(mo.listImg)];
                }
                LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:(NSArray *)array currentIndex:index-1];
                photoBrowser.delegate = weakSelf;
                [weakSelf presentViewController:photoBrowser animated:YES completion:nil];
            };
            [array insertObject:videoId atIndex:0];
            [weakSelf.detailsV updateUIWithImageAndVideoArray:array];
        }else{
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
            self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
            [self->headerV addSubview:self.cycleScrollView];
            if (array.count>0) {
                weakSelf.cycleScrollView.localizationImageNamesGroup = array;
            }
        }
        
        [weakSelf.tableview1 reloadData];
    } enError:^(NSError *error) {
        NSLog(@"------%@",error);
    }];
}











// 只显示文字
- (void)TextButtonAction{
    MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.text =@"已加入购物车";
    UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dui"]];
    [hud setCustomView:imageview];
    [hud setMode:MBProgressHUDModeCustomView];
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}







#pragma mark --弹出规格属性
-(void)chooseViewClick{
        [UIView animateWithDuration: 0.35 animations: ^{
            self.backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.selectView.frame =CGRectMake(0, 0, screen_Width, screen_Height);
        } completion: nil];
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
//            NSLog(@"%@---%@",productCanshu,stringID);
        }else{
            if (productCanshu.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择商品属性" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            if (stringID.length <=0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂无该商品" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
    self.tabBarController.selectedIndex = 2;
}

















- (void)viewLayoutMarginsDidChange{
    [super viewLayoutMarginsDidChange];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 消除导航影响
    [self.dropView viewControllerWillAppear];
    self.tabBarController.tabBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    // 消除导航影响
    [self.dropView viewControllerWillDisappear];
    
   [[UIApplication sharedApplication] setStatusBarHidden:NO];

//    [self.detailsV.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}


- (UILabel *)tabbarView{
    
    if (!_tabbarView) {
        _tabbarView = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        _tabbarView.textAlignment = NSTextAlignmentCenter;
        
        _tabbarView.userInteractionEnabled = YES;
        
        
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
//        btn1.backgroundColor = [UIColor redColor];
//        [btn1 setTitle:@"立即购买" forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(cilck1) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn1];
        
        
        
//        NSMutableArray *colorArray2 = [@[[UIColor colorWithRed:255 green:69 blue:0 alpha:0],[UIColor colorWithRed:255 green:140 blue:0 alpha:1]] mutableCopy];
//        ColorButton *btn2 = [[ColorButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-240, 0, 120, 55) FromColorArray:colorArray2 ByGradientType:uprightTolowLeft];
//        [btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(cllll) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn2];
        
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        btn2.backgroundColor = [UIColor redColor];
        [btn2 setTitle:@"加入购物车" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(cllll:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = btn2.bounds;
        _gradientLayer.borderWidth = 0;
        _gradientLayer.frame = btn2.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)RGBACOLOR(220, 20, 60, 1.0).CGColor,
                                 (id)RGBACOLOR(255, 0, 0, 1.0).CGColor, nil ,nil];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint   = CGPointMake(1.0, 1.0);
        [btn2.layer insertSublayer:_gradientLayer atIndex:0];
        
        
        
        [_tabbarView addSubview:btn2];
        
        
        
//        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn3.frame = CGRectMake((SCREEN_WIDTH-260)/2+10, 0, (SCREEN_WIDTH-260)/2, 55);
//        [btn3 setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
//        btn3.backgroundColor = [UIColor whiteColor];
//        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn3 addTarget:self action:@selector(cilck3) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn3];
//
//        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn4.frame = CGRectMake(10, 0, (SCREEN_WIDTH-260)/2, 55);
//        [btn4 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
//        btn4.backgroundColor = [UIColor whiteColor];
//        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn4 addTarget:self action:@selector(cilck4) forControlEvents:UIControlEventTouchUpInside];
//        [_tabbarView addSubview:btn4];
        
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
    //NSLog(@"--- 下拉");
    [self.dropView showTopPageViewWithCompleteBlock:^{
        [table endRefreshing];
    }];
}
- (void)pullUpToReloadMoreData:(MJRefreshBackNormalFooter *)table{
    //NSLog(@"--- 上拉");
    [self.tableview2 reloadData];
    
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
    return @[@"图文详情",@"规格参数",@"评价(0)"];
}
/**
 自定义底部展示视图模块 代理方法
 */
- (UIView *)resetBottomViewsWithIndex:(NSInteger)index{
    
    if (index == 1) {
        self.tableview2 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableview2.delegate = self;
        self.tableview2.dataSource = self;
//        [self.tableview2 registerNib:[UINib nibWithNibName:@"BigImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        
        [self.tableview2 registerClass:[FLAnimatideImgCell class] forCellReuseIdentifier:@"cell2"];
        
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
        return imgheight;
    }else if ([tableView isEqual:self.tableview3]) {
        return 60;
    }else if ([tableView isEqual:self.tableview4]) {
        return 100;
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
    if ([tableView isEqual:self.tableview4]) {
        return self.dataArray3.count;
    }
    return 0;
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
        FLAnimatideImgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil) {
            cell = [[FLAnimatideImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        Model *model = [self.dataArray1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:NSString(model.imgUrl)]];
//        SDImageCache* cache = [SDImageCache sharedImageCache];
//        //此方法会先从memory中取。
//        cell.flanimatedImgView.image = [cache imageFromDiskCacheForKey:key];
        
        
        
        
        [cell.flanimatedImgView sd_setImageWithURL:[NSURL URLWithString:NSString(model.imgUrl)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            self->imgheight = SCREEN_WIDTH/size.width*size.height;
            cell.flanimatedImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self->imgheight);
        }];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:NSString(model.imgUrl)]]];
            [cell.flanimatedImgView setAnimatedImage:animatedImg];
        });
        
        
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
    
    
    return cell;
}








- (NSMutableArray *)lunboArray{
    if (_lunboArray == nil) {
        self.lunboArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _lunboArray;
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
- (NSMutableArray *)kucunArray{
    if (_kucunArray == nil) {
        self.kucunArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _kucunArray;
}

@end
