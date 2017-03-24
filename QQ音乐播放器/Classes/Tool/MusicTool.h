


//
//  Created by mqj on 16-12-21.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Singleton.h"
@class Music;

@interface MusicTool : NSObject

singleton_interface(MusicTool)

@property (nonatomic,strong) AVAudioPlayer *player;

/**
 * 播放一首新的音乐时，必须先调用此方法
 */
-(void)prepareToPlayWithMusic:(Music *)music;


/**
 * 播放音乐
 */
-(void)play;

/**
 * 暂停
 */
-(void)pause;
@end
