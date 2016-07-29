//
//  NSString+pinyin.h
//  SearchDemo
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pinyin)

/**
 *  拼音 -> pinyin
 */
- (NSString *)transformToPinyin;

/**
 *  拼音首字母 -> py
 */
- (NSString *)transformToPinyinFirstLetter;
@end
