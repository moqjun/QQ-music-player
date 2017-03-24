
//
//  Created by mqj on 16-12-21.
//  Copyright (c) 2016年 Fung. All rights reserved.
//

#import "MusicCell.h"
#import "Music.h"
@implementation MusicCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"Music";
    return [tableView dequeueReusableCellWithIdentifier:ID];
}

-(void)setMusic:(Music *)msc{
    //显示模型数据
    self.textLabel.text = msc.name;
    self.detailTextLabel.text = msc.singer;
}
@end
