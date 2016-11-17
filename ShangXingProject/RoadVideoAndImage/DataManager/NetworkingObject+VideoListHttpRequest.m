//
//  NetworkingObject+VideoListHttpRequest.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/17.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "NetworkingObject+VideoListHttpRequest.h"
#import "VideoModel.h"
#import "SidModel.h"
@implementation NetworkingObject (VideoListHttpRequest)
+ (void)getVedioArrayWithURLString:(NSString *)URLString success:(void (^) (NSArray *vedioArr,NSArray *sidArr))successBlock fail:(ResponseFail)failBlock{
    [NetworkingObject getWithUrl:URLString
                refreshCache:YES
                     success:^(id response) {
                         NSMutableArray *sidArray = [NSMutableArray array];
                         NSMutableArray *videoArray = [NSMutableArray array];
                         NSDictionary *resultDic = (NSDictionary *)response;
                         for (NSDictionary * video in [resultDic objectForKey:@"videoList"]) {
                             VideoModel * model = [[VideoModel alloc] init];
                             [model setValuesForKeysWithDictionary:video];
                             [videoArray addObject:model];
                         }
                         videoArray = [NSMutableArray arrayWithArray:videoArray];
                         // 加载头标题
                         for (NSDictionary *d in [resultDic objectForKey:@"videoSidList"]) {
                             SidModel *model= [[SidModel alloc] init];
                             [model setValuesForKeysWithDictionary:d];
                             [sidArray addObject:model];
                         }
                         sidArray = [NSMutableArray arrayWithArray:sidArray];
                         successBlock(videoArray,sidArray);
                     } fail:^(NSError *error) {
                         failBlock(error);
                     }];
    return;

}
@end
