//
//  CarDataObject.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/19.
//  Copyright © 2016年 张浩. All rights reserved.
//小车信息

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CarDataObject : NSObject
@property (nonatomic , assign)NSInteger duringTime;
@property (nonatomic , assign)NSInteger count;
@property (nonatomic , assign)CLLocationCoordinate2D *coords;
@property (nonatomic , strong)NSMutableArray *tracking;
@end
