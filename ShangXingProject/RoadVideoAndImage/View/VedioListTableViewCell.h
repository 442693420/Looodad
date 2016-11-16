//
//  VedioListTableViewCell.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VedioListTableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *backgroundIV;
@property (strong, nonatomic)UIButton *playBtn;

@property (nonatomic, strong)VideoModel *model;

@end
