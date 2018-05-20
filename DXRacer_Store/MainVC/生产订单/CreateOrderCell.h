//
//  CreateOrderCell.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/17.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;

@property (weak, nonatomic) IBOutlet UILabel *lab5;



@property (weak, nonatomic) IBOutlet UILabel *line1;


@property (weak, nonatomic) IBOutlet UILabel *line2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1height;

@end
