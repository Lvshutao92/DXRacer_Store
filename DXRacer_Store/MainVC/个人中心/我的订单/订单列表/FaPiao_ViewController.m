//
//  FaPiao_ViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/5.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "FaPiao_ViewController.h"
#import "XFTreePopupView.h"
@interface FaPiao_ViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
    UITextField *text1;
    UITextField *text2;
    UITextField *text3;
    
    UILabel *lab4;
    UILabel *lab5;
    UILabel *lab6;
    UILabel *line4;
    UILabel *line5;
    UILabel *line6;
    UITextField *text4;
    UITextField *text5;
    UITextField *text6;
    
    
    UILabel *lab7;
    UILabel *line7;
    UITextField *text7;
    
    UILabel *lab8;
    UILabel *line8;
    UITextView *textView8;
    
    UILabel *lab9;
    UILabel *line9;
    UITextField *text9;
    
    UILabel *lab10;
    UILabel *line10;
    UITextField *text10;
    
    UILabel *lab11;
    UILabel *line11;
    UITextView *textView11;
    
    UIButton *comitbtn;
}
@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)NSMutableArray *addrArray;
@end

@implementation FaPiao_ViewController
- (NSMutableArray *)addrArray{
    if (_addrArray == nil) {
        self.addrArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _addrArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    
    [self.view addSubview:self.scrollview];
    
    comitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comitbtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    comitbtn.backgroundColor = RGBACOLOR(49, 184, 243, 1);
    [comitbtn setTitle:@"提交" forState:UIControlStateNormal];
    [comitbtn addTarget:self action:@selector(clicksave) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"------%@",self.status);
    if (![self.status isEqualToString:@"created"]) {
        comitbtn.hidden = YES;
    }else{
        comitbtn.hidden = NO;
    }
    [self.view addSubview:comitbtn];
    
    [self lodaddr];
    
    [self setupview];
}


- (void)lodaddr{
    __weak typeof (self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"common/address") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        weakSelf.addrArray = (NSMutableArray *)diction;
    } enError:^(NSError *error) {
    }];
}




