//
//  NTESChatroomConfig.m
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESChatroomConfig.h"
#import "NTESChatroomMessageDataProvider.h"
#import "NTESChatroomCellLayoutConfig.h"

#import "NTESSessionCustomLayoutConfig.h"
#import "NIMMediaItem.h"
#import "NTESBundleSetting.h"
#import "NTESBundleSetting.h"
@interface NTESChatroomConfig()

@property (nonatomic,strong) NTESChatroomMessageDataProvider *provider;

@end

@implementation NTESChatroomConfig

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        self.provider = [[NTESChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}


- (NSArray<NSNumber *> *)inputBarItemTypes{
    return @[
               @(NIMInputBarItemTypeTextAndRecord),
//               @(NIMInputBarItemTypeVoice)
//               @(NIMInputBarItemTypeEmoticon),
//               @(NIMInputBarItemTypeMore)
            ];
}


//- (NSArray *)mediaItems
//{
//    return @[
//             [NIMMediaItem item:NTESMediaButtonJanKenPon
//                    normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
//                  selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
//                          title:@"石头剪刀布"]];
//}


- (id<NIMCellLayoutConfig>)layoutConfigWithMessage:(NIMMessage *)message{
    return [NTESChatroomCellLayoutConfig new];
}

- (BOOL)disableProximityMonitor{
    return [NTESBundleSetting sharedConfig].disableProximityMonitor;
}


- (BOOL)shouldHandleReceipt{
    return YES;
}

- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
//    if (type == NIMMessageTypeCustom) {
//        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//        id attachment = object.attachment;
//        
//        if ([attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
//            return NO;
//        }
//    }
//    return type == NIMMessageTypeText ||
//    type == NIMMessageTypeAudio ||
//    type == NIMMessageTypeImage ||
//    type == NIMMessageTypeVideo ||
//    type == NIMMessageTypeFile ||
//    type == NIMMessageTypeLocation ||
//    type == NIMMessageTypeCustom;
    return
    type == NIMMessageTypeAudio;
}

- (NIMAudioType)recordType
{
    return [[NTESBundleSetting sharedConfig] usingAmr] ? NIMAudioTypeAMR : NIMAudioTypeAAC;
}
- (BOOL)disableCharlet{
    return YES;
}

- (BOOL)autoFetchWhenOpenSession
{
    return NO;
}

@end
