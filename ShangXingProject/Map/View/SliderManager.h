//
//  SliderManager.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SliderManager : NSObject
+ (__nonnull instancetype)sharedManager;
- (void)setupMainController: (UIViewController * __nonnull)mainController;
- (void)setupMenuController: (UIViewController * __nonnull)menuController;
- (void)openOrClose;

@end
