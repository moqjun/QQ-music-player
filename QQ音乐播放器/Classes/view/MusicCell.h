


//
//  Created by mqj on 16-12-21.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;
@interface MusicCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *显示模型数据
 */
-(void)setMusic:(Music *)msc;
@end
