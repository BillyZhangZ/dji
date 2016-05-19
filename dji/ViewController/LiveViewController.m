//
//  LiveViewController.m
//  call_demo
//
//  Created by ludong on 13-1-26.
//  Copyright (c) 2013年 ludong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LiveViewController.h"
#import "LiveStream.h"

@interface LiveViewController ()
@property NSString *url;
@property UIImageView *imageView;
@property LiveStream *liveStream;

@end

@implementation LiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
#if 1
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:_imageView];
    
	_liveStream = [[LiveStream alloc] init];
    //[self setUrl:  @"rtsp://218.204.223.237:554/live/1/67A7572844E51A64/f68g2mj7wjua3la7.sdp"];
    //test local
    //[self setUrl:  @"rtsp://192.168.1.10:554/user=admin&password=&channel=1&stream=0.sdp?real_stream"];

    [_liveStream setUrl:[self url]];
    [_liveStream setImageView:[self imageView]];
    [_liveStream startLive];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

@end
