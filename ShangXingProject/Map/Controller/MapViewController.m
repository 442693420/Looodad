//
//  MapViewController.m
//  MapTestDemo
//
//  Created by 张浩 on 2016/11/3.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewLeftViewController.h"
#import "VedioListViewController.h"
#import "ImgListViewController.h"
#import "MapTopSegmentedView.h"
#import "MapBottomView.h"
#import "SliderManager.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface MapViewController ()<MapBottomViewDelegate,MAMapViewDelegate,AMapSearchDelegate,UIAlertViewDelegate,UITextFieldDelegate,AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MapTopSegmentedViewDelegate>
@property (nonatomic , strong) MAMapView *mapView;
@property (nonatomic , strong) UIBarButtonItem *rightItem;
@property (nonatomic , strong) UIBarButtonItem *leftItem;
@property (nonatomic , strong) MapTopSegmentedView *topSegmentedControlView;
@property (nonatomic , strong) MapBottomView *bottomView;
@property (nonatomic , assign) BOOL bottomViewShowAll;//保存底部View是否展示全
@property (nonatomic , strong) UIButton *showMyLocationBtn;//定位按钮

@property (nonatomic,retain) AMapSearchAPI *search;
@property (nonatomic,retain) NSString *currentCity;
@property (nonatomic,retain) NSArray *pathPolylines;//路径规划地图SDK

@property (nonatomic , strong) AMapNaviDriveManager *driveManager;//驾车导航管理类 导航SDK
@property (nonatomic , strong) AMapNaviPoint *startPoint;
@property (nonatomic , strong) AMapNaviPoint *endPoint;
@property (nonatomic , strong) AMapNaviDriveView *driveView;//导航View

//逆地理位置查询信息
@property (nonatomic, assign) CGFloat latitude; //!< 纬度（垂直方向）
@property (nonatomic, assign) CGFloat longitude; //!< 经度（水平方向）
@end

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加导航头View
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.navigationItem.titleView = self.topSegmentedControlView;
    //添加地图
    [self.view addSubview:self.mapView];
    //添加底部BottomView,需在地图上盖住
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    //添加定位按钮
    [self.view addSubview:self.showMyLocationBtn];
    [self.showMyLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.height.equalTo(@30);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
    }];
    //初始化侧滑chontroller
    MapViewLeftViewController *menuVC = [[MapViewLeftViewController alloc]init];
    SliderManager *slideManager = [SliderManager sharedManager];
    [slideManager setupMainController:self];
    [slideManager setupMenuController:menuVC];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
#pragma mark -- 定位位置发生改变

