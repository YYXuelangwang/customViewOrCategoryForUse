//
//  UIColor+Hex.m
//  pratice_Second_UICollectionVIew
//
//  Created by yinyong on 16/9/24.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (instancetype)getColorFromHexString:(NSString*)hexString{
    NSString *processStr = [[hexString substringFromIndex:1] uppercaseString];
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[[processStr substringWithRange:NSMakeRange(0, 2)], [processStr substringWithRange:NSMakeRange(2, 2)], [processStr substringWithRange:NSMakeRange(4, 2)]]];
    for (int i = 0; i < 3; i ++) {
        NSString *str = array[i];
        CGFloat number = ([str characterAtIndex:0] > '9' ? (10 + [str characterAtIndex:0] - 'A') : ([str characterAtIndex:0] - '0')) * 16 + ([str characterAtIndex:1] > '9' ? 10 + [str characterAtIndex:1] - 'A' : ([str characterAtIndex:1] - '0'));
        array[i] = @(number);
    }
    return [UIColor colorWithRed:[array[0] floatValue] / 255.0 green:[array[1] floatValue] / 255.0 blue:[array[2] floatValue] / 255.0 alpha:1.0];
}

@end