- (void)clicksave{
    
    if ([text3.text isEqualToString:@"增值税普通发票"]) {
        if ([Manager judgeWhetherIsEmptyAnyObject:text2.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:str1]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:str2]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:textView8.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text9.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text10.text]==YES) {
            [self save];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"所有信息不能为空" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        if ([Manager judgeWhetherIsEmptyAnyObject:text2.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text4.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text5.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text6.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:str1]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:str2]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:textView8.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:textView11.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text9.text]==YES &&
            [Manager judgeWhetherIsEmptyAnyObject:text10.text]==YES) {
            [self save];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"所有信息不能为空" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


- (void)save{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"orderNo":text1.text,
                          @"invoiceTitle":text2.text,
                          @"invoiceType":text3.text,
                          @"bankName":text4.text,
                          @"bankNo":text5.text,
                          @"invoiceCode":text6.text,
                          
                          @"receiveProvince":str1,
                          @"receiveCity":str2,
                          @"receiveDistrict":str3,
                          @"receiveAddress":textView8.text,
                          @"receivePerson":text9.text,
                          @"receivePhone":text10.text,
                          @"registerAddress":textView11.text,
                          };
//    NSLog(@"6666666------%@",dic);
    [Manager requestPOSTWithURLStr:KURLNSString(@"order/invoice/save") paramDic:dic token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"------%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑完成✅" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑失败" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } enError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
























- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    LRWeakSelf(self);
    if ([textField isEqual:text1]) {
        [self textresoponse];
        return NO;
    }else if ([textField isEqual:text3]) {
        [self textresoponse];
        EasyAlertView *alertV = [EasyAlertView alertViewWithPart:^EasyAlertPart *{
            return [EasyAlertPart shared].setTitle(@"发票类型").setSubtitle(@"").setAlertType(AlertViewTypeActionSheet) ;
        } config:nil buttonArray:nil callback:^(EasyAlertView *showview, long index) {
            if (index == 0) {
                self->text3.text = @"增值税普通发票";
                [weakSelf putong];
            }
            if (index == 1) {
                self->text3.text = @"增值税专用发票";
                [weakSelf zhuanyong];
            }
        }];
        [alertV addAlertItemWithTitleArray:@[@"增值税普通发票",@"增值税专用发票"] callback:nil];
        [alertV addAlertItem:^EasyAlertItem *{
            return [EasyAlertItem itemWithTitle:@"取消" type:AlertItemTypeBlodRed callback:^(EasyAlertView *showview, long index) {
            }];
        }];
        [alertV showAlertView];
        return NO;
    }else if ([textField isEqual:text7]){
        [self textresoponse];
        if (self.addrArray.count > 0) {
            
            XFTreePopupView *treeView = [[XFTreePopupView alloc]initWithDataSource:self.addrArray Commit:^(NSArray *ret)
                                         {
                                             self->str1 = @"";
                                             self->str2 = @"";
                                             self->str3 = @"";
                                             for (int i = 0; i<ret.count; i++) {
                                                 NSDictionary *dict = ret[i];
                                                 if (i == 0) {
                                                     self->str1 = [dict objectForKey:@"value"];
                                                 }
                                                 if (i == 1) {
                                                     self->str2 = [dict objectForKey:@"value"];
                                                 }
                                                 if (ret.count == 3) {
                                                     if (i == 2) {
                                                         self->str3 = [dict objectForKey:@"value"];
                                                     }
                                                 }
                                             }
                                             if (self->str3.length > 0) {
                                                 self->text7.text = [NSString stringWithFormat:@"%@-%@-%@",self->str1,self->str2,self->str3];
                                             }else{
                                                 self->text7.text = [NSString stringWithFormat:@"%@-%@",self->str1,self->str2];
                                             }
                                         }];
            treeView.isHidden = NO;
        }
        return NO;
    }
    return YES;
}










- (void)putong{
    [self yes];
    lab7.frame  = CGRectMake(10, 160, 130, 39);
    text7.frame = CGRectMake(140, 160, SCREEN_WIDTH-150, 39);
    line7.frame = CGRectMake(140, 199, SCREEN_WIDTH-150, 1);
    
    lab8.frame  = CGRectMake(10, 210, 130, 39);
    textView8.frame = CGRectMake(140, 210, SCREEN_WIDTH-150, 39);
    line8.frame = CGRectMake(140, 249, SCREEN_WIDTH-150, 1);
    
    lab9.frame  = CGRectMake(10, 260, 130, 39);
    text9.frame = CGRectMake(140, 260, SCREEN_WIDTH-150, 39);
    line9.frame = CGRectMake(140, 299, SCREEN_WIDTH-150, 1);
    
    lab10.frame  = CGRectMake(10, 310, 130, 39);
    text10.frame = CGRectMake(140, 310, SCREEN_WIDTH-150, 39);
    line10.frame = CGRectMake(140, 349, SCREEN_WIDTH-150, 1);
    
  
    self.scrollview.contentSize = CGSizeMake(0, 450);
   
}
- (void)zhuanyong{
    [self no];
    lab7.frame  = CGRectMake(10, 350, 130, 39);
    text7.frame = CGRectMake(140, 350, SCREEN_WIDTH-150, 39);
    line7.frame = CGRectMake(140, 389, SCREEN_WIDTH-150, 1);
    
    lab8.frame  = CGRectMake(10, 400, 130, 39);
    textView8.frame = CGRectMake(140, 400, SCREEN_WIDTH-150, 39);
    line8.frame = CGRectMake(140, 439, SCREEN_WIDTH-150, 1);
    
    lab9.frame  = CGRectMake(10, 450, 130, 39);
    text9.frame = CGRectMake(140, 450, SCREEN_WIDTH-150, 39);
    line9.frame = CGRectMake(140, 489, SCREEN_WIDTH-150, 1);
    
    lab10.frame  = CGRectMake(10, 500, 130, 39);
    text10.frame = CGRectMake(140, 500, SCREEN_WIDTH-150, 39);
    line10.frame = CGRectMake(140, 539, SCREEN_WIDTH-150, 1);
    
    self.scrollview.contentSize = CGSizeMake(0, 600);
}




















- (void)setupview{
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 39)];
    lab1.text = @"订单编号:";
    [self.scrollview addSubview:lab1];
    text1 = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, SCREEN_WIDTH-150, 39)];
    text1.delegate = self;
    text1.text = self.orderNo;
    [self.scrollview addSubview:text1];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 49, SCREEN_WIDTH-150, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 130, 39)];
    lab2.text = @"发票抬头:";
    [self.scrollview addSubview:lab2];
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(140, 60, SCREEN_WIDTH-150, 39)];
    text2.delegate = self;
