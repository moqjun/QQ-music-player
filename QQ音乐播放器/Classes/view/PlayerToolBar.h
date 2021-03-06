//
//  BottomView.h

//
//  Created by mqj on 15-2-20.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music,PlayerToolBar;

typedef enum {
 PlayerBtnTypeIcon,//头像
 PlayerBtnTypePlay,//播放
 PlayerBtnTypePause,//暂停
 PlayerBtnTypePrev,//上一首
 PlayerBtnTypeNext,//下一首
}PlayerBtnType;

@protocol PlayerToolBarDelegate <NSObject>

-(void)playerToolBar:(PlayerToolBar *)toolBar btnClickWithType:(PlayerBtnType)btnType;
-(void) doSwitchToFullScreenPlayerController:(PlayerToolBar*) toolBar;

@end


@interface PlayerToolBar : UIView

+(instancetype)toolBar;

/**
 * 播放按钮的状态，默认是停止播放
 */
@property(nonatomic,assign,readonly,getter=isPlaying)BOOL playing;

/**
 * 当前播放音乐
 */
@property(nonatomic,strong)Music *playingMusic;

/**
 * 按钮点击代理
 */
@property(nonatomic,weak)id<PlayerToolBarDelegate> delegate;

@end
