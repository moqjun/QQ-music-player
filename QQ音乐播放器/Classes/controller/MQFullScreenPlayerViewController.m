//
//  MQFullScreenPlayerViewController.m
//  QQ音乐播放器
//
//  Created by mac on 16/4/14.
//  Copyright (c) 2016年 mac. All rights reserved.
//

#import "MQFullScreenPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface MQFullScreenPlayerViewController ()<AVAudioPlayerDelegate>{
    
    AVAudioPlayer *_player;
    
    UIImageView *_backView;//背景视图
    UIView *_topView;//顶部视图
    UIView *_bottomView;//底部视图
    UIButton *rightButton;//顶部视图的右侧button(点赞)
    UILabel *songLable;//歌曲的lable
    UILabel *singerLable;//歌手的lable
    BOOL isLove[4];
    UIButton *startAndStopBtn;//播放、暂停
    UIButton *nextButton;//下一曲的实现
    UISlider *slider;//滑块 时间进度条
    UILabel *totalLable;//显示总时间的lable
    UILabel *startLable;//歌曲进度的lable
    NSArray *array;//music.plist中的数组
    NSInteger len;
    
    //歌曲的数组
    NSMutableArray *dataArr;
}


@end

static int page = 0;
static int time2 = 0;

@implementation MQFullScreenPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调用BackView背景视图
    [self BackView];
    
    //调用topView 顶部视图
    [self TopView];
    
    //调用BottomView 底部视图
    [self BottomView];
    
    //获取文件值
    [self HuoQuWenJian];
}

//获取文件值
-(void)HuoQuWenJian{
    
    //获取music.plist的路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"music" ofType:@"plist"];
    array = [NSArray arrayWithContentsOfFile:path];
    
    //刷新数据
    [self GaiBianShuZhi];
    
}

//改变数值的方法 刷新数据
-(void)GaiBianShuZhi{
    
    //取到array的第一个元素
    NSDictionary *dic = array[page];
    //取到字典中的每一个元素
    NSString *songStr = [dic objectForKey:@"song"];
    NSString *singerStr = [dic objectForKey:@"singer"];
    NSString *imageStr = [dic objectForKey:@"image"];
    NSString *totalStr = [dic objectForKey:@"total"];
    
    //创建播放器
    NSString *path = [[NSBundle mainBundle] pathForResource:[dic objectForKey:@"url"] ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //初始化AVAudioPlayer实例对象
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    //设置开始的音量
    _player.volume = .5;
    
    //设置当前的时间
    _player.currentTime = 0;
    
    //设置代理
    _player.delegate = self;
    
    //
    BOOL isPlay = [_player prepareToPlay];
    
    if (isPlay) {
        
        [_player play];
        
    }else{
        
        NSLog(@"播放失败");
    }
    
    //
    CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
    
    //添加到NSRunLoop上
    [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //给各个属性赋值
    songLable.text = songStr;
    singerLable.text = singerStr;
    _backView.image = [UIImage imageNamed:imageStr];
    slider.value = 0;
    totalLable.text = totalStr;
    startLable.text = [self floatToStr:slider.value];
    time2 = 0;
    rightButton.selected = isLove[page];
}


//播放完成是调用--------AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self nextButtonAct];
}


-(void)display{
    
    //设置当前的时间label
    startLable.text = [NSString stringWithFormat:@"%02d:%02d",(int)_player.currentTime/60,(int)_player.currentTime%60];
    
    //设置总的时间label
    totalLable.text = [NSString stringWithFormat:@"%02d:%02d",(int)_player.duration/60,(int)_player.duration%60];
    
    //    //设置播放时间的推进
    slider.value = _player.currentTime/_player.duration;
}

//播放暂停startAndStopBtnAct的点击响应事件
-(void)startAndStopBtnAct{
    
    if (_player.playing) {
        
        //暂停播放
        [_player pause];
        
        startAndStopBtn.selected = YES;
        
    }else{
        
        //继续播放
        [_player play];
        startAndStopBtn.selected = NO;
    }
}

//上一曲lastButton的点击响应事件
-(void)lastButtonAct{
    if(page > 0){
        
        page--;
        [self GaiBianShuZhi];
    }else{
        
        page = 3;
        [self GaiBianShuZhi];
    }
}

//下一曲nextButton的点击响应事件
-(void)nextButtonAct{
    len = [array count];
    if(page < len-1){
        page++;
        [self GaiBianShuZhi];
    }else{
        page = 0;
        [self GaiBianShuZhi];
    }
    
}


//浮点型 -->str
-(NSString*)floatToStr:(float)time{
    
    int minute = time/60;
    int second = (int)time%60;
    
    NSString *totalStr = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    
    return totalStr;
}


//时间播放条sliderAct的点击响应事件
-(void)sliderAct{
    
    //设置播放时间的推进
    _player.currentTime = slider.value * _player.duration;
}

#pragma mark  ************//创建底部视图//******************
-(void)BottomView{
    
#pragma mark UIView
    //创建一个UIView
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-100, kScreenW, 100)];
    //设置bottomView的背景颜色
    _bottomView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    //把bottomView给主窗口
    [self.view addSubview:_bottomView];
    
