//
//  VideoModel.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/16.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}
@end
