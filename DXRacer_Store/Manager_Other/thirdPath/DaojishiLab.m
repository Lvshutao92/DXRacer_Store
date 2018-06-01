//
//  DaojishiLab.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/24.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "DaojishiLab.h"



@interface DaojishiLab ()
@property (nonatomic, strong)UIPasteboard *pasteBoard;
@end


@implementation DaojishiLab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        self.pasteBoard = [UIPasteboard generalPasteboard];
        [self attachTapHandle];
    }
    return self;
}

- (void)attachTapHandle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

//响应事件
- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self becomeFirstResponder]; //UILabel默认是不能响应事件的，所以要让它成为第一响应者
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    [menuVC setTargetRect:self.frame inView:self.superview]; //定位Menu
    [menuVC setMenuVisible:YES animated:YES]; //展示Menu
}

- (BOOL)canBecomeFirstResponder { //指定UICopyLabel可以成为第一响应者 切忌不要把这个方法不小心写错了哟， 不要写成 becomeFirstResponder
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender { //指定该UICopyLabel可以响应的方法
    if (action == @selector(copy:)) {
        return YES;
    }
//    if (action == @selector(paste:)) {
//        return YES;
//    }
//    if (action == @selector(delete:)) {
//        return YES;
//    }
//    if (action == @selector(selectAll:)) {
//        return YES;
//    }
//    if (action == @selector(cut:)) {
//        return YES;
//    }
    return NO;
}

//- (void)paste:(id)sender {
//    //    self.text = self.pasteBoard.string;
//    //    NSLog(@"粘贴的内容%@", self.pasteBoard.string);
//
//    self.backgroundColor = self.pasteBoard.color;
//
//}

- (void)copy:(id)sender {
    //    self.pasteBoard.string = self.text;
    //    NSLog(@"复制");
    self.pasteBoard.color = self.backgroundColor;
}

//-(void)cut:(id)sender {
//    self.pasteBoard.string = self.text;
//    self.text = @"";
//    NSLog(@"剪切");
//}
//
//- (void)delete:(id)sender {
//    self.text = nil;
//    self.pasteBoard = nil;
//}

- (void)selectAll:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    self.textColor = [UIColor blueColor];
    NSLog(@"全选的数据%@", pasteBoard.string);
}  



@end
