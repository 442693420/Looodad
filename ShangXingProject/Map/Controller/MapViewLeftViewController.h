//
//  MapViewLeftViewController.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/14.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MapViewLeftViewControllerDelegate<NSObject>
- (void)mapViewLeftViewControllerTableViewCellDidSelected:(NSIndexPath *)cellIndexPath;
@end
@interface MapViewLeftViewController : UIViewController
@property (nonatomic,weak) id<MapViewLeftViewControllerDelegate> delegate;

@end
