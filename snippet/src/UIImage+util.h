//
//  UIImage+util.h
//  snippet
//
//  Created by lili on 14-9-17.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (util)
//修改图片底色生成新的图片
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;

@end
