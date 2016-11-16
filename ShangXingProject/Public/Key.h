//
//  Key.h
//  MapTestDemo
//
//  Created by 张浩 on 2016/11/3.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 网络

/** 全局用户对象 */
//UIKIT_EXTERN AccoutObject *kAccountObject;

UIKIT_EXTERN double KLongitude;
UIKIT_EXTERN double KLatitude;
UIKIT_EXTERN NSString *KLocation;

/** 连接失败，请检查网络连接 */
UIKIT_EXTERN NSString *const kConnectionFailureError;
/** 请求超时，请检查连接网络 */
UIKIT_EXTERN NSString *const kRequestTimedOutError;
/** 认证失败，请检查网络连接 */
UIKIT_EXTERN NSString *const kAuthenticationError;

/** 接口地址 */
UIKIT_EXTERN NSString *const kPublic_URL;
UIKIT_EXTERN NSString *const kImage_URL;
UIKIT_EXTERN NSString *const kImageUpload_URL;

//公共地址
UIKIT_EXTERN NSString *const kPublicAddress;//所在地



#pragma mark - 常量
UIKIT_EXTERN CGFloat const kHUDTime;
UIKIT_EXTERN CGFloat const kAnimaTime;
UIKIT_EXTERN NSString *const kPassword;//密码
UIKIT_EXTERN NSString *const kUserName;//用户名




#pragma mark - 定义宏

#define HttpRequestService [HttpRequest shareIndex]
#define PublicObj [PublicObject shareIndex]
#define RGB(Red,Green,Blue,Alpha) [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:Alpha]

//程序主色调
#define MainColor [UIColor colorWithRed:88.0/255.0 green:190/255.0 blue:238/255.0 alpha:1.000]
#define MainColorDeep [UIColor colorWithRed:44.0/255.0 green:174/255.0 blue:236/255.0 alpha:1.000]
#define MainColorShallow [UIColor colorWithRed:247.0/255.0 green:252/255.0 blue:255/255.0 alpha:1.000]

#define MainWordColor [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.000]
#define MainWordColorDeep [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.000]
#define MainWordColorShallow [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.000]
#define MainWordColorRed [UIColor colorWithRed:251.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.000]


#define BackGroundColor [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0]

#define BtnColorRed [UIColor colorWithRed:244.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
#define BtnColorDark [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define BtnColorYellow [UIColor colorWithRed:250.0/255.0 green:129.0/255.0 blue:40.0/255.0 alpha:1.0]

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IS_IOS8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS7_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define DefaultImage [UIImage imageNamed:@"defaultImg"]


#define NormalFontSize 14               //标准字体大小
#define SimallFontSize 12               //角标字体大小
#define BigFontSize 16                  //标题字体大小

#define LeftRightSpace 60               //大按钮左 右边距
#define BigButtonHeight 44              //大按钮高度
#define BigButtonCorner 5              //大按钮圆角
#define SimallButtonHeight 30           //小按钮高度
#define SimallButtonWidth 60           //小按钮宽度
#define SimallButtonCorner 2           //小按钮圆角
#define VerifyCodeTime 60               //验证码等待时间


@interface Key : NSObject

@end
