//
//  LiveViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/11.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "LiveViewController.h"
#import "NTESLiveActionView.h"
#import "NIMInputProtocol.h"
#import "NIMInputView.h"

#import "ChatroomViewController.h"
#import "ChatroomMemberListViewController.h"
#import "LiveInfoViewController.h"
@interface LiveViewController ()<NTESLiveActionViewDataSource,NTESLiveActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate>
@property (nonatomic, copy)   NIMChatroom *chatroom;
@property (nonatomic, strong) ChatroomViewController *chatroomViewController;
@property (nonatomic, strong) NTESLiveActionView *actionView;

@property (nonatomic, strong) UIImageView *liveImageView;

@property (nonatomic, assign) BOOL keyboradIsShown;

@property (nonatomic, weak)   UIViewController *currentChildViewController;
@property (nonatomic, strong, readonly) NIMInputView *sessionInputView;


@end

@implementation LiveViewController

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天室";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupBackBarButtonItem];
    [self setupChildViewController];
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    
    NSArray *segmentArray = @[
                              @"直播互动",
                              @"主播",
                              @"在线成员"
                              ];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 80, 30);
    segmentControl.selectedSegmentIndex = 2;
    segmentControl.tintColor = [UIColor redColor];
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, 30)];
    [view addSubview:segmentControl];
    self.navigationItem.titleView = view;
}

/**
 *  监听点击了哪项
 */
- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
    NSInteger idx = segmentControl.selectedSegmentIndex;
    
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child = self.childViewControllers[idx];

    [self transitionFromViewController:lastChild toViewController:child duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
        
    }  completion:^(BOOL finished) {
        if (finished) {
            [child didMoveToParentViewController:self];
            self.currentChildViewController = child;
        }else{
            self.currentChildViewController = lastChild;
        }
    }];

}

- (void)setupChildViewController{
    
    NSArray *vcs = [self makeChildViewControllers];

    self.currentChildViewController = vcs.lastObject;
    for (UIViewController *vc in vcs) {
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
}
#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
}

- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error
{
    NSString *toast = [NSString stringWithFormat:@"chatroom autoLoginFailed failed : %zd",error.code];
    DDLogInfo(@"%@",toast);
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
    [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (NSArray *)makeChildViewControllers{
    self.chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom];
    ChatroomMemberListViewController *memberListVC = [[ChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
    LiveInfoViewController *liveInfoVC = [[LiveInfoViewController alloc] initWithChatroom:self.chatroom];
    return @[self.chatroomViewController,liveInfoVC,memberListVC];
}

- (void)setupBackBarButtonItem
{
    UIImage *buttonNormal = [[UIImage imageNamed:@"chatroom_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonSelected = [[UIImage imageNamed:@"chatroom_back_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonSelected];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
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
