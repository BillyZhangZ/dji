//
//  LiveStream.h
//  stream
//
//  Created by ludong on 13-1-26.
//  Copyright (c) 2013年 ludong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LiveStream : NSObject
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *url;

-(void)startLive;
-(void)stopLive;
@end
