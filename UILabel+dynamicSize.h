//
//  UILabel+dynamicSize.h
//  xrd
//
//  Created by 钱范儿-Developer on 16/8/27.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (dynamicSize)

/**
 *  根据numberOfLines返回newFrame的MaxX或者MaxY
 *
 *  @return MaxX或者MaxY
 */
- (float)resizeToFit;

/**
 *  根据label.text和numberOfLines计算height或者width
 *
 *  @return 计算后的width或者height
 */
- (float)expectedHeightOrWidth;


@end
