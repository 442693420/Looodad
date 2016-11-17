//
//  NetworkingObject+VideoListHttpRequest.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/17.
//  Copyright © 2016年 张浩. All rights reserved.
//


#import "NetworkingObject.h"

@interface NetworkingObject (VideoListHttpRequest)
+ (void)getVedioArrayWithURLString:(NSString *)URLString success:(void (^) (NSArray *vedioArr,NSArray *sidArr))successBlock fail:(ResponseFail)failBlock;
@end
