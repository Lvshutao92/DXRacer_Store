//
//  AddAddressViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/8.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "AddAddressViewController.h"
#import "XFTreePopupView.h"



@interface AddAddressViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
{
    UITextField  *text1;
    UITextField  *text2;
    UITextField  *text3;
    UITextField  *text4;
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
   
}
@property(nonatomic,strong)UIScrollView *scrollview;
@end
//addre
CG_INLINE CGRect CGRectMakes(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    float secretNum = [[UIScreen mainScreen] bounds].size.width / 375;
    rect.origin.x = x*secretNum; rect.origin.y = y*secretNum;
    rect.size.width = width*secretNum; rect.size.height = height*secretNum;
    
    return rect;
}
@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAddAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
    [self setupview];
}













- (void)clickAddAddress{
    if (str3 == nil) {
        str3 = @"";
    }
    if ([self.navigationItem.title isEqualToString:@"编辑"]){
        [self lodedit];
    }else{
        [self lodadd];
    }
}
- (void)lodadd{
    if (text1.text.length > 0 && text2.text.length > 0 && text4.text.length > 0 && str1.length > 0  && str2.length > 0) {
        __weak typeof (self) weakSelf = self;
        NSDictionary *dict = @{@"person":text1.text,
                               @"phone":text2.text,
                               @"receiveProvince":str1,
                               @"receiveCity":str2,
                               @"receiveDistrict":str3,
                               @"address":text4.text,
                               @"tel":@"",
                               };
        [Manager requestPOSTWithURLStr:KURLNSString(@"address/insert") paramDic:dict token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"----%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
- (void)lodedit{
    if (text1.text.length > 0 && text2.text.length > 0 && text4.text.length > 0 && str1.length > 0  && str2.length > 0) {
        __weak typeof (self) weakSelf = self;
        NSDictionary *dict = @{@"person":text1.text,
                               @"phone":text2.text,
                               @"receiveProvince":str1,
                               @"receiveCity":str2,
                               @"receiveDistrict":str3,
                               @"address":text4.text,
                               @"tel":@"",
                               };
        NSString *str = [NSString stringWithFormat:@"address/update?id=%@",self.idstr];
        [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:dict token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"----%@",diction);
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

















- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:text3]) {
        [text1 resignFirstResponder];
        [text2 resignFirstResponder];
        [text4 resignFirstResponder];
        str1 = @"";
        str2 = @"";
        str3 = @"";
        
        [Manager requestPOSTWithURLStr:KURLNSString(@"common/address") paramDic:nil token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSMutableArray *arr = (NSMutableArray *)diction;
            
            XFTreePopupView *treeView = [[XFTreePopupView alloc]initWithDataSource:arr Commit:^(NSArray *ret)
                                         {
                                             for (int i = 0; i<ret.count; i++) {
                                                 NSDictionary *dict = ret[i];
                                                 
                                                 if (i == 0) {
                                                     self->str1 = [dict objectForKey:@"value"];
                                                     //NSLog(@"111-----%@",[dict objectForKey:@"key"]);
                                                 }
                                                 if (i == 1) {
                                                     self->str2 = [dict objectForKey:@"value"];
                                                     //NSLog(@"222-----%@",[dict objectForKey:@"key"]);
                                                 }
                                                 if (ret.count == 3) {
                                                     if (i == 2) {
                                                         self->str3 = [dict objectForKey:@"value"];
                                                         //NSLog(@"333-----%@",[dict objectForKey:@"key"]);
                                                     }
                                                 }
                                             }
                                             //NSLog(@"%@---%@---%@",self->str1,self->str2,self->str3);
                                             if (self->str3.length > 0) {
                                                 self->text3.text = [NSString stringWithFormat:@"%@-%@-%@",self->str1,self->str2,self->str3];
                                             }else{
                                                 self->text3.text = [NSString stringWithFormat:@"%@-%@",self->str1,self->str2];
                                             }
                                         }];
            
            treeView.isHidden = NO;
            //NSLog(@"----%@",diction);
        } enError:^(NSError *error) {
            
        }];
        
        
        
        
        
        
        
//        NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
//        NSString *path = [mainBundleDirectory stringByAppendingPathComponent:@"ChinaArea.json"];
//        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
//        NSError *err;
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
//        //NSLog(@"--%@",jsonArray);
        
//        XFTreePopupView *treeView = [[XFTreePopupView alloc]initWithDataSource:jsonArray Commit:^(NSArray *ret)
//                                     {
//
//                                         for (int i = 0; i<ret.count; i++) {
//                                             NSDictionary *dict = ret[i];
//                                             if (i == 0) {
//                                                 self->str1 = [dict objectForKey:@"n"];
//                                             }
//                                             if (i == 1) {
//                                                 self->str2 = [dict objectForKey:@"n"];
//                                             }
//                                             if (i == 2) {
//                                                 self->str3 = [dict objectForKey:@"n"];
//                                             }
//                                         }
//                                         //NSLog(@"%@---%@---%@",self->str1,self->str2,self->str3);
//                                         if (self->str3 != nil) {
//                                             self->text3.text = [NSString stringWithFormat:@"%@-%@-%@",self->str1,self->str2,self->str3];
//                                         }else{
//                                             self->text3.text = [NSString stringWithFormat:@"%@-%@",self->str1,self->str2];
//                                         }
////                                         NSString *selectedStr = @"";
////                                         for (NSDictionary *dict in ret)
////                                         {
////                                             selectedStr = [selectedStr stringByAppendingString:[dict objectForKey:@"n"]];
////                                             NSLog(@"---%@",[dict objectForKey:@"n"]);
////                                         }
////                                         //NSLog(@"-------%@",selectedStr);
////                                         self->text3.text = selectedStr;
//                                     }];
//
//        treeView.isHidden = NO;
        return NO;
    }
    return YES;
}




- (void)setupview{
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 88;
    }else{
        hei = 64;
    }
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, 203)];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 50)];
    name1.text = @"收货人";
    name1.textColor = [UIColor grayColor];
    [self.scrollview addSubview:name1];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-80, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.27];
    [self.scrollview addSubview:line1];
    
    
    UILabel *name2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 51, 75, 50)];
    name2.text = @"联系电话";
    name2.textColor = [UIColor grayColor];
    [self.scrollview addSubview:name2];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 101, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.27];
    [self.scrollview addSubview:line2];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-81, 0, 1, 101)];
    lines.backgroundColor = [UIColor colorWithWhite:.8 alpha:.27];
    [self.scrollview addSubview:lines];
    
    
    
    UILabel *name3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 102, 75, 50)];
    name3.text = @"所在地区";
    name3.textColor = [UIColor grayColor];
    [self.scrollview addSubview:name3];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 152, SCREEN_WIDTH, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.8 alpha:.27];
    [self.scrollview addSubview:line3];
    
    UILabel *name4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 153, 75, 50)];
    name4.text = @"详细地址";
    name4.textColor = [UIColor grayColor];
    [self.scrollview addSubview:name4];
   
    
    
    text1 = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-180, 50)];
    text1.delegate = self;
    text1.borderStyle = UITextBorderStyleNone;
    text1.textAlignment = NSTextAlignmentRight;
    [self.scrollview addSubview:text1];
    
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(90, 51, SCREEN_WIDTH-180, 50)];
    text2.delegate = self;
    text2.borderStyle = UITextBorderStyleNone;
    text2.textAlignment = NSTextAlignmentRight;
    text2.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollview addSubview:text2];
    
    
    
    text3 = [[UITextField alloc]initWithFrame:CGRectMake(90, 102, SCREEN_WIDTH-100, 50)];
    text3.delegate = self;
    text3.borderStyle = UITextBorderStyleNone;
    text3.textAlignment = NSTextAlignmentRight;
    text3.placeholder = @"请选择 〉";
    [self.scrollview addSubview:text3];
    
    text4 = [[UITextField alloc]initWithFrame:CGRectMake(90, 153, SCREEN_WIDTH-100, 50)];
    text4.delegate = self;
    text4.placeholder = @"街道、楼牌号等";
    text4.borderStyle = UITextBorderStyleNone;
    text4.textAlignment = NSTextAlignmentRight;
    [self.scrollview addSubview:text4];
    
    if ([self.navigationItem.title isEqualToString:@"编辑"]) {
        text1.text = self.string1;
        text2.text = self.string2;
        str1 = self.string3;
        str2 = self.string4;
        str3 = self.string5;
        if (str3.length > 0) {
            text3.text = [NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3];
        }else{
            str3 = @"";
            text3.text = [NSString stringWithFormat:@"%@-%@",str1,str2];
        }
        text4.text = self.string6;
    }
    
    SQCustomButton *btn = [[SQCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 100)
                                                          type:SQCustomButtonTopImageType
                                                     imageSize:CGSizeMake(30, 30) midmargin:15];
    btn.isShowSelectBackgroudColor = NO;
    btn.imageView.image = [UIImage imageNamed:@"添加联系人"];
    btn.titleLabel.text = @"选联系人";
    btn.titleLabel.textColor = [UIColor blackColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.scrollview addSubview:btn];
    [btn touchAction:^(SQCustomButton * _Nonnull button) {
        
        [self JudgeAddressBookPower];
        
    }];
   
}


#pragma mark ---- 调用系统通讯录
- (void)JudgeAddressBookPower {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
}

- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (IOS_VERSION_9_OR_LATER) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else if (!granted) {
                    block(NO,YES);
                } else {
                    block(YES,YES);
                }
            }];
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        } else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    } else if (!granted) {
                        block(NO,NO);
                    } else {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized) {
            block(YES,NO);
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
}

#pragma mark -- CNContactPickerDelegate  进入系统通讯录页面 --
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty  API_AVAILABLE(ios(9.0)){
       CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
       [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *str1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *str2 = phoneNumber.stringValue;
        //text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self->text1.text = str1;
        self->text2.text = str2;
    }];
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate   进入系统通讯录页面 --
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *str1 = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *str2 = (__bridge NSString*)value;
        //text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self->text1.text = str1;
        self->text2.text = str2;
    }];
}







@end
