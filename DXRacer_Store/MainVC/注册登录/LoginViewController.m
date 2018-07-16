//
//  LoginViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/4.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView *bgimg;
    UITextField *text1;
    UITextField *text2;
    
    UIButton *btn;
    UIButton *wjmmBtn;
    UIButton *zcBtn;
}
@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Manager sharedManager].mobile != nil) {
        text1.text = [Manager sharedManager].mobile;
        [text2 becomeFirstResponder];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupview];
}
- (void)clickcancel{
[self dismissViewControllerAnimated:YES completion:nil];
    

//    MainTabbarViewController *mainVC = [[MainTabbarViewController alloc]init];
//    mainVC.selectedIndex = 0;
//    for (UIBarItem *item in mainVC.tabBar.items) {
//        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                      [UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName, nil]
//                            forState:UIControlStateNormal];
//    }
//    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
//    [[UIApplication sharedApplication].keyWindow makeKeyWindow];
}
- (void)clickRegister{
    RegisterViewController *regis = [[RegisterViewController alloc]init];
    regis.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    regis.string = @"注册";
    [self presentViewController:regis animated:YES completion:nil];
}
- (void)clickWjmm{
    RegisterViewController *regis = [[RegisterViewController alloc]init];
    regis.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    regis.string = @"忘记密码";
    [self presentViewController:regis animated:YES completion:nil];
}









- (void)clickLogin{
    LRWeakSelf(self);
    if ([Manager judgeWhetherIsEmptyAnyObject:text1.text]==YES &&  [Manager judgeWhetherIsEmptyAnyObject:text2.text]==YES) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"加载中....", @"HUD loading title");
        
        NSDictionary *dic = @{@"passWord":text2.text,
                              @"loginName":text1.text};
        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/login") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [Manager writewenjianming:@"phone.text" content:self->text1.text];
                [Manager writewenjianming:@"password.text" content:self->text2.text];
                [Manager writewenjianming:@"token.text" content:[[diction objectForKey:@"object"]objectForKey:@"token"]];
                [Manager writewenjianming:@"userid.text" content:[[diction objectForKey:@"object"]objectForKey:@"userId"]];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"object"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            [hud hideAnimated:YES];
            //NSLog(@"----%@",diction);
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
            [hud hideAnimated:YES];
        }];
    }
    
}




- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:text1]) {
        if ([XYQRegexPatternHelper validateMobile:text1.text] == YES){
            LRWeakSelf(self);
            NSString *url = [NSString stringWithFormat:@"customer/validate?userName=%@",text1.text];
            [Manager requestPOSTWithURLStr:KURLNSString(url) paramDic:nil token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
                if (![code isEqualToString:@"500"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名不存在" message:@"温馨提示" preferredStyle:1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:cancel];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                //NSLog(@"----%@",diction);
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //            [self->text1 becomeFirstResponder];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    return YES;
}






- (void)setupview{
    bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, SCREEN_HEIGHT/2-250, 90, 90)];
    bgimg.image = [UIImage imageNamed:@"人"];
    LRViewBorderRadius(bgimg, 45, 0, [UIColor whiteColor]);
    bgimg.userInteractionEnabled = YES;
    [self.view addSubview:bgimg];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(20, kStatusBarHeight+10, 30, 30);
    [cancel setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickcancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-115, 30, 30)];
    img1.image = [UIImage imageNamed:@"手机"];
    [self.view addSubview:img1];
    text1 = [[UITextField alloc]initWithFrame:CGRectMake(65, SCREEN_HEIGHT/2-120, SCREEN_WIDTH-95, 40)];
    text1.delegate = self;
    text1.placeholder = @"请输入手机号";
    text1.keyboardType = UIKeyboardTypeNumberPad;
    text1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:text1];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-80, SCREEN_WIDTH-60, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line1];
    
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-60, 30, 30)];
    img2.image = [UIImage imageNamed:@"密码"];
    [self.view addSubview:img2];
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(65, SCREEN_HEIGHT/2-65, SCREEN_WIDTH-95, 40)];
    text2.delegate = self;
    text2.placeholder = @"请输入密码";
    text2.secureTextEntry = YES;
    text2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:text2];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-25, SCREEN_WIDTH-60, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line2];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, SCREEN_HEIGHT/2+15, SCREEN_WIDTH-60, 50);
    btn.backgroundColor = RGB_AB;
    LRViewBorderRadius(btn, 8, 0, [UIColor clearColor]);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

    
    
    
    zcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zcBtn.frame = CGRectMake(30, SCREEN_HEIGHT/2+70, 100, 40);
    [zcBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    zcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [zcBtn addTarget:self action:@selector(clickRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zcBtn];
    
    wjmmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wjmmBtn.frame = CGRectMake(SCREEN_WIDTH-130, SCREEN_HEIGHT/2+70, 100, 40);
    [wjmmBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    wjmmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [wjmmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [wjmmBtn addTarget:self action:@selector(clickWjmm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wjmmBtn];
    
    
    text1.keyboardAppearance = UIKeyboardAppearanceLight;
    text2.keyboardAppearance = UIKeyboardAppearanceLight;
}


@end
