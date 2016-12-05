//
//  NSDate+Calcute.m
//  testCalendar
//
//  Created by 钱范儿-Developer on 16/11/8.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "NSDate+Calcute.h"



@implementation NSDate (Calcute)

- (void)setYear:(NSInteger)year{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [components setYear:year];
    //由于除了init初始化方法中可以设置self，其他方法都不可以；所以用属性不行
//    self = [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)setDay:(NSInteger)day{
    
}

- (void)setMonth:(NSInteger)month{
    
}

- (NSInteger)year{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self];
}

- (NSInteger)day{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self];
}

- (NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter stringFromDate:self];
}

- (NSString *)detailString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmm";
    return [formatter stringFromDate:self];
}

+ (NSDate*)dateFromString:(NSString*)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter dateFromString:string];
}

+ (NSDate*)dateFromDetailString:(NSString*)detailString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmm";
    return [formatter dateFromString:detailString];
}

+ (NSInteger)getFirstWeekDayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];   ////1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *compnents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [compnents setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:compnents];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1 ;
}

+ (NSInteger)getTotalDaysInThisMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

@end
