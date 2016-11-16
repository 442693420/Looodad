//
//  ChatroomViewController.h
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/11.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSessionViewController.h"

@interface ChatroomViewController : NIMSessionViewController
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

@end
