//
//  LTRootViewController+LTNavView.h
//  PlantHunter
//
//  Created by hundred wang on 17/3/17.
//  Copyright © 2017年 One23S. All rights reserved.
//

#import "LTRootViewController.h"

@interface LTRootViewController (LTNavView)

/**
 导航栏视图
 */
@property (nonatomic, strong, readonly) UIView * lt_NavView;

/**
 退出的方式，yes为pop，否则为dismiss
 */
@property (nonatomic, assign) BOOL lt_isPop;

/**
 此方法只能在init方法中加入
 */
- (void)addNavView;

@end
