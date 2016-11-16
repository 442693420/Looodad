//
//  MapLeftViewTitleView.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "MapLeftViewTitleView.h"

@implementation MapLeftViewTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.titleImgView];
        [self addSubview:self.nickNameLab];
        [self addSubview:self.infoLab];
        [self addSubview:self.carImgView];
        [self addSubview:self.idLab];
        [self addSubview:self.scoreLab];
        [self addSubview:self.editBtn];
        
        [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.width.height.equalTo(@80);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleImgView.mas_right).offset(8);
            make.top.equalTo(self.titleImgView.mas_top);
            make.height.equalTo(@20);
            make.right.equalTo(self.carImgView.mas_left).offset(-8);
        }];
        [self.carImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nickNameLab.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@30);
            make.right.equalTo(self.mas_right).offset(-8).priorityLow();
        }];
        [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameLab.mas_left);
            make.centerY.equalTo(self.editBtn.mas_centerY);
            make.height.equalTo(@20);
            make.right.equalTo(self.editBtn.mas_left).offset(-8);
        }];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleImgView.mas_centerY);
            make.height.width.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-8);
        }];
        [self.idLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoLab.mas_left);
            make.bottom.equalTo(self.titleImgView.mas_bottom);
            make.height.equalTo(@20);
        }];
        [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idLab.mas_right).offset(8);
            make.right.equalTo(self.editBtn.mas_right);
            make.centerY.equalTo(self.idLab.mas_centerY);
            make.width.equalTo(self.idLab.mas_width);
            make.height.equalTo(@20);
        }];
    }
    return self;
}
#pragma mark getter and setter
-(UIImageView *)titleImgView{
    if (_titleImgView == nil) {
        _titleImgView = [[UIImageView alloc]init];
        _titleImgView.backgroundColor = [UIColor redColor];
    }
    return _titleImgView;
}
-(UILabel *)nickNameLab{
    if (_nickNameLab == nil) {
        _nickNameLab = [[UILabel alloc]init];
        _nickNameLab.text = @"昵称";
        _nickNameLab.font = [UIFont systemFontOfSize:16];
        _nickNameLab.textColor = [UIColor blackColor];
    }
    return _nickNameLab;
}
-(UIImageView *)carImgView{
    if (_carImgView == nil) {
        _carImgView = [[UIImageView alloc]init];
        _carImgView.backgroundColor = [UIColor redColor];
    }
    return _carImgView;
}
-(UILabel *)infoLab{
    if (_infoLab == nil) {
        _infoLab = [[UILabel alloc]init];
        _infoLab.text = @"这个人很懒，什么都没有留下";
        _infoLab.font = [UIFont systemFontOfSize:14];
        _infoLab.textColor = [UIColor lightGrayColor];
    }
    return _infoLab;
}
-(UILabel *)idLab{
    if (_idLab == nil) {
        _idLab = [[UILabel alloc]init];
        _idLab.text = @"ID:";
        _idLab.font = [UIFont systemFontOfSize:14];
        _idLab.textColor = [UIColor lightGrayColor];
        _idLab.layer.masksToBounds = YES;
        _idLab.layer.cornerRadius = 10;
        _idLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _idLab.layer.borderWidth = 1;
        _idLab.textAlignment = NSTextAlignmentCenter;
    }
    return _idLab;
}
-(UILabel *)scoreLab{
    if (_scoreLab == nil) {
        _scoreLab = [[UILabel alloc]init];
        _scoreLab.text = @"积分:";
        _scoreLab.font = [UIFont systemFontOfSize:14];
        _scoreLab.textColor = [UIColor lightGrayColor];
        _scoreLab.layer.masksToBounds = YES;
        _scoreLab.layer.cornerRadius = 10;
        _scoreLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _scoreLab.layer.borderWidth = 1;
        _scoreLab.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLab;
}
-(UIButton *)editBtn{
    if (_editBtn == nil) {
        _editBtn = [[UIButton alloc]init];
        _editBtn.backgroundColor = [UIColor redColor];
    }
    return _editBtn;
}
@end
