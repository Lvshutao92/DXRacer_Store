//
//  FL_2_Cell.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/15.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FL_2_Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgv;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab4height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab2height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab4width;


@end
