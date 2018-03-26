//
//  UIImage+Pixel.h
//  led
//
//  Created by 科技部iOS on 2018/3/23.
//  Copyright © 2018年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Pixel)
//获取某个点像素RGBA
- (UIColor *)colorAtPixel:(CGPoint)point;

//获取点像素RGBA数组
- (NSMutableArray *)colorAtPixelPoints:(CGFloat)pixelW;

//改变ImageSize
- (UIImage *)imageToSize:(CGSize)newSize;
@end
