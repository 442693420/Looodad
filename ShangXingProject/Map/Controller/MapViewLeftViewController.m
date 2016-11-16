//
//  MapViewLeftViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/14.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "MapViewLeftViewController.h"
#import "MapLeftViewTitleView.h"
#import "MapLeftViewTableViewCell.h"


#define LeftMargin  0.2*CGRectGetWidth([UIScreen mainScreen].bounds)

@interface MapViewLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)MapLeftViewTitleView *titleView;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@end
static NSString *cellIdentifier = @"MapLeftViewTableViewCell";

@implementation MapViewLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    //返回按钮图片
    UIImageView *backImgView = [[UIImageView alloc]init];
    backImgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.top.equalTo(self.view.mas_top).offset(28);
        make.left.equalTo(self.view.mas_left).offset(LeftMargin+8);
    }];
    //返回按钮文字
    UILabel *backLab = [[UILabel alloc]init];
    backLab.text = @"Rooodad";
    backLab.textColor = [UIColor blackColor];
    [self.view addSubview:backLab];
    [backLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.top.centerY.equalTo(backImgView);
        make.left.equalTo(backImgView.mas_right).offset(20);
    }];
    //titleView
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.top.equalTo(backLab.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(LeftMargin+8);
        make.right.equalTo(self.view.mas_right);
    }];
    //tabelView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(LeftMargin+8);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
    }];
    //cell加入缓存池
    [self.tableView registerClass:[MapLeftViewTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    NSDictionary *dic1 = @{@"img":@"",@"title":@"最新消息"};
    NSDictionary *dic2 = @{@"img":@"",@"title":@"个人资料"};
    NSDictionary *dic3 = @{@"img":@"",@"title":@"路况订阅"};
    NSDictionary *dic4 = @{@"img":@"",@"title":@"我的车友圈"};
    NSDictionary *dic5 = @{@"img":@"",@"title":@"直播路况赚积分"};
    NSDictionary *dic6 = @{@"img":@"",@"title":@"设置"};
    NSDictionary *dic7 = @{@"img":@"",@"title":@"帮助"};
    self.dataArr = [[NSMutableArray alloc]initWithObjects:dic1,dic2,dic3,dic4,dic5,dic6,dic7, nil];

}
#pragma tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 8;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapLeftViewTableViewCell *cell = (MapLeftViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        cell.titleLab.text = [dic objectForKey:@"title"];
    }else{
        cell.titleLab.text = @"首次连接自驾宝";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
#pragma mark getter and setter
-(MapLeftViewTitleView *)titleView{
    if (_titleView == nil) {
        _titleView = [[MapLeftViewTitleView alloc]init];
    }
    return _titleView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
@end
