//
//  MainViewController.m
//  dji
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "MainViewController.h"
#import <MAMapKit/MAMapKit.H>
#define APIKEY     @"59d4ee58ceaacf4fa99e6b2920b9dc04";

@interface MainViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
#if 0
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = APIKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self; [self.view addSubview:_mapView];
    // Do any additional setup after loading the view from its nib.
#endif
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
    
    _mapView.delegate = self; [self.view addSubview:_mapView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
