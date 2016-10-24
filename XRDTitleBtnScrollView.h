//
//  XRDTitleBtnScrollView.h
//  xrd
//
//  Created by 钱范儿-Developer on 16/8/19.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol XRDTitleBtnScrollViewDelegate <NSObject>

@optional
- (void)handleEventWhenTitleBtnClicked:(UIButton*)button withTitleIndex:(NSInteger)titleIndex;
- (void)handleEventWhenTitleBtnBeginBeClicked:(UIButton*)button withTitleIndex:(NSInteger)titleIndex;

@end

@interface XRDTitleBtnScrollView : UIScrollView

/**
 *  用来显示的title
 */
@property (nonatomic, strong) NSArray                          *titleArray;

/**
 *  title的字体大小
 */
@property (nonatomic, assign) CGFloat                          fontSize;

/**
 *  用来响应title点击的代理
 */
@property (nonatomic, weak  ) id<XRDTitleBtnScrollViewDelegate> xrdDelegate;

/**
 *  选中title的index，对应着titleArray中的index
 */
@property (nonatomic, assign) NSInteger                        selectedTitleIndex;

/**
 *  在scrollViewDidScroll中调用，用来同步titleBtnScrollView的滚动
 *
 *  @param scrollView      关联的scrollView
 *  @param distance      scrollVIew.contentOffset.x或者scrollView.contentOffset.y
 *
 */
- (void)scrollTitleBtnScrollViewWithScrollVIew:(UIScrollView*)scrollVIew withScrollDistance:(CGFloat)distance;


/**
 *  初始化方法
 *
 *  @param frame      视图的frame
 *  @param titleArray 呈现的所有title数组
 *  @param fontSize   title需要使用的字体大小，默认使用system字体
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray*)titleArray withFontSize:(CGFloat)fontSize;

@end
