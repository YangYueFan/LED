//
//  UIImage+Pixel.m
//  led
//
//  Created by 科技部iOS on 2018/3/23.
//  Copyright © 2018年 Ken. All rights reserved.
//

#import "UIImage+Pixel.h"

@implementation UIImage (Pixel)

- (UIColor *)colorAtPixel:(CGPoint)point {
    
    // Cancel if point is outside image coordinates
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        
        return nil;
        
    }
    
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = self.CGImage;
    
    NSUInteger width = self.size.width;
    
    NSUInteger height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}


-(UIImage *)imageToSize:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (NSMutableArray *)colorAtPixelPoints:(CGFloat)pixelW{

    CGImageRef cgimage = [self CGImage];
    size_t width = self.size.width; // 图片宽度
    size_t height = self.size.height; // 图片高度
    
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间

    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(space);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    NSMutableArray *colors = [NSMutableArray array];
    for (size_t i = pixelW/2.0; i < height; i+=pixelW)
    {
        NSMutableArray *colorSubArr = [NSMutableArray array];
        for (size_t j = pixelW/2.0; j < width; j+=pixelW)
        {
            size_t pixelIndex = i * width * 4 + j * 4;

            CGFloat red = (CGFloat)data[pixelIndex] / 255.0f;
            
            CGFloat green = (CGFloat)data[pixelIndex+1] / 255.0f;
            
            CGFloat blue = (CGFloat)data[pixelIndex+2] / 255.0f;
            
            CGFloat alpha = (CGFloat)data[pixelIndex+3] / 255.0f;
            
            [colorSubArr addObject:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]] ;
        }
        [colors addObject:colorSubArr];
    }
    return colors;
}


@end
