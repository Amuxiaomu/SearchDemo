//
//  Utils.m
//  SearchDemo
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (NSString *)getPinyinWithString:(NSString *)string{
   
    NSString * pinyin;
    if ([string length]) {
        NSMutableString * ms = [[NSMutableString alloc] initWithString:string];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        if (CFStringTransform( (__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        
        }
        pinyin = ms;
    }
    return pinyin;
}

+ (NSString *)getFirstLetterWithString:(NSString *)string{
   
    NSString * regex = @"^[a-zA-Z]*$";
    NSString * firstLetter = [string substringToIndex:1];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:firstLetter] == YES) {
        return [firstLetter uppercaseString];
    }else {
        return @"~";
    }
}
@end
