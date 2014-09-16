//
//  UIView+nib.h
//  snippet
//
//  Created by lili on 14-8-27.
//
//

#import <UIKit/UIKit.h>

@interface UIView (nib)

+ (id)viewFromNibNamed:(NSString *)nibName;
+ (id)viewFromNibNamed:(NSString *)nibName viewName:(NSString *)viewName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;


@end
