//
//  ImgListCollectionViewCell.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgListCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong)UIImageView *imgView;
@property (nonatomic , strong)UILabel *distanceLab;
@property (nonatomic , strong)UIImageView *roadImgView;
@property (nonatomic , strong)UILabel *roadLab;
@property (nonatomic , strong)UILabel *speedLab;

@end