//当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"%f,%f,%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude,userLocation.title);
        self.currentLocation = userLocation;
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        //发起逆地理编码
        [self.search AMapReGoecodeSearch: regeo];
    }
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //我们把编码后的地理位置，显示到 大头针的标题和子标题上
        NSString *title =response.regeocode.addressComponent.city;
        _currentCity = title;
        if (title.length == 0) {
            title = response.regeocode.addressComponent.province;
        }
        _mapView.userLocation.title = title;
        _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    }
}
#pragma mark -- 大头针和遮盖
//自定义的经纬度和区域
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleRenderer;
    }
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        
        return polygonView;
    }
    return nil;
    
}
//添加大头针,标记显示选中的搜索结果
- (void)addAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_currentPOI.location.latitude, _currentPOI.location.longitude);
    pointAnnotation.title = _currentPOI.name;
    pointAnnotation.subtitle = _currentPOI.address;
    [_mapView addAnnotation:pointAnnotation];
    [_mapView selectAnnotation:pointAnnotation animated:YES];//立即显示吹出的弹出框calloutView，否则点击大头针才会显示
}
////大头针的回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    //    /* 自定义userLocation对应的annotationView. */
    //    if ([annotation isKindOfClass:[MAUserLocation class]])
    //    {
    //        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
    //        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
    //        if (annotationView == nil)
    //        {
    //            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
    //                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
    //        }
    //        annotationView.image = [UIImage imageNamed:@"userPosition"];
    //
    //        return annotationView;
    //    }
    //大头针
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"获取点击事件 开始路线规划");
    //导航
    [self startNavigation];
}
- (void)startNavigation{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击地图  返回信息
-(void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    NSLog(@"返回地图上点击的标注点的信息Name:%@",pois);
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    NSString *str = [NSString stringWithFormat:@"返回地图上点击点的经纬度:%f%f",coordinate.latitude,coordinate.longitude];
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否查看详细信息" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
//        LaAndLoSearchResultViewController *viewController = [[LaAndLoSearchResultViewController alloc]init];
//        viewController.latitude = self.latitude;
//        viewController.longitude = self.longitude;
//        viewController.title = [NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude];
//        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [self jumpTosearchAction];
}
#pragma mark -- push到搜索页面
- (void)jumpTosearchAction{
//    KeyWordSearchViewController *viewController = [[KeyWordSearchViewController alloc]init];
//    viewController.currentCity = self.currentCity;
//    viewController.currentLocation = self.currentLocation;
//    
//    viewController.moveBlock = ^(AMapPOI *poi)
//    {
//        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) animated:YES];
//        self.currentPOI = poi;
//        self.destinationPoint = [[MAPointAnnotation alloc]init];
//        _destinationPoint.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
//                [self findWayAction:nil];
////        [self showNavi];
//        //添加大头针
//        [self addAnnotation];
//    };
//    [self.navigationController pushViewController:viewController animated:NO];
}
#pragma mark -- 路径查询地图SDK中
////规划线路查询地图SDK中
- (IBAction)findWayAction:(id)sender {
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    request.destination = [AMapGeoPoint locationWithLatitude:_destinationPoint.coordinate.latitude longitude:_destinationPoint.coordinate.longitude];
    request.strategy = 5;//5-多策略（同时使用速度优先、费用优先、距离优先三个策略
    request.requireExtension = YES;
    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
}
//实现路径搜索的回调函数地图SDK中
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"%@", route);
    AMapPath *path = response.route.paths[0];
    AMapStep *step = path.steps[0];
    NSLog(@"%@",step.polyline);
    NSLog(@"%@",response.route.paths[0]);
    if (response.count > 0)
    {
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [self polylinesForPath:response.route.paths[0]];
        NSLog(@"%@",response.route.paths[0]);
        [_mapView addOverlays:_pathPolylines];
        //        解析第一条返回结果
        //        搜索路线
        MAPointAnnotation *currentAnnotation = [[MAPointAnnotation alloc]init];
        currentAnnotation.coordinate = _mapView.userLocation.coordinate;
        [_mapView showAnnotations:@[_destinationPoint, currentAnnotation] animated:YES];
        [_mapView addAnnotation:currentAnnotation];
    }
}
//路线解析地图SDK中
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}
//解析经纬度地图SDK中
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    if (token == nil)
    {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}

#pragma mark 路径规划 导航SDK
- (void)showNavi{
    self.startPoint = [AMapNaviPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:_destinationPoint.coordinate.latitude longitude:_destinationPoint.coordinate.longitude];
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:17];
}
/**
 *  发生错误时,会调用代理的此方法
 *
 *  @param error 错误信息
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error{
    NSLog(@"%@",error);
}

/**
 *  驾车路径规划成功后的回调函数
 */
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    //标记路线
//    [self showRouteWithNaviRoute:driveManager.naviRoute];
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
}
//- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
//{
//    if (naviRoute == nil)
//    {
//        return;
//    }
//    // 清除旧的overlays
//    if (_polyline)
//    {
//        [self.mapView removeOverlay:_polyline];
//        self.polyline = nil;
//    }
//    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
//    CLLocationCoordinate2D coordinates[coordianteCount];
//    for (int i = 0; i < coordianteCount; i++)
//    {
//        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
//        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
//    }
//    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
//    [self.mapView addOverlay:_polyline];
//}
/**
 *  驾车路径规划失败后的回调函数
 *
 *  @param error 错误信息,error.code参照AMapNaviCalcRouteState
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    NSLog(@"%@",error);
}

////绘制多边形
//- (void)drawPolygon
//{
//    //构造多边形数据对象
//    CLLocationCoordinate2D coordinates[3];
//    //    108.900536,34.223808;108.90033,34.223476;108.900246,34.223351
//    coordinates[0].latitude = 34.221808;
//    coordinates[0].longitude = 108.900536;
//
//    coordinates[1].latitude = 34.223476;
//    coordinates[1].longitude = 108.90133;
//
//    coordinates[2].latitude = 34.226351;
//    coordinates[2].longitude = 108.900246;
//
//    //    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:3];
//    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:3];
//
//    //在地图上添加多边形对象
//    //    [_mapView addOverlay: polygon];
//    [_mapView addOverlay:polyline];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}

- (AMapSearchAPI *)search
{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        //设置地图种类
        [_mapView setMapType:MAMapTypeStandard];
        //路况显示
        _mapView.showTraffic = YES;
        ////    调整logo位置
        //    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
        //指南针
        _mapView.showsCompass = NO; // 设置成NO表示关闭指南针；YES表示显示指南针
        //禁止旋转
        _mapView.rotateEnabled = NO;
        //禁止倾斜
        _mapView.rotateCameraEnabled = NO;
        //是否显示楼块
        _mapView.showsBuildings = YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO]; //地图跟着位置移动
        //自定义定位经度圈样式
        _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    }
    return _mapView;
}
-(AMapNaviDriveManager *)driveManager{
    if (_driveManager == nil)
    {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        [_driveManager setDelegate:self];
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [_driveManager addDataRepresentative:_driveView];
    }
    return _driveManager;
}
-(AMapNaviDriveView *)driveView{
    if (_driveView == nil)
    {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_driveView setDelegate:self];
        
        [self.view addSubview:_driveView];
    }
    return _driveView;
}
#pragma mark naviView-btnAction
-(IBAction)naviLeftBtnClick:(id)sender{
    [[SliderManager sharedManager] openOrClose];
}
-(IBAction)naviRightBtnClick:(id)sender{
    
}
#pragma mark naviView-segmentedControl-delegate
/**
 *  监听点击了哪项
 */
