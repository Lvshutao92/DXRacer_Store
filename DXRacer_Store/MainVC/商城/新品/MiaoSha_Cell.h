//
//  MiaoSha_Cell.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/24.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiaoSha_Cell : UITableViewCell




@property(nonatomic,strong)UIImageView  *imgv;

@property(nonatomic,strong)UILabel  *lab1;



@property(nonatomic,strong)UIProgressView *myProgressView;
@property(nonatomic,strong)UILabel  *lab2;




@property(nonatomic,strong)UILabel  *lab3;

@property(nonatomic,strong)UILabel  *lab4;
@property(nonatomic,strong)UILabel  *lab5;



@property(nonatomic,strong)UILabel *line;



@property (strong, nonatomic)UILabel *dian1;
@property (strong, nonatomic)UILabel *dian2;


@property (strong, nonatomic)UILabel *dayLabel;
@property (strong, nonatomic)UILabel *hourLabel;
@property (strong, nonatomic)UILabel *minuteLabel;
@property (strong, nonatomic)UILabel *secondLabel;



-(void)downSecondHandle:(NSString *)aTimeString starDate:(NSDate *)starDate;








@end
