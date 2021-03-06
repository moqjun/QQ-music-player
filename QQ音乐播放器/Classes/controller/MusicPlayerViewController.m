//
//  MusicPlayerViewController.m

//
//  Created by mqj on 15-2-20.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "PlayerToolBar.h"
#import "MJExtension.h"
#import "Music.h"
#import "MusicTool.h"
#import "MusicCell.h"
#import "AppDelegate.h"

#import "MQFullScreenPlayerViewController.h"

@interface MusicPlayerViewController()<UITableViewDataSource,PlayerToolBarDelegate,UITableViewDelegate,AVAudioPlayerDelegate>
/**
 * 播放工具条
 */
@property(nonatomic,strong)PlayerToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 * 音乐数组
 */
@property(nonatomic,strong)NSArray *musics;

/**
 * 音乐播放工具类
 */
@property(nonatomic,strong)MusicTool *musicTool;

/**
 * 当前播放音乐的索引,默认为0
 */
@property(nonatomic,assign)NSInteger playingIndex;
@end

@implementation MusicPlayerViewController

/**
 * 加载songs.plist文件数据
 */
-(NSArray *)musics{
    if (!_musics) {
        _musics = [Music objectArrayWithFilename:@"songs.plist"];
    }
    
    return _musics;
}

-(MusicTool *)musicTool{
    if (!_musicTool) {
        _musicTool = [MusicTool sharedMusicTool];
    }
    
    return _musicTool;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //隐藏导航栏
    //self.navigationController.navigationBarHidden = YES;
    [self fullScreenBtn];
    //添加顶部View
    self.toolBar = [PlayerToolBar toolBar];
    self.toolBar.delegate = self;
    [self.bottomContainer addSubview:self.toolBar];
    
    //设置表格透明
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self prepareForMusic];
    
    //设置回调block
    ((AppDelegate *)[UIApplication sharedApplication].delegate).remoteBlock = ^(UIEvent *event){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlNextTrack:
                [self next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previous];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.musicTool pause];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self.musicTool play];
                break;
        }
    };
    
}

-(void) fullScreenBtn
{
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [btn setTitle:@"全屏模式播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onPlayFullScreen) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item;
}
-(void)onPlayFullScreen
{
    [self.musicTool pause];
    MQFullScreenPlayerViewController *fsvc =[[MQFullScreenPlayerViewController alloc] init];
    
    [self.navigationController pushViewController:fsvc animated:YES];
}

/**
 * 音乐播放前的准备
 */
-(void)prepareForMusic{
    // 1.初始化音乐播放器
    [self.musicTool prepareToPlayWithMusic:self.musics[self.playingIndex]];
    
    // 2.默认在播放工具类中显示第一首的数据
    self.toolBar.playingMusic = self.musics[self.playingIndex];
    
    
    
    if (self.toolBar.isPlaying) {
        [self.musicTool play];
    }
    
    //设置播放器代理
    self.musicTool.player.delegate = self;
}
#pragma mark -表格数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell = [MusicCell cellWithTableView:tableView];
    
    //显示模型数据
    [cell setMusic:self.musics[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.playingIndex = indexPath.row;
    [self prepareForMusic];
}
#pragma mark toolbar代理

-(void)playerToolBar:(PlayerToolBar *)toolBar btnClickWithType:(PlayerBtnType)btnType{
    switch (btnType) {
        case PlayerBtnTypePlay://播放
            [self.musicTool play];
            break;
        case PlayerBtnTypePause://暂停
            [self.musicTool pause];
            break;
        case PlayerBtnTypePrev://上一首
            [self previous];
            break;
        case PlayerBtnTypeNext://下一首
            [self next];
            break;
        default:
            break;
    }
}

-(void)previous{
    if (self.playingIndex == 0) {//第一首
        self.playingIndex = self.musics.count - 1;
    }else{
        self.playingIndex --;
    }
    
    [self prepareForMusic];
    

}
-(void)next{
    if (self.playingIndex == self.musics.count - 1) {//最后一首
        self.playingIndex = 0;
    }else{
        self.playingIndex ++;
    }
    
    [self prepareForMusic];
}


#pragma mark 播放完成
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放完成，自动下一首音乐
    [self next];

}

#pragma mark 切换到全屏播放
-(void) doSwitchToFullScreenPlayerController:(PlayerToolBar *)toolBar
{
    
    NSLog(@"全屏模式暂时没做");
}

@end
