//
//  MiaoSha_Cell.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/24.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "MiaoSha_Cell.h"




@interface MiaoSha_Cell ()
{
    dispatch_source_t _timer;
}
@end





@implementation MiaoSha_Cell

- (UIImageView *)imgv{
    if (_imgv == nil) {
        self.imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 130, 130)];
        self.imgv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgv;
}
- (UILabel *)lab1{
    if (_lab1 == nil) {
        self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, SCREEN_WIDTH-150, 50)];
        self.lab1.textColor = [UIColor blackColor];
        self.lab1.font = [UIFont systemFontOfSize:15];
        self.lab1.numberOfLines = 0;
    }
    return _lab1;
}



- (UIProgressView *)myProgressView {
    if (!_myProgressView) {
        _myProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _myProgressView.frame = CGRectMake(140, 70, 120, 10);
        _myProgressView.backgroundColor = [UIColor grayColor];
        _myProgressView.transform = CGAffineTransformMakeScale(1.0f, 5.0f);    // 设置高度
        _myProgressView.progressTintColor = [UIColor blackColor];  // 已走过的颜色
        _myProgressView.trackTintColor = [UIColor redColor];  // 为走过的颜色
        //_myProgressView.progress = 0.4; // 进度 默认为0.0∈[0.0,1.0]
    }
    return _myProgressView;
}


- (UILabel *)lab2{
    if (_lab2 == nil) {
        self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(265, 60, 80, 20)];
        self.lab2.font = [UIFont systemFontOfSize:14];
        self.lab2.textAlignment = NSTextAlignmentCenter;
    }
    return _lab2;
}






- (UILabel *)lab3{
    if (_lab3 == nil) {
        self.lab3 = [[UILabel alloc]initWithFrame:CGRectMake(140, 90, 50, 20)];
        self.lab3.font = [UIFont systemFontOfSize:14];
        self.lab3.textAlignment = NSTextAlignmentCenter;
    }
    return _lab3;
}
- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 90, 40, 20)];
        self.dayLabel.textColor = [UIColor blackColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dayLabel;
}
- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        self.hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 90, 30, 20)];
        self.hourLabel.textColor = [UIColor whiteColor];
        self.hourLabel.backgroundColor = [UIColor blackColor];
        self.hourLabel.textAlignment = NSTextAlignmentCenter;
        self.hourLabel.font = [UIFont systemFontOfSize:14];
    }
    return _hourLabel;
}

- (UILabel *)dian1{
    if (_dian1 == nil) {
        self.dian1 = [[UILabel alloc]initWithFrame:CGRectMake(260, 90, 15, 20)];
        self.dian1.textAlignment = NSTextAlignmentCenter;
        self.dian1.text = @":";
    }
    return _dian1;
}



- (UILabel *)minuteLabel{
    if (_minuteLabel == nil) {
        self.minuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, 90, 30, 20)];
        self.minuteLabel.textColor = [UIColor whiteColor];
        self.minuteLabel.backgroundColor = [UIColor blackColor];
        self.minuteLabel.textAlignment = NSTextAlignmentCenter;
        self.minuteLabel.font = [UIFont systemFontOfSize:14];
    }
    return _minuteLabel;
}

- (UILabel *)dian2{
    if (_dian2 == nil) {
        self.dian2 = [[UILabel alloc]initWithFrame:CGRectMake(305, 90, 15, 20)];
        self.dian2.textAlignment = NSTextAlignmentCenter;
        self.dian2.text = @":";
    }
    return _dian2;
}


- (UILabel *)secondLabel{
    if (_secondLabel == nil) {
        self.secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(320, 90, 30, 20)];
        self.secondLabel.textColor = [UIColor whiteColor];
        self.secondLabel.backgroundColor = [UIColor blackColor];
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.font = [UIFont systemFontOfSize:14];
    }
    return _secondLabel;
}






- (UILabel *)lab4{
    if (_lab4 == nil) {
        self.lab4 = [[UILabel alloc]initWithFrame:CGRectMake(140, 120, 90, 20)];
        self.lab4.textColor = [UIColor redColor];
        self.lab4.font = [UIFont systemFontOfSize:16];
    }
    return _lab4;
}
- (UILabel *)lab5{
    if (_lab5 == nil) {
        self.lab5 = [[UILabel alloc]initWithFrame:CGRectMake(230, 120, 80, 20)];
        self.lab5.textColor = [UIColor grayColor];
        self.lab5.font = [UIFont systemFontOfSize:14];
    }
    return _lab5;
}




- (UILabel *)line{
    if (_line == nil) {
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 5)];
        self.line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.35];
    }
    return _line;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.imgv];
        
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.hourLabel];
        [self.contentView addSubview:self.minuteLabel];
        [self.contentView addSubview:self.secondLabel];
        
        [self.contentView addSubview:self.dian1];
        [self.contentView addSubview:self.dian2];
        
        
        [self.contentView addSubview:self.lab1];
        
        [self.contentView addSubview:self.lab2];
        [self.contentView addSubview:self.myProgressView];
        
        
        [self.contentView addSubview:self.lab3];
        [self.contentView addSubview:self.lab4];
        [self.contentView addSubview:self.lab5];
        [self.contentView addSubview:self.line];
    }
    return self;
}













-(void)downSecondHandle:(NSString *)aTimeString starDate:(NSDate *)starDate{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:aTimeString]; //结束时间
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    
//    NSString* dateString = [dateFormatter stringFromDate:starDate];
//    NSLog(@"现在的时间 === %@",dateString);
    

    NSTimeInterval  timeInterval =[endDate_tomorrow timeIntervalSinceDate:starDate];

    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLabel.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLabel.text = @"";
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}








@end
