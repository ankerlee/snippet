//
//  NSDate+util.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (util)

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)minute;

- (NSDate *)dateAfterMonth:(NSInteger)month;

- (NSDate *)dateAfterDay:(NSInteger)day;

- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;

- (NSDate *)firstDayOfWeek;

- (NSDate *)endDayOfWeek;

- (NSInteger)dayOfWeek;

- (NSInteger)weekOfYear;
- (NSInteger)distanceToCurrentDate;

- (NSInteger)distanceToCurrentDateMidnight;

- (NSString *)stringDistanceToCurrentDate;

- (NSString *)stringDistanceToCurrentDate:(BOOL)againstMidnight;

- (NSString *)stringWithFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;

-(NSString *)__locale;

+(NSString *)__locale;

@end
