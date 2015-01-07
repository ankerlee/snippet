//
//  NSString+util.m
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import "NSString+util.h"

#import <CommonCrypto/CommonDigest.h>

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#define CHUNK_SIZE 1024

@implementation NSString (Util)
- (NSString *) md5
{
    return [NSString md5:self];
}

+(NSString *) md5:(NSString *) str{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash uppercaseString];
}

+(NSString *)fileMd5:(NSString *) path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(handle == nil)
        return nil;
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    NSData* filedata;
    do {
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
    }
    while([filedata length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++){
        [hash appendFormat:@"%02x",result[i]];
    }
    return [hash lowercaseString];
}

+(NSString *) random{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, cfuuid);
    NSString *cfuuidString = [NSString stringWithString:(__bridge NSString *)cfstring];
    CFRelease(cfuuid);
    CFRelease(cfstring);
    return cfuuidString;
}


- (NSString *)stringByUnescapingFromURLQuery {
    NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary*)queryDictionaryUsingEncoding: (NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"] ;
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary] ;
    NSScanner* scanner = [[NSScanner alloc] initWithString:self] ;
    while (![scanner isAtEnd]) {
        NSString* pairString ;
        [scanner scanUpToCharactersFromSet:delimiterSet
                                intoString:&pairString] ;
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL] ;
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="] ;
        if ([kvPair count] == 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByUnescapingFromURLQuery];
            NSString* value = [[kvPair objectAtIndex:1] stringByUnescapingFromURLQuery];
            [pairs setObject:value forKey:key] ;
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs] ;
}

- (NSString *) URLEncode
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,
                            @"$" , @"," , @"[" , @"]",
                            @"#", @"!", @"'", @"(",
                            @")", @"*", @" ", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                             @"%3A" , @"%40" , @"%26" ,
                             @"%3D" , @"%2B" , @"%24" ,
                             @"%2C" , @"%5B" , @"%5D",
                             @"%23", @"%21", @"%27",
                             @"%28", @"%29", @"%2A", @"+", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [self mutableCopy];
    
    int i;
    for(i = 0; i < len; i++)
    {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *result = [NSString stringWithString: temp];
    return result;
}

- (NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (__bridge CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8);
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (__bridge CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8);
    return result;
}


- (NSString *) stringByEscapingCriticalXMLEntities
{
    NSMutableString * mutable = [NSMutableString stringWithString:self];
    [mutable replaceOccurrencesOfString: @"&"
                             withString: @"&amp;"
                                options: NSLiteralSearch
                                  range: NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString: @"<"
                             withString: @"&lt;"
                                options: NSLiteralSearch
                                  range: NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString: @">"
                             withString: @"&gt;"
                                options: NSLiteralSearch
                                  range: NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString: @"'"
                             withString: @"&#x27;"
                                options: NSLiteralSearch
                                  range: NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString: @"\""
                             withString: @"&quot;"
                                options: NSLiteralSearch
                                  range: NSMakeRange(0, mutable.length)];
    return mutable;
}

- (NSString *) stringByUnescapingCrititcalXMLEntities
{
    NSMutableString *mutable = [NSMutableString stringWithString:self];
    [mutable replaceOccurrencesOfString:@"&amp;"
                             withString:@"&"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString:@"&lt;"
                             withString:@"<"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString:@"&gt;"
                             withString:@">"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString:@"&#x27;"
                             withString:@"'"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, mutable.length)];
    [mutable replaceOccurrencesOfString:@"&quot;"
                             withString:@"\""
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, mutable.length)];
    return mutable;
};

-(NSString *)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }
    return [self drawInRect:rect withFont:font];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment verticalAlignment:(NSVerticalTextAlignment)vAlign
{
    switch (vAlign) {
        case NSVerticalTextAlignmentTop:
            break;
            
        case NSVerticalTextAlignmentMiddle:
            rect.origin.y = rect.origin.y + ((rect.size.height - font.pointSize) / 2);
            break;
            
        case NSVerticalTextAlignmentBottom:
            rect.origin.y = rect.origin.y + rect.size.height - font.pointSize;
            break;
    }
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
}

- (NSInteger)numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

+(CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize{
    CGFloat maxWidth = constrainedToSize.width;
    CGFloat maxHeight = constrainedToSize.height;
    
    CGSize stringSize;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        CGRect stringRect = [text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{ NSFontAttributeName : font }
                                               context:nil];
        
        stringSize = CGRectIntegral(stringRect).size;
    }
    else {
        stringSize = [text sizeWithFont:font
                      constrainedToSize:CGSizeMake(maxWidth, maxHeight)];
    }
    
    return CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
}

@end