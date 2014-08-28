//
//  UIView+nib.m
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import "UIView+nib.h"
#import <objc/runtime.h>

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation UIView (nib)

+ (id)viewFromNibNamed:(NSString *)nibName
{
    NSArray *nibViews = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(nibName)]) {
            return object;
        }
    }
    if (nibViews) {
        return [nibViews objectAtIndex:0];
    }
    return nil;
}

+ (id)viewFromNibNamed:(NSString *)nibName viewName:(NSString *)viewName
{
    NSArray *nibViews = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(viewName)]) {
            return object;
        }
    }
    if (viewName == nil && nibViews) {
        return [nibViews objectAtIndex:0];
    }
    return nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSArray *nibViews = [(nibBundleOrNil ? nibBundleOrNil : [NSBundle mainBundle]) loadNibNamed:nibNameOrNil owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(nibNameOrNil)]) {
            self = object;
        }
    }
    return self;
}

@end
