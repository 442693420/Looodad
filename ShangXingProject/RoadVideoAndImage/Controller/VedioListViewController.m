//
//  VedioListViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "VedioListViewController.h"
#import "VedioDetailViewController.h"
#import "VedioListTableViewCell.h"
#import "SidModel.h"
#import "VideoModel.h"
#import "WMPlayer.h"
#import "NetworkingObject+VideoListHttpRequest.h"
@interface VedioListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *videoArr;
@property (nonatomic , strong)WMPlayer *wmPlayer;
@property (nonatomic , strong)NSIndexPath *currentIndexPath;
@property (nonatomic , strong)VedioListTableViewCell *currentCell;

@end
static NSString *cellIdentifier = @"VedioListTableViewCell";
#define rowWidth SCREEN_WIDTH * 9/21
#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )

@implementation VedioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tabelView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //cell加入缓存池
    [self.tableView registerClass:[VedioListTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    //数据
    self.videoArr = [[NSMutableArray alloc]init];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册全屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    [self addMJRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releaseWMPlayer];
}
-(void)addMJRefresh{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [NetworkingObject getVedioArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html" success:^(NSArray *vedioArr, NSArray *sidArr) {
            self.videoArr =[NSMutableArray arrayWithArray:vedioArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.currentIndexPath.row>self.videoArr.count) {
                    [self releaseWMPlayer];
                }
                [tableView reloadData];
                [tableView.header endRefreshing];
            });
        } fail:^(NSError *error) {
            
        }];
        [tableView.header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.autoChangeAlpha = YES;
    // 上拉刷新
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *URLString = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%ld-10.html",self.videoArr.count - self.videoArr.count%10];
        [NetworkingObject getVedioArrayWithURLString:URLString success:^(NSArray *vedioArr, NSArray *sidArr) {
            [self.videoArr addObjectsFromArray:vedioArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
                [tableView.header endRefreshing];
            });
        } fail:^(NSError *error) {
            
        }];
        // 结束刷新
        [tableView.footer endRefreshing];
    }];
    
    
}

-(void)videoDidFinished:(NSNotification *)notice{
    VedioListTableViewCell *currentCell = (VedioListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    currentCell.playBtn.userInteractionEnabled = YES;
    currentCell.backgroundIV.userInteractionEnabled = NO;
    [self.wmPlayer removeFromSuperview];
    
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toCell];
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (self.wmPlayer==nil||self.wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (self.wmPlayer.isFullscreen) {
                    [self toCell];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (self.wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (self.wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        default:
            break;
    }
}
-(void)toCell{
    VedioListTableViewCell *currentCell = [self currentCell];
    
    [self.wmPlayer removeFromSuperview];
    NSLog(@"row = %ld",self.currentIndexPath.row);
    [UIView animateWithDuration:0.5f animations:^{
        self.wmPlayer.transform = CGAffineTransformIdentity;
        self.wmPlayer.frame = currentCell.backgroundIV.bounds;
        self.wmPlayer.playerLayer.frame =  self.wmPlayer.bounds;
        [currentCell.backgroundIV addSubview:self.wmPlayer];
        [currentCell.backgroundIV bringSubviewToFront:self.wmPlayer];
        [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer).with.offset(0);
            make.right.equalTo(self.wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.wmPlayer).with.offset(0);
            
        }];
        
        [self.wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self.wmPlayer).with.offset(5);
            
        }];
        
        
    }completion:^(BOOL finished) {
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    }];
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [self.wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.wmPlayer).with.offset(5);
        
    }];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
    self.wmPlayer.isFullscreen = YES;
    self.wmPlayer.fullScreenBtn.selected = YES;
    [self.wmPlayer bringSubviewToFront:self.wmPlayer.bottomView];
    
}
#pragma tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VedioListTableViewCell *cell = (VedioListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.videoArr objectAtIndex:indexPath.row];
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    
    
    if (self.wmPlayer&&self.wmPlayer.superview) {
        if (indexPath==self.currentIndexPath) {
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
        }else{
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
        if (![indexpaths containsObject:self.currentIndexPath]) {//复用
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.wmPlayer]) {
                self.wmPlayer.hidden = NO;
                
            }else{
                self.wmPlayer.hidden = YES;
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
        }else{
            if ([cell.backgroundIV.subviews containsObject:self.wmPlayer]) {
                [cell.backgroundIV addSubview:self.wmPlayer];
                
                [self.wmPlayer.player play];
                self.wmPlayer.playOrPauseBtn.selected = NO;
                self.wmPlayer.hidden = NO;
            }
            
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    VideoModel *model = [self.videoArr objectAtIndex:indexPath.row];
    //    VedioDetailViewController *viewController = [[VedioDetailViewController alloc] init];
    ////    viewController.URLString  = model.m3u8_url;
    ////    viewController.title = model.title;
    ////    //    detailVC.URLString = model.mp4_url;
    //    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowWidth;
}


-(void)startPlayVideo:(UIButton *)sender{
    self.currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",self.currentIndexPath.row);
    
    self.currentCell = (VedioListTableViewCell *)sender.superview.superview;
    VideoModel *model = [self.videoArr objectAtIndex:sender.tag];
    
    if (self.wmPlayer) {
        [self.wmPlayer removeFromSuperview];
        [self.wmPlayer setVideoURLStr:model.mp4_url];
        [self.wmPlayer.player play];
        
    }else{
        self.wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.backgroundIV.bounds videoURLStr:model.mp4_url];
        [self.wmPlayer.player play];
        
    }
    [self.currentCell.backgroundIV addSubview:self.wmPlayer];
    [self.currentCell.backgroundIV bringSubviewToFront:self.wmPlayer];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    //重要！！
    //userInteractionEnabled属性可以设置视图是否可以接收到用户的事件和消息，是否可以跟用户交互，如果不想视图接收事件消息，设置为no就可以了，比如说：当一个父视图中包含一个子视图a时，同时又包含另外一个视图b；但是b被a覆盖住了，这样b就不能相应事件，这时候设置a的userInteractionEnabled为no，b的userInteractionEnabled为yes，b就可以接收到消息事件了
    self.currentCell.backgroundIV.userInteractionEnabled = YES;
    self.currentCell.playBtn.userInteractionEnabled = NO;
    
//    [self.tableView reloadData];
    
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.tableView){
        if (self.wmPlayer==nil) {
            return;
        }
        
        if (self.wmPlayer.superview) {
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.currentIndexPath];
            CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            
            NSLog(@"rectInSuperview = %@",NSStringFromCGRect(rectInSuperview));
            
            if (rectInSuperview.origin.y<-self.currentCell.backgroundIV.frame.size.height||rectInSuperview.origin.y>self.view.frame.size.height-44) {//往上拖动//kNavbarHeight
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.wmPlayer]) {
                }else{
                    //停止之前的播放
                    VedioListTableViewCell *currentCell = (VedioListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
                    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
                    currentCell.playBtn.userInteractionEnabled = YES;
                    currentCell.backgroundIV.userInteractionEnabled = NO;
                    [self.wmPlayer removeFromSuperview];
                }
                
            }else{
                if ([self.currentCell.backgroundIV.subviews containsObject:self.wmPlayer]) {
                    
                }else{
                    [self toCell];
                }
            }
        }
        
    }
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
    self.currentIndexPath = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseWMPlayer];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark getter and setter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
@end
