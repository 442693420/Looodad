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
//直播
@property (nonatomic , strong)WMPlayer *wmPlayer;
@property (nonatomic , copy)NSString *videoUrl;

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
    self.videoUrl = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    
    self.wmPlayer = [[WMPlayer alloc]initWithFrame:self.view.bounds videoURLStr:self.videoUrl];
    self.wmPlayer.bottomView.hidden = YES;
    self.wmPlayer.isLiving = YES;
    [self.wmPlayer.player play];
    [self.view addSubview:self.wmPlayer];
    [self.view sendSubviewToBack:self.wmPlayer];
}
- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    [self releaseWMPlayer];

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
-(void)releaseWMPlayer{
    [self.wmPlayer.player.currentItem cancelPendingSeeks];
    [self.wmPlayer.player.currentItem.asset cancelLoading];
    
    [self.wmPlayer.player pause];
    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    self.wmPlayer = nil;
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    
    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
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
