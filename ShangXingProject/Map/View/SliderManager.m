//
//  SliderManager.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "SliderManager.h"
#define kMaxOpenRatio 0.8
#define kWidth CGRectGetWidth([UIScreen mainScreen].bounds)
@interface SliderManager()
@property (nonatomic , strong) UITapGestureRecognizer *tap;
@property (nonatomic , strong) UISwipeGestureRecognizer *swipe;
@property (nonatomic , strong) UIView *snapView;
@property (nonatomic , assign) BOOL isOpen;
@end
@implementation SliderManager
static SliderManager * sharedManager = nil;
UIViewController * _mainController = nil;
UIViewController * _menuController = nil;
+ (__nonnull instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)setupMainController: (UIViewController *)mainController
{
    [_mainController.view removeGestureRecognizer: self.tap];
    [_mainController.view removeFromSuperview];
    _mainController = mainController;
    
    if (_menuController == nil) { return; }
    [_mainController.view addSubview: _menuController.view];
}

- (void)setupMenuController:(UIViewController *)menuController
{
    [_menuController.view removeGestureRecognizer: self.swipe];
    [_menuController.view removeFromSuperview];
    _menuController = menuController;
    _menuController.view.frame = CGRectOffset([UIScreen mainScreen].bounds, -kWidth, 0);
    [[UIApplication sharedApplication].keyWindow addSubview: _menuController.view];
}

- (void)dealloc
{
    _mainController = nil;
    _menuController = nil;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(close)];
    }
    return _tap;
}
-(UISwipeGestureRecognizer *)swipe{
    if (!_swipe) {
        _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        _swipe.numberOfTouchesRequired = 1;
        // 设置轻扫方向
        _swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipe;
}
- (void)openOrClose
{
    if (_isOpen) {
        [self close];
    } else {
        [self open];
    }
}

- (void)open
{
    _isOpen = YES;
    
    if (_menuController == nil || _mainController == nil) {
        @throw [NSException exceptionWithName: @"LXDNullInstanceException" reason: @"you can not slide view when one or more of menu view and main view is nil" userInfo: nil];
    }
    
    CGRect mainFrame = _mainController.view.frame;
    CGRect menuFrame = _menuController.view.frame;
    
    menuFrame.origin.x = -(1 - kMaxOpenRatio) * kWidth;
    self.snapView = [_mainController.view snapshotViewAfterScreenUpdates: NO];
    _snapView.frame = _mainController.view.frame;
    [_mainController.view addSubview: _snapView];
    menuFrame.origin.x = -(1 - kMaxOpenRatio) * kWidth;
    
    [UIView animateWithDuration: 0.2 animations: ^{
        _snapView.frame = mainFrame;
        _menuController.view.frame = menuFrame;
    } completion: ^(BOOL finished) {
        if (finished) {
            NSLog(@"%@",_snapView);
            [_snapView addGestureRecognizer: self.tap];
        }
    }];
    //给mennuView添加一个策划手势
    [_menuController.view addGestureRecognizer:self.swipe];    //我们将手势事件添加到view上
}
- (void)close
{
    _isOpen = NO;
    [_menuController.view endEditing: YES];
    [_mainController.view removeGestureRecognizer: self.tap];
    [_menuController.view removeGestureRecognizer: self.swipe];

    CGRect menuFrame = _menuController.view.frame;
    CGRect mainFrame = _mainController.view.frame;
    
    mainFrame.origin.x = 0;
    menuFrame.origin.x = -kWidth;
    
    [UIView animateWithDuration: 0.2 animations: ^{
        _snapView.frame = mainFrame;
        _mainController.view.frame = mainFrame;
        _menuController.view.frame = menuFrame;
    } completion: ^(BOOL finished) {
        [_snapView removeFromSuperview];
    }];
}

@end
