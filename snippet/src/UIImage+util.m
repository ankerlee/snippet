//
//  UIImage+util.m
//  snippet
//
//  Created by lili on 14-9-17.
//
//

#import "UIImage+util.h"

@implementation UIImage (util)

-(UIImage *)imageMaskedWithColor:(UIColor *)maskColor{
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
    CGContextClipToMask(context, imageRect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageFlippedHorizontal
{
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets
                                resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)imageAsCircle:(BOOL)clipToCircle
                  withDiamter:(CGFloat)diameter
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)borderWidth
                 shadowOffSet:(CGSize)shadowOffset
{
    // increase given size for border and shadow
    CGFloat increase = diameter * 0.1f;
    CGFloat newSize = diameter + increase;
    
    CGRect newRect = CGRectMake(0.0f,
                                0.0f,
                                newSize,
                                newSize);
    
    // fit image inside border and shadow
    CGRect imgRect = CGRectMake(increase,
                                increase,
                                newRect.size.width - (increase * 2.0f),
                                newRect.size.height - (increase * 2.0f));
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // draw shadow
    if (!CGSizeEqualToSize(shadowOffset, CGSizeZero)) {
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(shadowOffset.width, shadowOffset.height),
                                    2.0f,
                                    [UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
    }
    
    // draw border
    if (borderColor && borderWidth) {
        CGPathRef borderPath = (clipToCircle) ? CGPathCreateWithEllipseInRect(imgRect, NULL) : CGPathCreateWithRect(imgRect, NULL);
        CGContextAddPath(context, borderPath);
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGPathRelease(borderPath);
    }
    
    CGContextRestoreGState(context);
    
    if (clipToCircle) {
        UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:imgRect];
        [imgPath addClip];
    }
    
    [self drawInRect:imgRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark -通过图片上的path,获取图片  rect为path相对于UIimage所在矩形区域
- (UIImage *)clipImageWithCGPath:(CGPathRef)ref rect:(CGRect)rect
{
    UIImage *maskImage = [self generateMaskImage:ref];
    UIImage *clipImage = [self clipImageWithMaskImage:maskImage];
    UIImage *targetImage = [self clipImage:clipImage rect:rect];
    return targetImage;
}
- (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将画图的起点移动到image.size.height
    CGContextTranslateCTM(context, 0, self.size.height);
    //然后将图片沿y轴翻转
    CGContextScaleCTM(context, 1, -1.0);
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.0f);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height));
    //CGContextClearRect(context, self.bounds);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), image.CGImage);
    CGContextRestoreGState(context);
    
    UIImage *imageas = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //NSLog(@"imageas    %@", NSStringFromCGSize(imageas.size));
    //UIImageWriteToSavedPhotosAlbum(imageas, nil, nil, nil);
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(imageas.CGImage,CGRectMake(rect.origin.x * [UIScreen mainScreen].scale, rect.origin.y * [UIScreen mainScreen].scale, rect.size.width * [UIScreen mainScreen].scale, rect.size.height * [UIScreen mainScreen].scale));
    
    UIImage *imgReturn = [UIImage imageWithCGImage:imgRef];
    //UIImageWriteToSavedPhotosAlbum(imgReturn, nil, nil, nil);
    //NSLog(@"imgReturn   %@", NSStringFromCGSize(imgReturn.size));
    
    CGImageRelease(imgRef);
    return imgReturn;
}

- (UIImage *)clipImageWithMaskImage:(UIImage *)mask{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将画图的起点移动到image.size.height
    CGContextTranslateCTM(context, 0, self.size.height);
    //然后将图片沿y轴翻转
    CGContextScaleCTM(context, 1, -1.0);
    CGContextSaveGState(context);
    CGContextClearRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), mask.CGImage);
    
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height),self.CGImage);
    CGContextRestoreGState(context);
    UIImage *imageas = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageas;
}

//生产路径范围内图片
- (UIImage *)generateMaskImage:(CGPathRef)clipPath {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, clipPath);
    CGContextDrawPath(context,kCGPathFill);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -
