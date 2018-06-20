//
//  RegisterViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/4.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "RegisterViewController.h"
#import <SDWebImage/SDImageCache.h>
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UIImageView *bgimg;
    UITextField *text1;
    UITextField *text2;
    UITextField *text3;
    
    UITextField *textf;
    UIImageView *yzmImg;
    
    UIButton *btn;
    UIButton *YZMbtn;
    
}

@end

@implementation RegisterViewController
- (void)clickRegister{
   
    if ([self.string isEqualToString:@"注册"]) {
        [self zhuce];
    }else{
        [self wangjimima];
    }
    
}


- (void)zhuce{
    __weak typeof (self) weakSelf = self;
    if (text1.text != nil && text2.text != nil && text3.text != nil && textf.text != nil) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"加载中....", @"HUD loading title");
        
        NSDictionary *dic = @{@"verificationCode":textf.text,
                              @"shortMessage":text2.text,
                              @"passWord":text3.text,
                              @"loginName":text1.text};
        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/register") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [Manager sharedManager].mobile = self->text1.text;
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
- (void)wangjimima{
    __weak typeof (self) weakSelf = self;
    if (text1.text != nil && text2.text != nil && text3.text != nil && textf.text != nil) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"加载中....", @"HUD loading title");
        
        NSDictionary *dic = @{@"shortMessage":text2.text,
                              @"password":text3.text,
                              @"mobile":text1.text};
//        NSLog(@"----%@",dic);
        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/reset/password") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [Manager sharedManager].mobile = self->text1.text;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"object"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            [hud hideAnimated:YES];
//            NSLog(@"----%@",diction);
        } enError:^(NSError *error) {
            NSLog(@"%@",error);
            [hud hideAnimated:YES];
        }];
    }
}















- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupview];
}




- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:text1]) {
        if ([XYQRegexPatternHelper validateMobile:text1.text] == YES){
            if ([self.string isEqualToString:@"注册"]) {
                __weak typeof (self) weakSelf = self;
                NSString *url = [NSString stringWithFormat:@"customer/validate?userName=%@",text1.text];
                //        NSLog(@"666-------%@",url);
                [Manager requestPOSTWithURLStr:KURLNSString(url) paramDic:nil token:nil finish:^(id responseObject) {
                    NSDictionary *diction = [Manager returndictiondata:responseObject];
                    //             NSLog(@"-------%@",[diction objectForKey:@"msg"]);
                    NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
                    if ([code isEqualToString:@"500"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名已存在" message:@"温馨提示" preferredStyle:1];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alert addAction:cancel];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }else{
                        [self cilckimg];
                    }
                } enError:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }else{
                __weak typeof (self) weakSelf = self;
                NSString *url = [NSString stringWithFormat:@"customer/validate?userName=%@",text1.text];
                //        NSLog(@"666-------%@",url);
                [Manager requestPOSTWithURLStr:KURLNSString(url) paramDic:nil token:nil finish:^(id responseObject) {
                    NSDictionary *diction = [Manager returndictiondata:responseObject];
                    //             NSLog(@"-------%@",[diction objectForKey:@"msg"]);
                    NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
                    if (![code isEqualToString:@"500"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名不存在" message:@"温馨提示" preferredStyle:1];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alert addAction:cancel];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }else{
                        [self cilckimg];
                    }
                } enError:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
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



- (void)getYZM{
//    __weak typeof (self) weakSelf = self;
    if (textf.text != nil) {
        NSDictionary *dic = @{@"verificationCode":textf.text,@"mobile":text1.text};
        [Manager requestPOSTWithURLStr:KURLNSString(@"customer/register/shortmessage") paramDic:dic token:nil finish:^(id responseObject) {
            NSDictionary *diction = [Manager returndictiondata:responseObject];
//            NSLog(@"----%@",diction);
        } enError:^(NSError *error) {
//            NSLog(@"%@",error);
        }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先获取图形验证码" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}




- (void)cilckimg{
//    __weak typeof (self) weakSelf = self;
    if ([XYQRegexPatternHelper validateMobile:text1.text] == YES){
        [textf becomeFirstResponder];
        NSString *urlStr = [NSString stringWithFormat:@"customer/%@/verification.png",text1.text];
//        NSLog(@"%@",KURLNSString(urlStr));
        [Manager requestGETWithURLStr:KURLNSString(urlStr) paramDic:nil token:nil finish:^(id responseObject) {
//            NSDictionary *diction = [Manager returndictiondata:responseObject];
            //NSLog(@"----%@",diction);
            [[SDImageCache sharedImageCache] removeImageForKey:KURLNSString(urlStr) withCompletion:nil];
            NSURL *url = [NSURL URLWithString:KURLNSString(urlStr)];
            [self->yzmImg sd_setImageWithURL:url];
        } enError:^(NSError *error) {
//            NSLog(@"%@",error);
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

- (void)clickcancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickGetYZM{
    if ([XYQRegexPatternHelper validateMobile:text1.text] == YES) {
        [text2 becomeFirstResponder];
        [self getYZM];
        __block int timeout=59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                    [self->YZMbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    //设置不可点击
                    self->YZMbtn.userInteractionEnabled = YES;
                    self->YZMbtn.backgroundColor = [UIColor orangeColor];
                });
            }else{
                // int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [self->YZMbtn setTitle:[NSString stringWithFormat:@"%@s后重新发送",strTime] forState:UIControlStateNormal];
                    //设置可点击
                    self->YZMbtn.userInteractionEnabled = NO;
                    self->YZMbtn.backgroundColor = [UIColor lightGrayColor];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self->text1 becomeFirstResponder];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



















- (void)setupview{
    CGFloat hei;
    if ([[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone X"]||[[[Manager sharedManager] iphoneType]isEqualToString:@"iPhone Simulator"]) {
        hei = 44;
    }else{
        hei = 20;
    }
    
    bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, SCREEN_HEIGHT/2-270, 90, 90)];
    bgimg.image = [UIImage imageNamed:@"tx.jpg"];
    LRViewBorderRadius(bgimg, 45, 0, [UIColor whiteColor]);
    bgimg.userInteractionEnabled = YES;
    [self.view addSubview:bgimg];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(20, 30, 30, 30);
    [cancel setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickcancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    

    text1 = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-160, SCREEN_WIDTH-60, 40)];
    text1.delegate = self;
    text1.placeholder = @"请输入手机号";
    text1.keyboardType = UIKeyboardTypeNumberPad;
    text1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:text1];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-120, SCREEN_WIDTH-60, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line1];
    
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-100, SCREEN_WIDTH-175, 40)];
    textf.delegate = self;
    textf.placeholder = @"请输入图形码";
    textf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textf];
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-60, SCREEN_WIDTH-60, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line0];
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, SCREEN_HEIGHT/2-120+15, 30, 30)];
    img.image = [UIImage imageNamed:@"刷新"];
    img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cilckimg)];
    [img addGestureRecognizer:tap];
    [self.view addSubview:img];
    
    yzmImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-145, SCREEN_HEIGHT/2-120+7.5, 70, 45)];
    [self.view addSubview:yzmImg];
   
    
    text2 = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-40, SCREEN_WIDTH-180, 40)];
    text2.delegate = self;
    text2.placeholder = @"请输入验证码";
    text2.keyboardType = UIKeyboardTypeNumberPad;
    text2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:text2];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2, SCREEN_WIDTH-60, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line2];
    YZMbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YZMbtn.frame = CGRectMake(SCREEN_WIDTH-145, SCREEN_HEIGHT/2-35, 115, 30);
    YZMbtn.backgroundColor = [UIColor orangeColor];
    LRViewBorderRadius(YZMbtn, 12, 0, [UIColor clearColor]);
    YZMbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [YZMbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [YZMbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [YZMbtn addTarget:self action:@selector(clickGetYZM) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:YZMbtn];
    
    
    
    text3 = [[UITextField alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+20, SCREEN_WIDTH-60, 40)];
    text3.delegate = self;
    text3.placeholder = @"请输入密码";
    text3.secureTextEntry = YES;
    text3.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:text3];
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2+60, SCREEN_WIDTH-60, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:line3];
    
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, SCREEN_HEIGHT/2+90, SCREEN_WIDTH-60, 50);
    btn.backgroundColor = [UIColor redColor];
    LRViewBorderRadius(btn, 8, 0, [UIColor clearColor]);
    
    
    
    if ([self.string isEqualToString:@"注册"]) {
       [btn setTitle:@"注册" forState:UIControlStateNormal];
    }else{
       [btn setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
    _gradientLayer.bounds = btn.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = btn.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)RGBACOLOR(220, 20, 60, 1.0).CGColor,
                             (id)RGBACOLOR(255, 0, 0, 1.0).CGColor, nil ,nil];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint   = CGPointMake(1.0, 1.0);
    [btn.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}




@end
