//
//  AddressCell.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/8.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UILabel *lin;


@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab2height;

@end