-(void)MapTopSegmentedViewDidSelectItemWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            NSLog(@"点击了实时路况");
        }
            break;
        case 1:
        {
            NSLog(@"点击了高速路况");
        }
            break;
        case 2:
        {
            NSLog(@"点击了车友路况");
        }
            break;
        case 3:
        {
            NSLog(@"点击了车友圈");
        }
            break;
        default:
            break;
    }
}

#pragma mark bottomView-delegate
-(void)mapBottomViewUpDownBtnClick{
    if (self.bottomViewShowAll) {
        //原来展示全，现在改为未展示全
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.videoBtn.hidden = YES;
            self.bottomView.imageBtn.hidden = YES;
            [self.view layoutIfNeeded];
        }];
    }else{
    //原来是未展示全，现在改为展示全
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@180);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.videoBtn.hidden = NO;
            self.bottomView.imageBtn.hidden = NO;
            [self.view layoutIfNeeded];
        }];
    }
    self.bottomViewShowAll = !self.bottomViewShowAll;
}
-(void)mapBottomViewVideoBtnClick{
    VedioListViewController *viewController = [[VedioListViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)mapBottomViewImageBtnClick{
    ImgListViewController *viewController = [[ImgListViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark showMyLocationBtnAction
-(IBAction)showMyLocationBtnClick:(id)sender{
    [_mapView setCenterCoordinate: _currentLocation.coordinate animated:YES];
    //恢复缩放比例和角度
    [_mapView setZoomLevel:18 animated:YES];
    
    [_mapView setRotationDegree:0 animated:YES duration:0.5];
    [_mapView setCameraDegree:0 animated:YES duration:0.5];
}
#pragma mark getter and setter
- (UIBarButtonItem *)leftItem{
    if (!_leftItem) {
        UIButton *publisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        publisButton.frame = CGRectMake(0, 0, 25, 25);
//        [publisButton setBackgroundImage:[UIImage imageNamed:@"sgk_bt_userhome_publish2"] forState:UIControlStateNormal];
        [publisButton setBackgroundColor:[UIColor redColor]];
        [publisButton addTarget:self action:@selector(naviLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc] initWithCustomView:publisButton];
    }
    return _leftItem;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *publisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        publisButton.frame = CGRectMake(0, 0, 25, 25);
//        [publisButton setBackgroundImage:[UIImage imageNamed:@"sgk_common_search_normal"] forState:UIControlStateNormal];
        [publisButton setBackgroundColor:[UIColor redColor]];
        [publisButton addTarget:self action:@selector(naviRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:publisButton];
    }
    return _rightItem;
}
-(MapTopSegmentedView *)topSegmentedControlView{
    if (_topSegmentedControlView == nil) {
        _topSegmentedControlView = [[MapTopSegmentedView alloc]initWithFrame:CGRectMake(0, 7, self.view.frame.size.width - 80, 30)
                                                  TitleArray:@[@"实时路况",@"高速路况",@"车友路况",@"车友圈"]];
        _topSegmentedControlView.delegate = self;
    }
    return _topSegmentedControlView;
}
-(MapBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[MapBottomView alloc]init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(UIButton *)showMyLocationBtn{
    if (_showMyLocationBtn == nil) {
        _showMyLocationBtn = [[UIButton alloc]init];
        _showMyLocationBtn.backgroundColor = [UIColor redColor];
        [_showMyLocationBtn addTarget:self action:@selector(showMyLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showMyLocationBtn;
}
@end
