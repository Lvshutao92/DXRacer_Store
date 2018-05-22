//
//  BigImgTableViewCell.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/19.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "BigImgTableViewCell.h"

@implementation BigImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat )returnCellHeight:(NSString *)str{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *image = [UIImage imageWithData:data];
    CGSize size = image.size;
    CGFloat height = SCREEN_WIDTH/size.width*size.height;
    return height;
}


@end
