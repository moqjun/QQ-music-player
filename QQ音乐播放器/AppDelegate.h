//
//  AppDelegate.h
//  QQ音乐播放器
//
//  Created by mac on 16/4/14.
//  Copyright (c) 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RemoteBlock)(UIEvent *event);
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * 一个回调远程事件的block
 */
@property(nonatomic,copy)RemoteBlock remoteBlock;

@end

