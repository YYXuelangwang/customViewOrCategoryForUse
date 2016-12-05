//
//  YYChooseCalanderView.h
//  MySimpleNote
//
//  Created by 钱范儿-Developer on 16/11/9.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYChooseCalanderView;

@protocol YYChooseCalanderViewDelegate <NSObject>

- (void)CalanderView:(YYChooseCalanderView*)view didChangeSelectedDate:(NSDate*)selectedDate;

@end

@interface YYChooseCalanderView : UIView

/**
 *  选中的日期
 *
 */
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, weak) id<YYChooseCalanderViewDelegate> delegate;

@end
