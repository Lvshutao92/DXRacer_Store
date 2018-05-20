//
//  CouponsViewController.h
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/3.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray  *_VCAry;
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}
- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS index:(NSInteger )index;
@end
