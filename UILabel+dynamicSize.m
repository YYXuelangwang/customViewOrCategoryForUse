//
//  UILabel+dynamicSize.m
//  xrd
//
//  Created by 钱范儿-Developer on 16/8/27.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "UILabel+dynamicSize.h"

@implementation UILabel (dynamicSize)

- (float)resizeToFit{
    float temporty = [self expectedHeightOrWidth];
    CGRect newframe = [self frame];
    if (self.numberOfLines) {
        newframe.size.width = temporty;
    }else{
        newframe.size.height = temporty;
    }
    
    [self setFrame:newframe];
    return self.numberOfLines ? CGRectGetMaxX(newframe) : CGRectGetMaxY(newframe);
}

- (float)expectedHeightOrWidth{
    
    CGSize maximumLabelSize = CGSizeMake(self.numberOfLines ? [UIScreen mainScreen].bounds.size.width : self.frame.size.width, 9999);
    
    CGSize expectedLabelSize = [self.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    return self.numberOfLines ? expectedLabelSize.width :  expectedLabelSize.height;
}

@end
