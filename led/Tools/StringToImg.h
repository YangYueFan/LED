//
//  StringToImg.h
//  led
//
//  Created by 科技部iOS on 2018/3/23.
//  Copyright © 2018年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringToImg : NSObject

+(UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment;

@end