//    text2.placeholder = @"请输入发票抬头";
    [self.scrollview addSubview:text2];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 99, SCREEN_WIDTH-150, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line2];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 130, 39)];
    lab3.text = @"发票类型:";
    [self.scrollview addSubview:lab3];
    text3 = [[UITextField alloc]initWithFrame:CGRectMake(140, 110, SCREEN_WIDTH-150, 39)];
    text3.delegate = self;
    text3.text = @"增值税普通发票";
    [self.scrollview addSubview:text3];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(140, 149, SCREEN_WIDTH-150, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line3];
    
    
    
    lab4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 130, 39)];
    lab4.text = @"开户行名称:";
    [self.scrollview addSubview:lab4];
    text4 = [[UITextField alloc]initWithFrame:CGRectMake(140, 160, SCREEN_WIDTH-150, 39)];
    text4.delegate = self;
//    text4.placeholder = @"请输入开户行名称";
    [self.scrollview addSubview:text4];
    line4 = [[UILabel alloc]initWithFrame:CGRectMake(140, 199, SCREEN_WIDTH-150, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line4];
    
    lab5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 130, 39)];
    lab5.text = @"银行账号:";
    [self.scrollview addSubview:lab5];
    text5 = [[UITextField alloc]initWithFrame:CGRectMake(140, 210, SCREEN_WIDTH-150, 39)];
    text5.delegate = self;
//    text5.placeholder = @"请输入银行账号";
    [self.scrollview addSubview:text5];
    line5 = [[UILabel alloc]initWithFrame:CGRectMake(140, 249, SCREEN_WIDTH-150, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line5];
    
    lab6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 260, 130, 39)];
    lab6.text = @"纳税人识别码:";
    [self.scrollview addSubview:lab6];
    text6 = [[UITextField alloc]initWithFrame:CGRectMake(140, 260, SCREEN_WIDTH-150, 39)];
    text6.delegate = self;
//    text6.placeholder = @"请输入纳税人识别码";
    [self.scrollview addSubview:text6];
    line6 = [[UILabel alloc]initWithFrame:CGRectMake(140, 299, SCREEN_WIDTH-150, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line6];
    
    
    lab11 = [[UILabel alloc]initWithFrame:CGRectMake(10, 310, 130, 39)];
    lab11.text = @"注册地址:";
    [self.scrollview addSubview:lab11];
    textView11 = [[UITextView alloc]initWithFrame:CGRectMake(140, 310, SCREEN_WIDTH-150, 39)];
    textView11.delegate = self;
    textView11.font = [UIFont systemFontOfSize:16];
    //textView11.placeholder = @"请输入注册地址";
    [self.scrollview addSubview:textView11];
    line11 = [[UILabel alloc]initWithFrame:CGRectMake(140,349, SCREEN_WIDTH-150, 1)];
    line11.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line11];
    
    
    
    
    
    lab7 = [[UILabel alloc]init];
    lab7.text = @"省市区:";
    [self.scrollview addSubview:lab7];
    text7 = [[UITextField alloc]init];
    text7.delegate = self;
    text7.placeholder = @"请选择省市区";
    [self.scrollview addSubview:text7];
    line7 = [[UILabel alloc]init];
    line7.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line7];
    
    lab8 = [[UILabel alloc]init];
    lab8.text = @"详细地址:";
    [self.scrollview addSubview:lab8];
    textView8 = [[UITextView alloc]init];
    textView8.delegate = self;
    textView8.font = [UIFont systemFontOfSize:16];
