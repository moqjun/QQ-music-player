//utf-8;134217984
//
//  Created by mqj on 16-12-21.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
/**
 * 歌曲名字
 */
@property(nonatomic,copy)NSString *name;
/**
 * 本地音乐文件名
 */
@property(nonatomic,copy)NSString *filename;

/**
 * 歌手名字
 */
@property(nonatomic,copy)NSString *singer;

/**
 * 歌手相片
 */
@property(nonatomic,copy)NSString *singerIcon;

/**
 * 专辑图片
 */
@property(nonatomic,copy)NSString *icon;
@end
