//
//  XRDTitleBtnScrollView.m
//  xrd
//
//  Created by 钱范儿-Developer on 16/8/19.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "XRDTitleBtnScrollView.h"
#import "UIView+xrdCustomView.h"


#define kWidth self.frame.size.width

#define kHeight self.frame.size.height

@interface XRDTitleBtnScrollView ()

/**
 *  最上层用来显示的视图
 */
@property (nonatomic, strong) UIView                           *backView;

@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, assign) CGFloat margin;

/**
 *  用来存储标题长度的数组
 */
@property (nonatomic, strong) NSMutableArray *widthArray;

@property (nonatomic, assign) NSInteger storeIndex;

@end

@implementation XRDTitleBtnScrollView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray withFontSize:(CGFloat)fontSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.titleArray = titleArray;
        self.fontSize = fontSize;
        self.widthArray = [NSMutableArray array];
        self.margin = [self calculateMarginWithTitleArray:titleArray];
        [self setUpTitleBtnsWithTitleArray:titleArray];
        [self setNeedsLayout];
    
    }
    return self;
}

- (CGFloat)calculateMarginWithTitleArray:(NSArray*)titleArray{
    
    //总的宽度
    CGFloat totalWidth = 0;
    CGFloat magrain = 20;
    
    for (NSString *title in titleArray) {
        CGFloat width = [title boundingRectWithSize:CGSizeMake(600, self.fontSize * 1.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}  context:nil].size.width;
        totalWidth += width + magrain;
        [self.widthArray addObject:@(width)];
    }
    
    self.contentSize = CGSizeMake(fmax(kWidth, totalWidth + 50 - magrain), kHeight);
    
    if (kWidth > totalWidth + 50 - magrain) {
        magrain = (kWidth - (totalWidth + 50 - magrain * titleArray.count)) / (titleArray.count - 1);
    }
    
    return magrain;
}


- (void)setUpTitleBtnsWithTitleArray:(NSArray*)titleArray{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backView.layer.cornerRadius = 1;
    self.backView.clipsToBounds = YES;
    self.backView.backgroundColor = [UIColor lightGrayColor];
    
    self.middleView = [[UIView alloc] init];
    
  //    [self addSubview:self.backView];
    
    UIButton *preBtn;
    
    for (int i = 0; i < titleArray.count ; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        UILabel  *label = [[UILabel alloc] init];
        if (i == 0) {
            btn.frame = CGRectMake(25, 2, [self.widthArray[i] floatValue], kHeight - 2);
            label.frame = btn.frame;
            self.backView.frame = CGRectMake(btn.frame.origin.x, 0, btn.frame.size.width, kHeight);
            self.middleView.frame = CGRectMake(- btn.frame.origin.x, 0, self.contentSize.width, self.contentSize.height);
            

            btn.selected = YES;
            self.storeIndex = 0;
           
        }else{
            btn.frame = CGRectMake(CGRectGetMaxX(preBtn.frame) + self.margin, 2, [self.widthArray[i] floatValue], kHeight - 2);
            label.frame = btn.frame;
            
        }
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        btn.tag = i + 100;
        preBtn = btn;
        [self addSubview:btn];
        
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor greenColor];
        [self.middleView addSubview:label];
        
        [btn addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.backView addSubview:self.middleView];
    [self addSubview:self.backView];
    
}


- (void)clickTitleButton:(UIButton *)btn {
    
    [self handleEventWhenTitleBtnClicked:btn];
    
    //代理来响应对应关系
    if (self.xrdDelegate && [self.xrdDelegate respondsToSelector:@selector(handleEventWhenTitleBtnClicked:withTitleIndex:)]) {
        [self.xrdDelegate handleEventWhenTitleBtnClicked:btn withTitleIndex:btn.tag - 100];
    }
}


- (void)setSelectedTitleIndex:(NSInteger)selectedTitleIndex{
    UIButton *btn = [self viewWithTag:100 + selectedTitleIndex];
    [self handleEventWhenTitleBtnClicked:btn];
}

-(NSInteger)selectedTitleIndex{
    return self.storeIndex;
}