//    textView8.placeholder = @"请输入详细地址";
    [self.scrollview addSubview:textView8];
    line8 = [[UILabel alloc]init];
    line8.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line8];
    
    lab9 = [[UILabel alloc]init];
    lab9.text = @"收票人姓名:";
    [self.scrollview addSubview:lab9];
    text9 = [[UITextField alloc]init];
    text9.delegate = self;
//    text9.placeholder = @"请输入收票人姓名";
    [self.scrollview addSubview:text9];
    line9 = [[UILabel alloc]init];
    line9.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line9];
    
    lab10 = [[UILabel alloc]init];
    lab10.text = @"收票人手机:";
    [self.scrollview addSubview:lab10];
    text10 = [[UITextField alloc]init];
    text10.delegate = self;
    text10.keyboardType = UIKeyboardTypeNumberPad;
//    text10.placeholder = @"请输入收票人手机";
    [self.scrollview addSubview:text10];
    line10 = [[UILabel alloc]init];
    line10.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [self.scrollview addSubview:line10];
    
    
    
    
    
    text4.text = @"";
    text5.text = @"";
    text6.text = @"";
    textView11.text = @"";
    str1 = @"";
    str2 = @"";
    str3 = @"";
    
    
    
    text2.text = self.invioceTitle;
    text3.text = self.invioceType;
    str1 = self.receiveProvince;
    str2 = self.receiveCity;
    str3 = self.receiveDistrict;
    text7.text = [NSString stringWithFormat:@"%@-%@-%@",self.receiveProvince,self.receiveCity,self.receiveDistrict];
    textView8.text = self.receiveAddress;
    text9.text = self.receivePerson;
    text10.text = self.receivePhone;
    
    
    
    if ([Manager judgeWhetherIsEmptyAnyObject:self.invioceType] != YES) {
        text3.text = @"增值税普通发票";
    }
    if ([Manager judgeWhetherIsEmptyAnyObject:self.receiveProvince] != YES) {
        text7.text = @"";
    }
    
    
    
    if ([text3.text isEqualToString:@"增值税专用发票"]) {
        text4.text = self.bankName;
        text5.text = self.bankNo;
        text6.text = self.invioceTitle;
        textView11.text = self.registerAddress;
        [self zhuanyong];
    }else{
        [self putong];
    }
    
//    lab1.textColor = [UIColor redColor];
//    lab2.textColor = [UIColor redColor];
//    lab3.textColor = [UIColor redColor];
//    lab4.textColor = [UIColor redColor];
//    lab5.textColor = [UIColor redColor];
//    lab6.textColor = [UIColor redColor];
//
//    lab7.textColor = [UIColor redColor];
//    lab8.textColor = [UIColor redColor];
//    lab9.textColor = [UIColor redColor];
//    lab10.textColor = [UIColor redColor];
//    lab11.textColor = [UIColor redColor];
}


- (void)textresoponse{
    [text2 resignFirstResponder];
    [text4 resignFirstResponder];
    [text5 resignFirstResponder];
    [text6 resignFirstResponder];
    
    [textView8 resignFirstResponder];
    [text9 resignFirstResponder];
    [text10 resignFirstResponder];
    [textView11 resignFirstResponder];
}



- (void)yes{
    lab4.hidden = YES;
    lab5.hidden = YES;
    lab6.hidden = YES;
    
    line4.hidden = YES;
    line5.hidden = YES;
    line6.hidden = YES;
    
    text4.hidden = YES;
    text5.hidden = YES;
    text6.hidden = YES;
    
    line11.hidden = YES;
    textView11.hidden = YES;
    lab11.hidden = YES;
}
- (void)no{
    lab4.hidden = NO;
    lab5.hidden = NO;
    lab6.hidden = NO;
    
    line4.hidden = NO;
    line5.hidden = NO;
    line6.hidden = NO;
    
    text4.hidden = NO;
    text5.hidden = NO;
    text6.hidden = NO;
    
    line11.hidden = NO;
    textView11.hidden = NO;
    lab11.hidden = NO;
}
@end
