//
//  ImgListViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "ImgListViewController.h"
#import "ImgListCollectionViewCell.h"

@interface ImgListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArr;
@end
static NSString *cellIdentifier = @"ImgListCollectionViewCell";

@implementation ImgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSString *imgStr = [NSString stringWithFormat:@"road%d",i];
        [dic setValue:imgStr forKey:@"img"];
        [dic setValue:@"舜华路" forKey:@"road"];
        [dic setValue:@"4.3km" forKey:@"distance"];
        [dic setValue:@"45km/h" forKey:@"speed"];
        [self.dataArr addObject:dic];
    }
    NSLog(@"%@",self.dataArr);
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - UICollectioMnViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger remain = self.dataArr.count - self.numberOfItems * section;
    NSInteger numberOfItems = remain > self.numberOfItems ? self.numberOfItems : remain;
    return numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = self.dataArr.count / self.numberOfItems;
    NSInteger numberOfSections = (self.dataArr.count % self.numberOfItems) ? sections + 1 : sections;
    return numberOfSections;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];;
    NSDictionary *dic = [self dicAtIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
    return cell;
}


- (NSDictionary *)dicAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section * self.numberOfItems + indexPath.row;
    return [self.dataArr objectAtIndex:index];
}


#pragma mark - Getter
- (NSInteger)numberOfItems{
    return 2;
}
- (CGFloat)itemWidth{
    //itemWidth在实际可能会有一些浮点误差导致一行放不下，这里取整保证可以放下
    return (NSInteger)((self.view.width - (self.itemSpacing * (self.numberOfItems + 1))) / self.numberOfItems);
}
- (CGFloat)itemSpacing{
    return 3;
}
- (CGFloat)itemHeight{
    return self.itemWidth * 0.75;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = self.itemSpacing;
        CGFloat padding = self.itemSpacing;
        layout.sectionInset = UIEdgeInsetsMake(padding * .5,padding,padding * .5,padding);
        layout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor  = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.contentInset = UIEdgeInsetsMake(padding * .5f, 0, padding * .5f, 0);
        [_collectionView registerClass:[ImgListCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
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
