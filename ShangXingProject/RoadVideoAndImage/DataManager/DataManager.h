//
//  DataManager.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/16.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^onSuccess)(NSArray *sidArray,NSArray *videoArray);
typedef void(^onFailed)(NSError *error);

@interface DataManager : NSObject

@property(nonatomic,copy)NSArray *sidArray;
@property(nonatomic,copy)NSArray *videoArray;



+(DataManager *)shareManager;
- (void)getSIDArrayWithURLString:(NSString *)URLString success:(onSuccess)success failed:(onFailed)failed;

@end
