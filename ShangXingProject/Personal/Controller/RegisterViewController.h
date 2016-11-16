//
//  RegisterViewController.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/10.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegisterViewControllerDelegate <NSObject>

@optional
- (void)registDidComplete:(NSString *)account password:(NSString *)password;

@end
@interface RegisterViewController : UIViewController
@property (nonatomic, weak) id<RegisterViewControllerDelegate> delegate;
@end
