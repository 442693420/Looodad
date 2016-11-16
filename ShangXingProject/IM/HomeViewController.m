//
//  HomeViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/10.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "HomeViewController.h"
#import "LiveViewController.h"
#import "NTESChatroomManager.h"
#import "NTESDemoService.h"
@interface HomeViewController ()
@property (nonatomic,copy) NSArray *data;

@property (nonatomic,assign) BOOL enteringChatroom;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"进入聊天室" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@44);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    __weak typeof(self) weakSelf = self;
    [[NTESDemoService sharedService] fetchDemoChatrooms:^(NSError *error, NSArray<NIMChatroom *> *chatroom) {
        if (!error) {
            weakSelf.data = chatroom;
        }else{
            NSString *toast = [NSString stringWithFormat:@"请求失败 code:%zd",error.code];
            [weakSelf.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
        }
    }];
}
-(IBAction)addAction:(id)sender{
    NIMChatroom *chatroom = [self.data objectAtIndex:0];
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = chatroom.roomId;
    request.roomNickname = user.userInfo.nickName;
    request.roomAvatar = user.userInfo.avatarUrl;
    [SVProgressHUD show];
    self.enteringChatroom = YES;
    __weak typeof(self) wself = self;
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request
                                             completion:^(NSError *error,NIMChatroom *chatroom,NIMChatroomMember *me) {
                                                 [SVProgressHUD dismiss];
                                                 wself.enteringChatroom = NO;
                                                 if (error == nil)
                                                 {
                                                     [[NTESChatroomManager sharedInstance] cacheMyInfo:me roomId:chatroom.roomId];
                                                     
                                                     LiveViewController *vc = [[LiveViewController alloc] initWithChatroom:chatroom];
                                                     [self.navigationController pushViewController:vc animated:YES];
                                                 }
                                                 else
                                                 {
                                                     NSString *toast = [NSString stringWithFormat:@"进入失败 code:%zd",error.code];
                                                     [wself.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                                     DDLogError(@"enter room %@ failed %@",chatroom.roomId,error);
                                                 }
                                                 
                                             }];
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
