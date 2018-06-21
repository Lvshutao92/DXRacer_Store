//
//  DWQSelectAttributes.m
//  DWQSelectAttributes
//
//  Created by 杜文全 on 15/5/21.
//  Copyright © 2015年 com.sdzw.duwenquan. All rights reserved.
//

#import "DWQSelectAttributes.h"




@implementation DWQSelectAttributes



-(instancetype)initWithTitle:(NSString *)title titleArr:(NSArray *)titleArr andFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.title = title;
        
        self.attributesArray = [NSArray arrayWithArray:titleArr];
        [self rankView];
        
    }
    return self;
}


-(void)rankView{
    
    self.packView = [[UIView alloc] initWithFrame:self.frame];
    self.packView.dwq_y = 0;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.85];
    [self.packView addSubview:line];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, screen_Width, 25)];
    titleLB.text = self.title;
    titleLB.font = FONT(15);
    [self.packView addSubview:titleLB];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLB.frame), screen_Width, 40)];
    [self.packView addSubview:self.btnView];
    
    int count = 0;
    float btnWidth = 0;
    float viewHeight = 0;
    
    

    
    
    for (int i = 0; i < self.attributesArray.count; i++) {
        
        
        
        
        NSString *btnName = self.attributesArray[i];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn setBackgroundColor:BackgroundColor];
        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.btn setTitle:btnName forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btn.layer.cornerRadius = 5;
        self.btn.layer.masksToBounds = YES;
        
        
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:FONT(13) forKey:NSFontAttributeName];
        CGSize btnSize = [btnName sizeWithAttributes:dict];
        
        self.btn.dwq_width = btnSize.width + 15;
        self.btn.dwq_height = btnSize.height + 12;
        
        if (i==0)
        {
            self.btn.dwq_x = 20;
            
            btnWidth += CGRectGetMaxX(self.btn.frame);
        }
        else{
            
           
            
            btnWidth += CGRectGetMaxX(self.btn.frame)+20;
            if (btnWidth > screen_Width) {
                count++;
                self.btn.dwq_x = 20;
                btnWidth = CGRectGetMaxX(self.btn.frame);
            }
            else{
                
                self.btn.dwq_x += btnWidth - self.btn.dwq_width;
            }
        }
        self.btn.dwq_y += count * (self.btn.dwq_height+10)+10;
        
        viewHeight = CGRectGetMaxY(self.btn.frame)+10;
        
        [self.btnView addSubview:self.btn];
        
        self.btn.tag = 10000+i;
        
        
//                if ([btnName isEqualToString:self.selectStr])
//                {
//                    self.selectBtn = btn;
//                    self.selectBtn.selected = YES;
//                    self.selectBtn.backgroundColor = [UIColor greenColor];
//                }
        
        
        if (self.btn.tag == 10000) {
            self.selectBtn = self.btn;
            self.selectBtn.backgroundColor = SelectColor;
            [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        
        
        
        
        
    }
    
    
    self.btnView.dwq_height = viewHeight;
    self.packView.dwq_height = self.btnView.dwq_height+CGRectGetMaxY(titleLB.frame);
    
    self.dwq_height = self.packView.dwq_height;
    
    [self addSubview:self.packView];
    
    [Manager sharedManager].gouwuNumHeight = self.dwq_y+self.packView.dwq_height;
    
//    NSLog(@"----%lf------%lf",self.dwq_y,self.packView.dwq_height);
}

-(void)btnClick:(UIButton *)btn{
    if (![self.selectBtn isEqual:btn]) {
        self.selectBtn.backgroundColor = BackgroundColor;
        self.selectBtn.selected = NO;
        [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        NSLog(@"%@-----%@",btn.titleLabel.text,[self.rankArray[btn.tag-10000] sequence]);
    }else{
        btn.backgroundColor = SelectColor;
    }
    btn.backgroundColor = SelectColor;
    btn.selected = YES;
    
    self.selectBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(selectBtnTitle:andBtn:)]) {
        [self.delegate selectBtnTitle:btn.titleLabel.text andBtn:self.selectBtn];
    }
}


@end
