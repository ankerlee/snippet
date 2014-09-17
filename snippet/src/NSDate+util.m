//
//  NSDate+util.m
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import "NSDate+util.h"


#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation NSDate (Util)

//获取年
- (NSUInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dayComponents year];
}

//获取月
- (NSUInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dayComponents month];
}

//获取日
- (NSUInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dayComponents day];
}

//获取小时
- (int)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit) fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}

//获取分钟
- (int)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSMinuteCalendarUnit) fromDate:self];
    NSInteger minute = [components minute];
    return (int)minute;
}

//month个月后的日期
- (NSDate *)dateAfterMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterMonth;
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}

//返回该月的第一天
- (NSDate *)beginningOfMonth
{
    return [self dateAfterDay:-[self day] + 1];
}

//该月的最后一天
- (NSDate *)endOfMonth
{
    return [[[self beginningOfMonth] dateAfterMonth:1] dateAfterDay:-1];
}

//返回当前周的开始日期
- (NSDate *)beginningOfWeek
{
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}

//返回当前周的最后一天的日期
- (NSDate *)endOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return endOfWeek;
}

//返回当前天的年月日
- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    return [weekdayComponents weekday];
}

//该日期是该年的第几周
- (int)weekOfYear
{
    int i;
    int year = [self year];
    NSDate *date = [self endOfWeek];
    for (i = 1;[[date dateAfterDay:-7 * i] year] == year;i++){}
    return i;
}

//在当前日期前几天
- (NSUInteger)daysAgo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight
{
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    mdf.locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSDate __locale]];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) * -1;
}

- (NSString *)stringDaysAgo
{
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag
{
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
        {
            text = NSLocalizedString(@"Today", nil);
            break;
        }
        case 1:
        {
            text = NSLocalizedString(@"Yesterday",nil);
            break;
        }
        default:
        {
            text = [NSString stringWithFormat:@"%d %@", daysAgo,NSLocalizedString(@"days ago", nil)];
        }
    }
    return text;
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self __locale]];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSDate __locale]];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSDate __locale]];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                                                     fromDate:today];
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    displayFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSDate __locale]];
    NSString *displayString = nil;
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"a h:mm"]; // am 11:30
        } else {
            [displayFormatter setDateFormat:@"a h:mm"]; // am 11:30
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        if ([date compare:lastweek] == NSOrderedDescending) {
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MM-dd"];
            } else {
                [displayFormatter setDateFormat:@"yyyy-MM-dd"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    return displayString;
}


+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}


+ (NSString *)dateFormatString
{
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString
{
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

-(NSString *)__locale{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+(NSString *)__locale{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

@end
