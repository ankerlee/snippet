//
//  NSString+util.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    NSVerticalTextAlignmentTop,
    NSVerticalTextAlignmentMiddle,
    NSVerticalTextAlignmentBottom
} NSVerticalTextAlignment;

@interface NSString (Util)

- (NSString *)md5;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)fileMd5:(NSString *)path;

+(NSString *)random;

- (NSString *)stringByUnescapingFromURLQuery;
- (NSDictionary*)queryDictionaryUsingEncoding: (NSStringEncoding)encoding;
- (NSString *)URLEncode;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString *)trim;

/**
 * Escape the standard 5 XML entities: &, <, >, ", '
 */
- (NSString *) stringByEscapingCriticalXMLEntities;
/**
 * Unescape the standard 5 XML entities: &, <, >, ", '
 */
- (NSString *) stringByUnescapingCrititcalXMLEntities;


- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font verticalAlignment:(NSVerticalTextAlignment)vAlign;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode verticalAlignment:(NSVerticalTextAlignment)vAlign;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment verticalAlignment:(NSVerticalTextAlignment)vAlign;

- (NSInteger)numberOfLines;

/**
 *  文本自适应尺寸计算
 *
 *  @param font              字体
 *  @param constrainedToSize 约束尺寸
 *
 *  @return 自适应尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize;
/**
 *  文本自适应尺寸计算
 *
 *  @param text              需要计算的文本
 *  @param font              字体
 *  @param constrainedToSize 约束尺寸
 *
 *  @return 自适应尺寸
 */
+ (CGSize)sizeForText:(NSString *)text WithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize;

@end