#pragma mark UIButton
    //创建一个播放与暂停的button
    startAndStopBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-60)/2, (100-60)/2, 60, 60)];
    //设置button的背景颜色
    //    startAndStopBtn.backgroundColor = [UIColor redColor];
    //设置button的图片 -- 正常状态
    [startAndStopBtn setImage:[UIImage imageNamed:@"playing_btn_play_n@2x"] forState:UIControlStateSelected];
    //设置button的图片 -- 高亮状态
    [startAndStopBtn setImage:[UIImage imageNamed:@"playing_btn_play_h@2x"] forState:UIControlStateHighlighted];
    //设置button的图片 -- 选中状态
    [startAndStopBtn setImage:[UIImage imageNamed:@"playing_btn_pause_n@2x"] forState:UIControlStateNormal];
    //把它给底部视图 bottomView
    [_bottomView addSubview:startAndStopBtn];
    
    //添加点击响应事件
    [startAndStopBtn addTarget:self action:@selector(startAndStopBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    //创建上一曲的 button
    UIButton *lastButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-60)/2-50-15, (100-50)/2, 50, 50)];
    //给button设置颜色
    //    lastButton.backgroundColor = [UIColor redColor];
    //把button给底部视图
    [_bottomView addSubview:lastButton];
    //给button设置背景图片 -- 正常状态
    [lastButton setImage:[UIImage imageNamed:@"playing_btn_pre_n@2x"] forState:UIControlStateNormal];
    //给button设置背景图片 -- 高亮状态
    [lastButton setImage:[UIImage imageNamed:@"playing_btn_pre_h@2x"] forState:UIControlStateHighlighted];
    //添加点击响应事件
    [lastButton addTarget:self action:@selector(lastButtonAct) forControlEvents:UIControlEventTouchUpInside];
    
    //创建下一曲的 button
    nextButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-60)/2+50+25, (100-50)/2, 50, 50)];
    //给button设置颜色
    //    nextButton.backgroundColor = [UIColor redColor];
    //把button给底部视图
    [_bottomView addSubview:nextButton];
    //给button设置背景图片 -- 正常状态
    [nextButton setImage:[UIImage imageNamed:@"playing_btn_next_n@2x"] forState:UIControlStateNormal];
    //给button设置背景图片 -- 高亮状态
    [nextButton setImage:[UIImage imageNamed:@"playing_btn_next_h@2x"] forState:UIControlStateHighlighted];
    //添加点击响应时间
    [nextButton addTarget:self action:@selector(nextButtonAct) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark UISlider
    //创建一个时间进度条 UISlider
    slider = [[UISlider alloc]initWithFrame:CGRectMake(0, -5 ,kScreenW, 10)];
    //把slider给底部窗口
    [_bottomView addSubview:slider];
    
    UIImage *image = [[UIImage imageNamed:@"playing_slider_play_left@2x"]stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [slider setMinimumTrackImage:image forState:UIControlStateNormal];
    
    //给slider设置一个背景图片
    [slider setThumbImage:[UIImage imageNamed:@"com_thumb_max_n-Decoded"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderAct) forControlEvents:UIControlEventValueChanged];
#pragma mark UILable
    //创建显示时间的lable
    totalLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-50, 5, 50, 20)];
    //文本的显示颜色
    totalLable.textColor = [UIColor whiteColor];
    //把它给底部视图
    [_bottomView addSubview:totalLable];
    
    //创建显示时间的lable
    startLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50, 20)];
    //文本的显示颜色
    startLable.textColor = [UIColor whiteColor];
    //把它给底部视图
    [_bottomView addSubview:startLable];
    
}

#pragma mark  ************//创建背景视图//******************
-(void)BackView{
    
    //创建背景View
    _backView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //设置背景颜色
    _backView.backgroundColor = [UIColor whiteColor];
    //把背景视图给窗口
    [self.view addSubview:_backView];
    
    //开启UIImageView的触摸响应
    _backView.userInteractionEnabled = YES;
    
    //创建一个隐藏所有控件的button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, _topView.bounds.size.height, kScreenW, kScreenH-64-100)];
    //把这个button放到imageView上
    [_backView addSubview:button];
    button.tag = 1;//标签值
    //创建button的点击响应方法
    [button addTarget:self action:@selector(YinCang) forControlEvents:UIControlEventTouchUpInside];
}
//隐藏的点击响应事件
-(void)YinCang{
    
    UIButton *button = (UIButton*)[_backView viewWithTag:1];
    if(button.selected){
        
        button.selected = NO;
        [UIView animateWithDuration:1 animations:^{
            
            _topView.alpha = 1;
            _bottomView.alpha = 1;
            
        }];
    }else{
        
        button.selected = YES;
        [UIView animateWithDuration:1 animations:^{
            
            _topView.alpha = 0;
            _bottomView.alpha = 0;
            
        }];
    }
}

