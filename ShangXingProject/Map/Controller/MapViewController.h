//
//  MapViewController.h
//  MapTestDemo
//
//  Created by 张浩 on 2016/11/3.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapViewController : UIViewController
@property (nonatomic,retain) MAUserLocation *currentLocation;
@property (nonatomic,retain) AMapPOI *currentPOI;

@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点
@end
