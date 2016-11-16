//
//  MapBottomView.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/14.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MapBottomViewDelegate<NSObject>
- (void)mapBottomViewUpDownBtnClick;
- (void)mapBottomViewVideoBtnClick;
- (void)mapBottomViewImageBtnClick;
- (void)mapBottomViewTextFieldRightBtnClick;

@end

@interface MapBottomView : UIView
@property (nonatomic,assign)id <MapBottomViewDelegate>delegate;
@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UIButton *videoBtn;
@property (nonatomic , strong)UIButton *imageBtn;
@end
