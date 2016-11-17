//
//  ImgListCollectionViewCell.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "ImgListCollectionViewCell.h"

@implementation ImgListCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.distanceLab];
        [self.contentView addSubview:self.roadImgView];
        [self.contentView addSubview:self.roadLab];
        [self.contentView addSubview:self.speedLab];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
            make.height.equalTo(@20);
        }];
        [self.roadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.speedLab.mas_left);
            make.width.height.equalTo(@20);
            make.bottom.equalTo(self.speedLab.mas_top).offset(-3);
        }];
        [self.roadLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.roadImgView.mas_right).offset(3);
            make.centerY.equalTo(self.roadImgView.mas_centerY);
            make.height.equalTo(@20);
        }];
        [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.speedLab.mas_left);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.roadImgView.mas_top).offset(-3);
        }];
        
 
    }
    return self;
}
#pragma mark getter and setter
-(UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.backgroundColor = [UIColor cyanColor];
    }
    return _imgView;
}
-(UILabel *)distanceLab{
    if (_distanceLab == nil) {
        _distanceLab = [[UILabel alloc]init];
        _distanceLab.text = @"1.7km";
        _distanceLab.font = [UIFont systemFontOfSize:16];
        _distanceLab.textColor = [UIColor whiteColor];
    }
    return _distanceLab;
}
-(UIImageView *)roadImgView{
    if (_roadImgView == nil) {
        _roadImgView = [[UIImageView alloc]init];
        _roadImgView.backgroundColor = [UIColor redColor];
    }
    return _roadImgView;
}
-(UILabel *)roadLab{
    if (_roadLab == nil) {
        _roadLab = [[UILabel alloc]init];
        _roadLab.text = @"康虹路";
        _roadLab.font = [UIFont systemFontOfSize:14];
        _roadLab.textColor = [UIColor whiteColor];
    }
    return _roadLab;
}
-(UILabel *)speedLab{
    if (_speedLab == nil) {
        _speedLab = [[UILabel alloc]init];
        _speedLab.text = @"45km/h";
        _speedLab.font = [UIFont systemFontOfSize:14];
        _speedLab.textColor = [UIColor whiteColor];
    }
    return _speedLab;
}
@end
