//
//  YYCalanderCell.m
//  testCalendar
//
//  Created by 钱范儿-Developer on 16/11/8.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "YYCalanderCell.h"
#import "NSDate+Calcute.h"

NSString *const YYCALANDERCELL_BUTTONCLICKED_NOTIFICATION = @"buttonClicked";
NSString *const USERINFO_BUTTON_FRAME_KEY = @"buttonFrame";
NSString *const USERINFO_SELECTED_DATE_KEY = @"selectedDate";
NSString *const USERINFO_ITEM_KEY = @"currentItem";

@interface YYCalanderCell()

@property (nonatomic, strong) NSMutableArray *allBtnArrays;



@end

@implementation YYCalanderCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (NSMutableArray *)allBtnArrays{
    if (!_allBtnArrays) {
        _allBtnArrays = [NSMutableArray array];
    }
    return _allBtnArrays;
}

- (void)setUpSubViews{
    
    self.bounds = CGRectMake(0, 0, (unitWidth + 5) * 7 + 5, (unitHeight + 5) * 5 + 5);
    
    //添加35个按钮
    for (int i = 0; i < 35; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5 + (unitWidth + 5) * (i % 7), 5 + (unitHeight + 5) * (i / 7), unitWidth, unitHeight)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:NavColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.allBtnArrays addObject:btn];
        [self addSubview:btn];
    }
    
}

- (void)setCalcuteDate:(NSDate *)calcuteDate{
    _calcuteDate = calcuteDate;
    [self updateCalanderData];
}

- (void)updateCalanderData{
    NSInteger daysInMonth = [NSDate getTotalDaysInThisMonth:self.calcuteDate];
    NSInteger firstWeekdayInMonth = [NSDate getFirstWeekDayInThisMonth:self.calcuteDate];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSDate *dateOfLastMonth = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.calcuteDate options:0];
    
    NSInteger daysInPreMonth = [NSDate getTotalDaysInThisMonth:dateOfLastMonth];
    
    for (int i = 0; i < self.allBtnArrays.count; i ++) {
        UIButton *btn = self.allBtnArrays[i];
        NSInteger day = 0;
        //设置按钮的数字和颜色
        if (i < firstWeekdayInMonth) {
            day = daysInPreMonth - firstWeekdayInMonth + i + 1;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else if (i > firstWeekdayInMonth + daysInMonth - 1){
            day = i + 1 - firstWeekdayInMonth - daysInMonth;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        }else{
            day = i - firstWeekdayInMonth + 1;
            [btn setTitleColor:NavColor forState:UIControlStateNormal];
        }
        [btn setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
    }
    
    [self makeNowDateObvious];
    
}

//标记出当天的时间
- (void)makeNowDateObvious{
    NSDate *now = [NSDate date];
    NSInteger firstWeekDayInMonth = [NSDate getFirstWeekDayInThisMonth:now];
    NSInteger i = now.day + firstWeekDayInMonth - 1;
    UIButton *btn = self.allBtnArrays[i];
    if (self.calcuteDate.year == now.year && self.calcuteDate.month == now.month) {
//        [btn setBackgroundImage:[UIImage imageNamed:@"nowDate"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.selected = YES;
    }else if (btn.selected){
//        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        btn.selected = NO;
    }
}

- (void)chooseFirstDayButton{
    NSInteger firstWeekDayInMonth = [NSDate getFirstWeekDayInThisMonth:self.calcuteDate];
    UIButton *btn = self.allBtnArrays[firstWeekDayInMonth];
    [self clickBtn:btn];
}



- (void)clickBtn:(UIButton*)btn{
    NSInteger day = [btn.titleLabel.text integerValue];
    NSDateComponents *nextComponents = [[NSDateComponents alloc] init];
    [nextComponents setYear:self.calcuteDate.year];
    [nextComponents setMonth:self.calcuteDate.month];
    //这里目前不知道为什么，如果不加1，那么结果就会变成昨天，转换为字符串的话又是正确的；
    [nextComponents setDay:day];
    
    NSDate *selectedDate = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:nextComponents];
    NSLog(@"selectedDate: %@", selectedDate);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YYCALANDERCELL_BUTTONCLICKED_NOTIFICATION object:nil userInfo:@{USERINFO_BUTTON_FRAME_KEY : [NSValue valueWithCGRect:btn.frame], USERINFO_SELECTED_DATE_KEY : selectedDate, USERINFO_ITEM_KEY : self}];
    
    
}



@end
