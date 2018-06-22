//
//  UpdatePasswordViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/6/8.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()<UITextFieldDelegate>
{
    UITextField *textf0;
    UITextField *textf;
    UITextField *textf1;
}
@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    textf0 = [[UITextField alloc]initWithFrame:CGRectMake(20, kNavBarHAbove7, SCREEN_WIDTH-40, 50)];
    textf0.delegate = self;
    textf0.borderStyle  =  UIAccessibilityTraitNone;
    textf0.clearButtonMode = UITextFieldViewModeWhileEditing;
    textf0.placeholder = @"请输入旧密码";
    textf0.secureTextEntry = YES;
    [self.view addSubview:textf0];
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7+50, SCREEN_WIDTH, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:.8 alpha:.35];
    [self.view addSubview:line0];
    
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(20, kNavBarHAbove7+51, SCREEN_WIDTH-40, 50)];
    textf.delegate = self;
    textf.borderStyle = UIAccessibilityTraitNone;
    textf.clearButtonMode = UITextFieldViewModeWhileEditing;
    textf.placeholder = @"请输入6-20位新密码";
    textf.secureTextEntry = YES;
    [self.view addSubview:textf];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7+101, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.35];
    [self.view addSubview:line];
    
    
    textf1 = [[UITextField alloc]initWithFrame:CGRectMake(20, kNavBarHAbove7+102, SCREEN_WIDTH-40, 50)];
    textf1.delegate = self;
    textf1.borderStyle = UIAccessibilityTraitNone;
    textf1.clearButtonMode = UITextFieldViewModeWhileEditing;
    textf1.placeholder = @"请再次确认";
    textf1.secureTextEntry = YES;
    [self.view addSubview:textf1];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7+152, SCREEN_WIDTH, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.35];
    [self.view addSubview:line1];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, kNavBarHAbove7+185, SCREEN_WIDTH-40, 45);
    LRViewBorderRadius(btn, 5, 0, [UIColor clearColor]);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clicksave) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
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
}

- (void)clicksave{
    if (![textf0.text isEqualToString:[Manager redingwenjianming:@"password.text"]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"旧密码错误" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self->textf0 becomeFirstResponder];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (textf.text.length>0) {
            if (![textf.text isEqualToString:textf1.text]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新密码输入不相同，请再次输入" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self save];
            }
        }
    }
}

- (void)save{
    __weak typeof (self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:@"customer/update/password?password=%@",textf.text];
    [Manager requestPOSTWithURLStr:KURLNSString(str) paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        NSLog(@"******%@",diction);
        NSString *code = [NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"msg"] message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [Manager writewenjianming:@"password.text" content:self->textf.text];
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[diction objectForKey:@"msg"] message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } enError:^(NSError *error) {
        NSLog(@"******%@",error);
    }];
}























- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:textf0]) {
        if (![textf0.text isEqualToString:[Manager redingwenjianming:@"password.text"]]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"旧密码错误" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self->textf0 becomeFirstResponder];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    return YES;
}
















@end
