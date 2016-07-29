//
//  UserDTO.h
//  SearchDemo
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDTO : NSObject
/**
 *  昵称 要搜索的文字
 like 苹果电脑
 */
@property (nonatomic, copy) NSString * name;

/**
 *  昵称的pinyin 获取的时候就应该转为拼音了
    like pingguodiannao
 */
@property (nonatomic, copy) NSString * namePinYin;

/**
 *  昵称的拼音首字母
    like pgdn
 */
@property (nonatomic, copy) NSString * nameFirstLetter;
@end
