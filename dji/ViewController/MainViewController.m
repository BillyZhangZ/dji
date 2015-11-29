//
//  MainViewController.m
//  dji
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "MainViewController.h"
#import "LiveStream.h"
#import "ControlPanel.h"
#import <MAMapKit/MAMapKit.H>


#define APIKEY     @"59d4ee58ceaacf4fa99e6b2920b9dc04";

@interface MainViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    
    NSString *_url;
    UIImageView *_imageView;
    LiveStream *_liveStream;
    
    ControlPanel *_controlPanel;
    
}
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = APIKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.showTraffic= NO;
    
    //_mapView.language = MAMapLanguageEn;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置 移动
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *mapTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onMapView:)];
    [_mapView addGestureRecognizer:mapTapGesture];
    _mapView.delegate = self;
    
    
    //buttons
    _mapModeButton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 100, 20, 80, 40)];
    _mapModeButton.backgroundColor = [UIColor clearColor];
    [_mapModeButton setTitle:@"夜间模式" forState:UIControlStateNormal];
    [_mapModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _mapModeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mapModeButton addTarget:self action:@selector(onMapButtonMode) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*3/4, CGRectGetWidth(self.view.bounds)/4, CGRectGetHeight(self.view.bounds)/4)];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageView:)];
    [_imageView addGestureRecognizer:singleTap1];
    
    
    _liveStream = [[LiveStream alloc] init];
    _url = @"rtsp://218.204.223.237:554/live/1/67A7572844E51A64/f68g2mj7wjua3la7.sdp";
    
    [_liveStream setUrl: _url];
    [_liveStream setImageView:_imageView];
    [_liveStream startLive];
    
    
   // _controlPanel = [[ControlPanel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    [self.view addSubview:_mapModeButton];
    [self.view addSubview:_mapView];
    [self.view addSubview:_imageView];
    [self.view addSubview:_controlPanel];
    [self.view bringSubviewToFront:_imageView];
    [self.view bringSubviewToFront:_mapModeButton];
    //[self.view bringSubviewToFront:_controlPanel];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void) onImageView:(UITapGestureRecognizer *)sender{
    //Image view maximum
    [_imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view sendSubviewToBack:_imageView];
    [_mapView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*3/4, CGRectGetWidth(self.view.bounds)/4, CGRectGetHeight(self.view.bounds)/4)];
    [self.view bringSubviewToFront:_mapView];
    
}

- (void) onMapView:(UIGestureRecognizer *)sender
{
    //map view maximum
    [_mapView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view sendSubviewToBack:_mapView];
    [_imageView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*3/4, CGRectGetWidth(self.view.bounds)/4, CGRectGetHeight(self.view.bounds)/4)];
    [self.view bringSubviewToFront:_imageView];
}

- (void) onMapButtonMode
{
    switch (_mapView.mapType) {
        case MAMapTypeStandard:
            _mapView.mapType = MAMapTypeStandardNight;
            [_mapModeButton setTitle:@"标准模式" forState:UIControlStateNormal];
            break;
        default:
            _mapView.mapType = MAMapTypeStandard;
            [_mapModeButton setTitle:@"夜间模式" forState:UIControlStateNormal];

            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end
