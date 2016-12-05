//
//  YYChooseCalanderView.m
//  MySimpleNote
//
//  Created by 钱范儿-Developer on 16/11/9.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "YYChooseCalanderView.h"
#import "YYCalanderCell.h"
#import "YYCalanderView.h"
#import "UIView+WT.h"

@interface YYChooseCalanderView()

@property (nonatomic, strong) YYCalanderView *calanderView;

@property (nonatomic, strong) UILabel *showLabel;

@end

@implementation YYChooseCalanderView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (YYCalanderView *)calanderView{
    if (!_calanderView) {
        _calanderView = [[YYCalanderView alloc] init];
        [self addSubview:_calanderView];
        _calanderView.center = self.center;
    }
    return _calanderView;
}

- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.font = [UIFont systemFontOfSize:25];
        _showLabel.textColor = [UIColor colorWithRed:65 / 255.0 green:117 / 255.0 blue:5 / 255.0 alpha:1];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_showLabel];
    }
    return _showLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShowLabel:) name:YYCALANDERCELL_BUTTONCLICKED_NOTIFICATION object:nil];
    }
    return self;
}

- (void)configSubView{
    self.showLabel.frame = CGRectMake(0, CGRectGetMinY(self.calanderView.frame) - 40 - 30, CGRectGetWidth(self.bounds), 40);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - 40, CGRectGetMaxY(self.calanderView.frame) + 50, 80, 30)];
    btn.backgroundColor = NavColor;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(chooseCalander:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 40 - 10, 10, 40, 40)];
    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn addTarget:self action:@selector(cancelChooseCalander:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [self setShowLabelText:selectedDate];
    self.calanderView.selectedDate = selectedDate;
}

- (void)chooseCalander:(UIButton*)btn{
    _selectedDate = self.calanderView.finialSelectedDate;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CalanderView:didChangeSelectedDate:)]) {
        [self.delegate CalanderView:self didChangeSelectedDate:self.selectedDate];
    }
    self.hidden = YES;
}

- (void)cancelChooseCalander:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CalanderView:didChangeSelectedDate:)]) {
        [self.delegate CalanderView:self didChangeSelectedDate:self.selectedDate];
    }
    self.hidden = YES;
}

- (void)updateShowLabel:(NSNotification*)notifi{
    NSDate *pastDate = notifi.userInfo[USERINFO_SELECTED_DATE_KEY];
    [self setShowLabelText:pastDate];
}

- (void)setShowLabelText:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.showLabel.text = [formatter stringFromDate:date];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
