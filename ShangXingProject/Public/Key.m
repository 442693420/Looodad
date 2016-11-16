//
//  Key.m
//  MapTestDemo
//
//  Created by 张浩 on 2016/11/3.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "Key.h"

NSString *const kConnectionFailureError = @"连接失败，请检查网络连接";
NSString *const kRequestTimedOutError  = @"请求超时，请检查连接网络";
NSString *const kAuthenticationError  = @"认证失败，请检查网络连接";

//接口地址
//正式库
NSString *const kPublic_URL = @"http://api.simall360.com/system/";
NSString *const kImage_URL = @"http://api.simall360.com/";
NSString *const kImageUpload_URL = @"http://api.simall360.com/system/inventoryrelease/picture_upload";



//公共地址
NSString *const kPublicAddress = @"region/getRegionByParentcode?";//所在地


#pragma mark - 常量
CGFloat const kHUDTime = 1.0f;
CGFloat const kAnimaTime  = 0.30f;
NSString *const kPassword = @"password";//密码
NSString *const kUserName = @"username";//用户名


@implementation Key

@end
