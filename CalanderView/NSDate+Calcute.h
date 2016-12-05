//
//  NSDate+Calcute.h
//  testCalendar
//
//  Created by 钱范儿-Developer on 16/11/8.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define unitWidth 30
#define unitHeight 25

@interface NSDate (Calcute)
/**
 *  得到日期的年
 *
 *  @return year
 */
-(NSInteger) year;

/**
 *  得到日期的月
 *
 *  @return month
 */
-(NSInteger) month;

/**
 *  得到日期的日
 *
 *  @return day
 */
-(NSInteger) day;

/**
 *  得到日期的字符串转换格式
 *
 *  @return 20151212
 */
-(NSString*)string;

/**
 *  得到日期的详细字符串转换格式
 *
 *  @return 201412120823
 */
-(NSString *)detailString;

/**
 *  获取到日期的第一天是星期几
 *
 *  @param date      需要计算的日期
 *
 *  @return 第一天是星期几；需要搭配compents setWeekDay: 来使用；确定是从星期几开始计算
 */
+ (NSInteger)getFirstWeekDayInThisMonth:(NSDate*)date;


/**
 *  获取到日期对应的这个月的总天数
 *
 *  @param date      需要计算的日期
 *
 *  @return 获取到对应月份的总天数
 */
+ (NSInteger)getTotalDaysInThisMonth:(NSDate *)date;

+ (NSDate*)dateFromString:(NSString*)string;

+ (NSDate*)dateFromDetailString:(NSString*)detailString;

@end



