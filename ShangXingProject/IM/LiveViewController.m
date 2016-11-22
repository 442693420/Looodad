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
@interface LiveViewController ()<NTESLiveActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate>
@property (nonatomic, copy)   NIMChatroom *chatroom;
@property (nonatomic, strong) ChatroomViewController *chatroomViewController;
@property (nonatomic, strong) LiveInfoViewController *liveInfoViewController;
@property (nonatomic, strong) ChatroomMemberListViewController *chatroomMemberListViewController;

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
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor redColor];
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, 30)];
    [view addSubview:segmentControl];
    self.navigationItem.titleView = view;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
/**
 *  监听点击了哪项
 */
- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
    
    NSInteger idx = segmentControl.selectedSegmentIndex;
    
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child;
    switch (idx) {
        case 0:
            child = self.chatroomViewController;
            break;
        case 1:
            child = self.liveInfoViewController;
            break;
        case 2:
            child = self.chatroomMemberListViewController;
            break;
        default:
            break;
    }
    [self addChildViewController:child];
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:lastChild toViewController:child duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
        //做一些动画
    } completion:^(BOOL finished) {
        
        if (finished) {
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [self didMoveToParentViewController:child];
            [lastChild willMoveToParentViewController:nil];
            self.currentChildViewController = child;
            
        }else
        {
            self.currentChildViewController = lastChild;
        }
        
    }];
    
}

- (void)setupChildViewController{
    
    self.chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom];
    //在ViewController 中添加其他UIViewController，currentVC是一个UIViewController变量，存储当前显示的viewcontroller
    self.chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom];
    [self addChildViewController:self.chatroomViewController];
    //addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
    [self.chatroomViewController didMoveToParentViewController:self];
    [self.chatroomViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.currentChildViewController = self.chatroomViewController;
    [self.view addSubview:self.currentChildViewController.view];
    //这里没有其他addSubview:方法了，就只有一个，而且可以切换视图，是不是很神奇？
    self.liveInfoViewController = [[LiveInfoViewController alloc] initWithChatroom:self.chatroom];
    [self.liveInfoViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.chatroomMemberListViewController = [[ChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
    [self.chatroomMemberListViewController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
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
