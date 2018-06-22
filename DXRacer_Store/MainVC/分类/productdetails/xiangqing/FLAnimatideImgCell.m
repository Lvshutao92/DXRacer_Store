//
//  FLAnimatideImgCell.m
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/6/22.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "FLAnimatideImgCell.h"

@implementation FLAnimatideImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (FLAnimatedImageView *)flanimatedImgView{
    if (_flanimatedImgView == nil) {
        self.flanimatedImgView = [[FLAnimatedImageView alloc]init];
    }
    return _flanimatedImgView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.flanimatedImgView];
    }
    return self;
}






@end
