//
//  MainViewController.h
//  dji
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#define SRV_CONNECTED 0
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 2
#define SERVER_IP @"192.168.1.103"
#define SERVER_PORT 5000


typedef NS_OPTIONS(NSUInteger, VisualButton) {
    VisualButtonRight = 1 << 0,
    VisualButtonLeft  = 1 << 1,
    VisualButtonUp    = 1 << 2,
    VisualButtonDown  = 1 << 3,
    VisualButtonUnknow = 1 << 4,
};
@interface MainViewController : UIViewController
@property (nonatomic, retain) AsyncSocket *client;
@end