#pragma mark  ************//创建顶部视图//******************
-(void)TopView{
    
#pragma mark   UIView  顶部视图
    //创建一个顶部视图 View
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    //顶部视图的背景颜色
    _topView.backgroundColor = [UIColor grayColor];
    //顶部视图的透明度
    _topView.alpha = 0.7;
    //把顶部视图给主窗口
    [self.view addSubview:_topView];
    
#pragma mark  UIButton
    //创建一个 左侧button
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    //给button设置一个图片
    [leftButton setImage:[UIImage imageNamed:@"top_back_white@2x"] forState:UIControlStateNormal];
    //把button放到 顶部视图上
    [_topView addSubview:leftButton];
    
    //创建一个 右侧button
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-44-5, 20, 44, 44)];
    //设置button的 正常状态下地 图片
    [rightButton setImage:[UIImage imageNamed:@"playing_btn_love@2x"] forState:UIControlStateNormal];
    //设置button的 高亮 状态下地 图片
    [rightButton setImage:[UIImage imageNamed:@"playing_btn_in_myfavor_h@2x"] forState:UIControlStateHighlighted];
    //设置button的 选中 状态下地 图片
    [rightButton setImage:[UIImage imageNamed:@"playing_btn_in_myfavor@2x"] forState:UIControlStateSelected];
    //把button给顶部视图
    [_topView addSubview:rightButton];
    //设置button的点击方法
    [rightButton addTarget:self action:@selector(RightButtonAct) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark UILable
    
    //创建一个歌曲的lable
    songLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-200)/2, 20, 200, 24)];
    //歌曲的lable背景颜色设置为 绿色
    //    songLable.backgroundColor = [UIColor greenColor];
    //lable的文本
    songLable.text = @"歌曲";
    //lable的设置大小
    songLable.font = [UIFont systemFontOfSize:18];
    //label的文本颜色
    songLable.textColor = [UIColor whiteColor];
    //歌曲的label的文本 居中显示
    songLable.textAlignment = NSTextAlignmentCenter;
    //把歌曲的label给顶部视图
    [_topView addSubview:songLable];
    
    //创建一个歌手的lable
    singerLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-200)/2, 44, 200, 20)];
    //歌手的lable背景颜色设置为 绿色
    //    singerLable.backgroundColor = [UIColor redColor];
    //lable的文本
    //label的文本颜色
    singerLable.textColor = [UIColor whiteColor];
    singerLable.text = @"歌手";
    //lable的设置大小
    //    singerLable.font = [UIFont systemFontOfSize:16];
    //歌曲的label的文本 居中显示
    singerLable.textAlignment = NSTextAlignmentCenter;
    //把歌曲的label给顶部视图
    [_topView addSubview:singerLable];
}
//实现rightButton的点击响应事件
-(void)RightButtonAct{
    
    isLove[page] = !isLove[page];
    if(!isLove[page]){
        
        rightButton.selected = isLove[page];
        NSLog(@"取消收藏");
    }else{
        
        rightButton.selected = isLove[page];
        NSLog(@"收藏成功");
        
        //创建一个 提示信息
        //        UIActionSheet *actionSheet = [UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil;
        
        //创建一个提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否下载" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"取消");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            
            //创建 下载 进度条
            UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.frame = CGRectMake(80,kScreenH - 10 , kScreenW-2*80, 10);
            //已下载的颜色
            progressView.progressTintColor = [UIColor redColor];
            //未下载的颜色
            progressView.trackTintColor = [UIColor greenColor];
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(XiaZaiTiao:) userInfo:progressView repeats:YES];
            [self.view addSubview:progressView];
            
        }]];
        
        
        //        //创建一个 提示框
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
        //        //设置提示框的类型 -- 默认类型
        //        alertView.alertViewStyle =UIAlertActionStyleDefault;
        //        //开启提示框
        //        [alertView show];
    }
}
////提示框的选择方法
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if(buttonIndex == 0){
//
//        NSLog(@"取消");
//    }else if(buttonIndex == 1){
//
//        //创建 下载 进度条
//        UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
//        progressView.frame = CGRectMake(80,kScreenH - 10 , kScreenW-2*80, 10);
//        //已下载的颜色
//        progressView.progressTintColor = [UIColor redColor];
//        //未下载的颜色
//        progressView.trackTintColor = [UIColor greenColor];
//        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(XiaZaiTiao:) userInfo:progressView repeats:YES];
//        [self.view addSubview:progressView];
//    }
//
//}
//下载条的定时器的实现方法
-(void)XiaZaiTiao:(NSTimer*)timer{
    
    UIProgressView *progView = timer.userInfo;
    progView.progress += 0.01;
    if(progView.progress == 1){
        
        [timer invalidate];
        timer = nil;
        
        if(progView.superview != nil){
            
            [progView removeFromSuperview];
        }
        
        
        
        //更新 ------创建提示信息
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载完成" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        
        //        //创建一个提示信息
        //        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"下载完成" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles: nil];
        //        action.actionSheetStyle = UIActionSheetStyleDefault;
        //        //显示信息
        //        [action showInView:self.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
