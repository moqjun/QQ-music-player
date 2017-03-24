//
//  MQNavigationController.m
//  QQ音乐播放器
//
//  Created by mac on 16/4/14.
//  Copyright (c) 2016年 mac. All rights reserved.
//

#import "MQNavigationController.h"

@interface MQNavigationController ()

@end

@implementation MQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void) initialize
{
    // 设置主题
    
    /**设置导航条的背景图片注意点
     * 1.在ios7以上，背景图片的高度一定要64(点)
     * 2.背景图片的宽度无限制，1点，自动会拉伸
     * 3.如果是通过导航控制器获取的导航条来设置背景，它是局部
     *   self.navigationController.navigationBar
     * 4.如果想设置一次导航栏的背景，这个导航条的对象，通过导航条的一个类方法获取的就可以 [UINavigationBar appearance]
     
     */
    // 设置当前导航控制器的背景
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    //#warning 一般设置导航条背景，不会在导航控制器的子控制器里设置
    // 1.设置导航条的背题图片 --- 设置全局 （既是手机端的上面部分）
    UINavigationBar *navBar = [UINavigationBar appearance];
    //[navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    //[navBar setBackgroundColor:[UIColor colorWithRed:44/255.0 green:90/255.0 blue:163/255.0 alpha:1.0]];
//        navBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:150/255.0 blue:243/255.0 alpha:1.0];
        navBar.barTintColor = [UIColor colorWithRed:125/255.0 green:177/255.0 blue:200/255.0 alpha:1.0];
    
    // 2.UIApplication设置状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 3.设置导航条标题的字体和颜色
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:20]
                                };
    [navBar setTitleTextAttributes:titleAttr];
    
    
    
    //设置返回按钮的样式
    //tintColor是用于导航条的所有Item
    navBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *navItem = [UIBarButtonItem appearance];
    
    //
    //是改变整个按钮背影
    
    // [navItem setBackButtonBackgroundImage:[UIImage imageNamed:@"ic_setting_menu1"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //设置Item的字体大小
    [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
}

#pragma mark 导航控制器的子控制器被pop[移除]的时候会调用
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    // NSLog(@"%s",__func__);
    return [super popViewControllerAnimated:animated];
}

#pragma mark 导航控制器的子控制器被push 的时候会调用
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // NSLog(@"%s",__func__);
    //设置 push 新控制器的时候 隐藏Tabbar
    viewController.hidesBottomBarWhenPushed = YES;
    
    return [super pushViewController:viewController animated:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
