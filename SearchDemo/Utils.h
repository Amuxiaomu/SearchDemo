//
//  Utils.h
//  SearchDemo
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject

/**
 *  汉子转拼音
 */
+ (NSString *)getPinyinWithString:(NSString *)string;

/**
 *  获取字符串首字母, 如果首字母非字母 返回"~"
 */
+ (NSString *)getFirstLetterWithString:(NSString *)string;

@end
