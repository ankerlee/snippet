//
//  UIView+image.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <UIKit/UIKit.h>

@interface UIView (image)
- (UIImage*)screenshot;
- (UIImage*)screenshotWithOptimization:(BOOL)optimized;
@end
