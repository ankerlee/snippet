//
//  UIImage+util.h
//  snippet
//
//  Created by lili on 14-9-17.
//
//

#import <UIKit/UIKit.h>

static inline CGRect rectDraw(CGRect contextRect, CGSize imageSize){//将size  等比放置在contextRect
    CGRect rect;
    if (contextRect.size.width/contextRect.size.height > (imageSize.width/imageSize.height)){// 最高
        rect.size.height = contextRect.size.height;
        rect.size.width = imageSize.width*(contextRect.size.height/imageSize.height);
        rect.origin.x = contextRect.origin.x+(contextRect.size.width-rect.size.width)/2;
        rect.origin.y = contextRect.origin.y;
    }else {// 最宽
        rect.size.width = contextRect.size.width;
        rect.size.height = imageSize.height*(contextRect.size.width/imageSize.width);
        rect.origin.y = contextRect.origin.y + (contextRect.size.height-rect.size.height)/2;
        rect.origin.x = contextRect.origin.x;
    }
    return rect;
}

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

/**
 *  根据路径生成图片
 *
 *  @param ref  路径
 *  @param rect 路径范围
 *
 *  @return 新的图片
 */
- (UIImage *)clipImageWithCGPath:(CGPathRef)ref rect:(CGRect)rect;//根据path生成图片
/**
 *  根据视图生成图片
 *
 *  @param view 视图
 *
 *  @return 新的图片
 */
+ (UIImage *)imageWithView:(UIView *)view;
/**
 *  生成缩略图（等比缩放）
 *
 *  @param size 指定缩放范围
 *
 *  @return 缩略图
 */
- (UIImage *)thumbImageWithSize:(CGSize)size;
/**
 *  生成指定透明度的新图片
 *
 *  @param alpha 不透明度值
 *
 *  @return 新的图片
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
/**
 *  保存PNG格式图片到指定路径
 *
 *  @param path 路径
 *
 *  @return 是否保存成功
 */
- (BOOL)savePngImage:(NSString *)path;
/**
 *  保存JPEG图片到指定路径
 *
 *  @param path 路径
 *
 *  @return 是否保存成功
 */
- (BOOL)saveJpegImage:(NSString *)path;
//- (UIImage*)flipHorizontal;
//- (UIImage*)flipVertical;
//+ (UIImage *)rotateImage:(UIImage *)aImage;
@end
