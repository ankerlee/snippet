//
//  NSDate+util.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (util)

//获取年
- (NSUInteger)year;

//获取月
- (NSUInteger)month;

//获取日
- (NSUInteger)day;

//获取小时
- (int)hour;

//获取分钟
- (int)minute;

//month个月后的日期
- (NSDate *)dateAfterMonth:(int)month;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

//返回该月的第一天
- (NSDate *)beginningOfMonth;

//该月的最后一天
- (NSDate *)endOfMonth;

//返回当前周的开始日期
- (NSDate *)beginningOfWeek;

//返回当前周的最后一天的日期
- (NSDate *)endOfWeek;

//返回当前天的年月日
- (NSDate *)beginningOfDay;

//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday;

//该日期是该年的第几周
- (int)weekOfYear;

//在当前日期前几天
- (NSUInteger)daysAgo;

//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight;

- (NSString *)stringDaysAgo;

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;

- (NSString *)stringWithFormat:(NSString *)format;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date;

+ (NSString *)dateFormatString;

+ (NSString *)timeFormatString;

+ (NSString *)timestampFormatString;

@end
