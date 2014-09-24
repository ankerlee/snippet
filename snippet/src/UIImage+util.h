//
//  UIImage+util.h
//  snippet
//
//  Created by lili on 14-9-17.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (util)
/**
 *  变色
 *
 *  @param maskColor 颜色
 *
 *  @return 变色后的新图片
 */
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
/**
 *  转向【方向：镜像】
 *
 *  @return 转向后的新图片
 */
- (UIImage *)imageFlippedHorizontal;
/**
 *  拉伸
 *
 *  @param capInsets 拉伸区域
 *
 *  @return 拉伸后的新图片
 */
- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;
/**
 *  切圆
 *
 *  @param clipToCircle 是否切圆
 *  @param diameter     圆直径
 *  @param borderColor  边框颜色
 *  @param borderWidth  边框宽度
 *  @param shadowOffset 阴影范围
 *
 *  @return 切圆后的新图片
 */
- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset;
@end
