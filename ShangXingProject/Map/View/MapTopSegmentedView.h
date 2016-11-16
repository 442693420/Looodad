//
//  MapTopSegmentedView.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MapTopSegmentedViewDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param index       当前view的索引
 */
- (void)MapTopSegmentedViewDidSelectItemWithIndex:(NSInteger)index;

@end
@interface MapTopSegmentedView : UIView
/**
 *  初始化方法1
 *  在屏幕内最多显示的标题个数默认为3个
 *
 *  @param frame
 *  @param titleArr     标题数组    -> @[@"标题1",@"标题2",@"标题3"],
 *
 */
-(instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArr;

@property (nonatomic ,weak) id <MapTopSegmentedViewDelegate> delegate;
@end
