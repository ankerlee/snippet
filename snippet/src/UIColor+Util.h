//
//  UIColor+Util.h
//  snippet
//
//  Created by lili on 14-9-17.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

/**
 *  加深颜色
 *
 *  @param value 加深值
 *
 *  @return 加深后的新颜色
 */
- (UIColor *)colorByDarkeningColorWithValue:(CGFloat)value;

@end
