//
//  UIView+event.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <UIKit/UIKit.h>

@interface UIView (event)

- (void)setTapActionWithBlock:(void (^)(void))block;
- (void)setLongPressActionWithBlock:(void (^)(void))block;

@end
