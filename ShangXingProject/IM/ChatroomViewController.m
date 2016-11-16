//
//  ChatroomViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/11.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "ChatroomViewController.h"
#import "NTESChatroomConfig.h"
#import "NTESChatroomManager.h"
@import AVFoundation;

@interface ChatroomViewController ()<NIMMediaManagerDelgate>
{
    BOOL _isRefreshing;
}
@property (nonatomic,strong) NTESChatroomConfig *config;

@property (nonatomic,strong) NIMChatroom *chatroom;


@end

@implementation ChatroomViewController

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    self = [super initWithSession:[NIMSession session:chatroom.roomId type:NIMSessionTypeChatroom]];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}
- (void)sendMessage:(NIMMessage *)message
{
    NIMChatroomMember *member = [[NTESChatroomManager sharedInstance] myInfo:self.chatroom.roomId];
    message.remoteExt = @{@"type":@(member.type)};
    [super sendMessage:message];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    CGFloat offset = 44.f;
    if (scrollView.contentOffset.y <= -offset && !_isRefreshing && self.tableView.isDragging) {
        _isRefreshing = YES;
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        [scrollView endEditing:YES];
    }
    else if(scrollView.contentOffset.y >= 0)
    {
        _isRefreshing = NO;
    }
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}
#pragma mark - Get
- (NTESChatroomConfig *)config{
    if (!_config) {
        _config = [[NTESChatroomConfig alloc] initWithChatroom:self.chatroom.roomId];
    }
    return _config;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