+ (UIImage *)imageWithView:(UIView *)view{
    CGSize size = view.bounds.size;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)thumbImageWithSize:(CGSize)size{
    CGRect imageRect = rectDraw(((CGRect){CGPointZero,size}), self.size);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, imageRect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)saveJpegImage:(NSString *)path{
    NSData *data = UIImageJPEGRepresentation(self, 0.8);
    if (data) {
        if ([data writeToFile:path atomically:YES]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)savePngImage:(NSString *)path{
    NSData *data = UIImagePNGRepresentation(self);
    if (data) {
        if ([data writeToFile:path atomically:YES]) {
            return YES;
        }
    }
    return NO;
}


//- (UIImage*)flipHorizontal//改变UIimage.imageOrientation属性 之后调用rotateImage: 保存的图片才会和显示的翻转图片保持一致
//{
//    UIImage *image = nil;
//    switch (self.imageOrientation) {
//        case UIImageOrientationUp:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
//            break;
//        }
//        case UIImageOrientationDown:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
//            break;
//        }
//        case UIImageOrientationLeft:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRightMirrored];
//            break;
//        }
//        case UIImageOrientationRight:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeftMirrored];
//            break;
//        }
//        case UIImageOrientationUpMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUp];
//            break;
//        }
//        case UIImageOrientationDownMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDown];
//            break;
//        }
//        case UIImageOrientationLeftMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRight];
//            break;
//        }
//        case UIImageOrientationRightMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeft];
//            break;
//        }
//        default:
//            break;
//    }
//    return image;
//}
//
//- (UIImage*)flipVertical//改变UIimage.imageOrientation属性 之后调用rotateImage: 保存的图片才会和显示的翻转图片保持一致
//{
//    UIImage *image = nil;
//    switch (self.imageOrientation) {
//        case UIImageOrientationUp:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
//            break;
//        }
//        case UIImageOrientationDown:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
//            break;
//        }
//        case UIImageOrientationLeft:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeftMirrored];
//            break;
//        }
//        case UIImageOrientationRight:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRightMirrored];
//            break;
//        }
//        case UIImageOrientationUpMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDown];
//            break;
//        }
//        case UIImageOrientationDownMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUp];
//            break;
//        }
//        case UIImageOrientationLeftMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeft];
//            break;
//        }
//        case UIImageOrientationRightMirrored:
//        {
//            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRight];
//            break;
//        }
//        default:
//            break;
//    }
//    
//    return image;
//}
//
//+(UIImage *)rotateImage:(UIImage *)aImage//
//
//{
//    
//    CGImageRef imgRef = aImage.CGImage;
//    
//    CGFloat width = CGImageGetWidth(imgRef);
//    
//    CGFloat height = CGImageGetHeight(imgRef);
//    
//    
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    CGRect bounds = CGRectMake(0, 0, width, height);
//    
//    
//    
//    CGFloat scaleRatio = 1;
//    
//    
//    
//    CGFloat boundHeight;
//    
//    UIImageOrientation orient = aImage.imageOrientation;
//    
//    switch(orient)
//    
//    {
//            
//        case UIImageOrientationUp: //EXIF = 1
//            
//            transform = CGAffineTransformIdentity;
//            
//            break;
//            
//            
//            
//        case UIImageOrientationUpMirrored: //EXIF = 2
//            
//            transform = CGAffineTransformMakeTranslation(width, 0.0);
//            
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationDown: //EXIF = 3
//            
//            transform = CGAffineTransformMakeTranslation(width, height);
//            
//            transform = CGAffineTransformRotate(transform, M_PI);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationDownMirrored: //EXIF = 4
//            
//            transform = CGAffineTransformMakeTranslation(0.0, height);
//            
//            transform = CGAffineTransformScale(transform, 1.0, -1.0);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationLeftMirrored: //EXIF = 5
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(height, width);
//            
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationLeft: //EXIF = 6
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(0.0, width);
//            
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationRightMirrored: //EXIF = 7
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeScale(-1.0, 1.0);
//            
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            
//            break;
//            
//            
//            
//        case UIImageOrientationRight: //EXIF = 8
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(height, 0.0);
//            
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            
//            break;
//            
//            
//            
//        default:
//            
//            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//            
//    }
//    
//    
//    
//    UIGraphicsBeginImageContext(bounds.size);
//    
//    
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    
//    
//    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
//        
//        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//        
//        CGContextTranslateCTM(context, -height, 0);
//        
//    }
//    
//    else {
//        
//        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//        
//        CGContextTranslateCTM(context, 0, -height);
//        
//    }
//    
//    
//    CGContextConcatCTM(context, transform);
//    
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
//    
//    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return imageCopy;
//    
//}


@end