- (void)scrollTitleBtnScrollViewWithScrollVIew:(UIScrollView*)scrollVIew withScrollDistance:(CGFloat)distance{
    CGFloat pageWidth = scrollVIew ? scrollVIew.frame.size.width : [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollDistance = distance - self.selectedTitleIndex * pageWidth;
    
    CGFloat factor = 0;
    UIButton *selectedBtn = [self viewWithTag: 100 + self.selectedTitleIndex];
    if (scrollDistance > 0 && self.selectedTitleIndex < self.titleArray.count - 1 ) {
        UIButton *btn = [self viewWithTag:100 + self.selectedTitleIndex];
        UIButton *nextBtn = [self viewWithTag:101 + self.selectedTitleIndex];
        selectedBtn = nextBtn;
        factor = (nextBtn.center.x - btn.center.x) / pageWidth;
    }else if (scrollDistance < 0 && self.selectedTitleIndex > 0) {
        UIButton *btn = [self viewWithTag:100 + self.selectedTitleIndex];
        UIButton *preBtn = [self viewWithTag:99 + self.selectedTitleIndex];
        selectedBtn = preBtn;
        factor = (btn.center.x - preBtn.center.x) / pageWidth;
    }
    CGFloat x = scrollDistance * factor + [self viewWithTag: 100 + self.selectedTitleIndex].frame.origin.x;
    self.backView.x = x;
    self.middleView.x = -x;
    
    if (ABS(self.backView.center.x - (selectedBtn.center.x)) < 1.0) {
        
        self.backView.width = selectedBtn.width;
        CGPoint center = self.backView.center;
        center.x = selectedBtn.center.x;
        self.backView.center = center;
        self.middleView.x = - self.backView.x;
        
        [self handleEventWhenTitleBtnClicked:selectedBtn];
    }
}

- (void)handleEventWhenTitleBtnClicked:(UIButton*)btn{
    
    
    if (self.xrdDelegate && [self.xrdDelegate respondsToSelector:@selector(handleEventWhenTitleBtnBeginBeClicked:withTitleIndex:)]) {
        [self.xrdDelegate handleEventWhenTitleBtnBeginBeClicked:btn withTitleIndex:btn.tag - 100];
    }
    
    
    //如果选中的title与上一次不同，就发送请求
    if (self.backView.center.x != btn.center.x) {
        
    }
    
    //让不是当前点击的按钮恢复为黑色字体
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (btn.isSelected) {
            btn.selected = NO;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    
    //当前选中按钮的改变
    btn.selected = YES;
    self.storeIndex = btn.tag - 100;
    
    //让其他的scrollVIew不再响应点击statusBar而scrolltotop的事件
//    for (int i = 0; i < self.titleArray.count; i ++) {
//        UITableView *tableView = [_detailScrollView viewWithTag:1000 + i];
//        if (tableView.scrollsToTop == YES && tableView.tag != btn.tag - 100 + 1000) {
//            tableView.scrollsToTop = NO;
//        }
//        if (tableView.tag == btn.tag - 100 + 1000) {
//            tableView.scrollsToTop = YES;
//        }
//    }
    
    
    //
    [UIView animateWithDuration:0.1 animations:^{
        _backView.frame = CGRectMake(btn.frame.origin.x, 0, btn.frame.size.width, kHeight);
        self.middleView.x =  - btn.frame.origin.x;
    } completion:^(BOOL finished) {
        
        //titleScorllview跟随移动的动画；
        if (self.contentSize.width > kWidth) {
            if (self.backView.center.x > kWidth * 0.5 && (self.contentSize.width - self.backView.center.x) < kWidth * 0.5 ) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentOffset = CGPointMake(self.contentSize.width - kWidth, 0);
                }];
            }
            if (self.backView.center.x < kWidth * 0.5 && self.backView.center.x < kWidth * 0.5) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentOffset = CGPointMake(0, 0);
                }];
            }
            if (self.backView.center.x > kWidth * 0.5 && (self.contentSize.width - self.backView.center.x) > kWidth * 0.5) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentOffset = CGPointMake(btn.center.x - kWidth * 0.5, 0);
                }];
            }
            
        }
        
    }];
    
}

- (void)createBtnWithMargin:(CGFloat)margin{
    //上一个按钮，用来计算下一个按钮的frame

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
