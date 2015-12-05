//
//  MainViewController.m
//  dji
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "MainViewController.h"
#import "LiveStream.h"
#import <MAMapKit/MAMapKit.H>


#define APIKEY     @"59d4ee58ceaacf4fa99e6b2920b9dc04";

@interface MainViewController ()<MAMapViewDelegate, UIGestureRecognizerDelegate, AsyncSocketDelegate>
{
    MAMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    
    NSString *_url;
    UIImageView *_imageView;
    LiveStream *_liveStream;
    
    UILabel *_socketStatusLabel ;
    UILabel *_videoStatusLabel;
}
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
   // [self.navigatorBar setBarTintColor:[UIColor grayColor]];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    UIPanGestureRecognizer *panGestrue = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanGesture:)];
    UISwipeGestureRecognizer *upSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onUpSwipeGesture:)];
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipeGesture];
    
    UISwipeGestureRecognizer *downSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onDownSwipeGesture:)];
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
   // [self.view addGestureRecognizer:downSwipeGesture];
    //[self.view addGestureRecognizer:panGestrue];
   // [self.view addGestureRecognizer:tapGesture];
    
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
    
    
    
    [self.view addSubview:_mapView];
    [self.view addSubview:_imageView];
    //[self.view bringSubviewToFront:_imageView];
    //[self.view bringSubviewToFront:_mapModeButton];
    
    CGRect rc = self.view.bounds;
    rc.size.height = 100;//self.view.bounds.size.height/3;
    rc.size.width = 100;//self.view.bounds.size.width/3;
    rc.origin.x = 50;
    rc.origin.y = self.view.bounds.size.height/2 -50;
    UIButton *leftButton = [[UIButton alloc]initWithFrame:rc];
    //leftButton.backgroundColor = [UIColor orangeColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    leftButton.alpha = 0.5;
    [leftButton addTarget:self action:@selector(onLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    rc.size.height = 100;//self.view.bounds.size.height/3;
    rc.size.width = 100;//self.view.bounds.size.width/3;
    rc.origin.x = self.view.bounds.size.width - 100 -50;
    rc.origin.y = self.view.bounds.size.height/2 -50;
    UIButton *rightButton = [[UIButton alloc]initWithFrame:rc];
    //rightButton.backgroundColor = [UIColor orangeColor];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"right-arrow"] forState:UIControlStateNormal];
    rightButton.alpha = 0.5;
    [rightButton addTarget:self action:@selector(onRightButton:) forControlEvents:UIControlEventTouchUpInside];

    rc.size.height = 100;//self.view.bounds.size.height/3;
    rc.size.width = 100;//self.view.bounds.size.width/3;
    rc.origin.x = self.view.bounds.size.width/2 - 50;
    rc.origin.y = self.view.bounds.size.height - 100 ;
    UIButton *downButton = [[UIButton alloc]initWithFrame:rc];
    //downButton.backgroundColor = [UIColor orangeColor];
    [downButton setBackgroundImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
    downButton.alpha = 0.5;
    [downButton addTarget:self action:@selector(onDownButton:) forControlEvents:UIControlEventTouchUpInside];

    rc.size.height = 100;//self.view.bounds.size.height/3;
    rc.size.width = 100;//self.view.bounds.size.width/3;
    rc.origin.x = self.view.bounds.size.width/2 - 50;
    rc.origin.y = 0;
    UIButton *upButton = [[UIButton alloc]initWithFrame:rc];
    //upButton.backgroundColor = [UIColor orangeColor];
    [upButton setBackgroundImage:[UIImage imageNamed:@"up-arrow"] forState:UIControlStateNormal];
    upButton.alpha = 0.5;
    [upButton addTarget:self action:@selector(onUpButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    rc.size.height = 20;
    rc.size.width = 40;
    rc.origin.x = self.view.bounds.size.width - 140;
    rc.origin.y = 10;
    _socketStatusLabel = [[UILabel alloc]initWithFrame:rc];
    _socketStatusLabel.textColor = [UIColor redColor];
    _socketStatusLabel.text = @"控制";
    [self.view addSubview:_socketStatusLabel];

    
    rc.size.height = 20;
    rc.size.width = 40;
    rc.origin.x = self.view.bounds.size.width - 100;
    rc.origin.y = 10;
    _videoStatusLabel = [[UILabel alloc]initWithFrame:rc];
    _videoStatusLabel.textColor = [UIColor greenColor];
    _videoStatusLabel.text = @"视频";
    [self.view addSubview:_videoStatusLabel];
    
    [self.view addSubview:leftButton];
    [self.view addSubview:rightButton];
    [self.view addSubview:upButton];
    [self.view addSubview:downButton];
    
    [self connectServer:SERVER_IP port:SERVER_PORT];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (int) connectServer: (NSString *) hostIP port:(int) hostPort{
    
    if (self.client == nil) {
        self.client = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        //192.168.110.128
        if (![self.client connectToHost:hostIP onPort:hostPort error:&err]) {
            NSLog(@"%ld %@", (long)[err code], [err localizedDescription]);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"connection failed to host" message:[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            //client = nil;
            return SRV_CONNECT_FAIL;
        } else {
            NSLog(@"Conectou!");
            return SRV_CONNECT_SUC;
        }
    }
    else {
        [self.client readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
    }
    
}

- (void) sendMsg:(NSString *)content
{
    
    NSLog(@"%@",content);
    NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.client writeData:data withTimeout:-1 tag:0];
    
    //[data release];
    //[content release];
    //[inputMsgStr release];
    //继续监听读取
    //[client readDataWithTimeout:-1 tag:0];
}
#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [self.client readDataWithTimeout:-1 tag:0];
#if 0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"connection to host" message:@""preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
#endif
    _socketStatusLabel.textColor = [UIColor greenColor];
    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"disconneced from host\n %@",[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]] );
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString *msg = @"Sorry this connect is failure";
    self.client = nil;
    _socketStatusLabel.textColor = [UIColor redColor];
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Hava received datas is :%@",aStr);
    [self.client readDataWithTimeout:-1 tag:0];
}


#pragma Button events

-(void)onLeftButton:sender
{
    [self sendMsg:@"left"];
}

-(void)onRightButton:sender
{
    [self sendMsg:@"right"];

}

-(void)onDownButton:sender
{
    [self sendMsg:@"down"];

}

-(void)onUpButton:sender
{
    [self sendMsg:@"up"];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)onTapGesture:(UITapGestureRecognizer *)recognizer
{
#if 0
    NSLog(@"tapped");
    CGPoint point = [recognizer locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    switch ([self parsePosition:&point]) {
        case VisualButtonUp:
            NSLog(@"up");
            [self sendMsg:@"up"];
            break;
        case VisualButtonDown:
            NSLog(@"down");
            [self sendMsg:@"down"];
            break;
        case VisualButtonLeft:
            NSLog(@"left");
            [self sendMsg:@"left"];
            break;
        case VisualButtonRight:
            NSLog(@"right");
            [self sendMsg:@"right"];
            break;
        default:
            break;
    }
#endif
}
-(VisualButton)parsePosition:(CGPoint *)point
{
    if ((point->x > CGRectGetWidth(self.view.bounds)*2/3) && (point->y > CGRectGetHeight(self.view.bounds)/3) && (point->y < CGRectGetHeight(self.view.bounds)*2/3)) {
        return VisualButtonRight;
    }
    
    if(point->x < CGRectGetWidth(self.view.bounds)/3 && (point->y > CGRectGetHeight(self.view.bounds)/3) && (point->y < CGRectGetHeight(self.view.bounds)*2/3))
    {
        return VisualButtonLeft;
    }
    
    if ((point->y < CGRectGetHeight(self.view.bounds)/3) &&(point->x >CGRectGetWidth(self.view.bounds)/3) && (point->x < CGRectGetWidth(self.view.bounds)*2/3)) {
        return VisualButtonUp;
    }
    
    if ((point->y > CGRectGetHeight(self.view.bounds)*2/3) &&(point->x >CGRectGetWidth(self.view.bounds)/3) && (point->x < CGRectGetWidth(self.view.bounds)*2/3)) {
        return VisualButtonDown;
    }

    return VisualButtonUnknow;
}
-(void)onPanGesture:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"panend");
}

-(void)onUpSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"swip up");
    //self.navigatoerBar.backgroundColor = [UIColor redColor];

}

-(void)onDownSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"swip down");
   
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
