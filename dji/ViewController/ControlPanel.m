//
//  ControlPanel.m
//  dji
//
//  Created by 张志阳 on 11/29/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ControlPanel.h"

@implementation ControlPanel

- (instancetype) initWithFrame:(CGRect)Frame
{
    self = [super initWithFrame:Frame];
    
    if(self)
    {
        [self loadView];
    }
    
    return self;
}

- (void) loadView
{
    CGRect rcClient ,rc;

    rcClient = self.bounds;
    
    // left button
    rc = rcClient;
    rc.size.height = 40;
    rc.size.width = rcClient.size.width / 3;
    _btnLeft = [[UIButton alloc] initWithFrame:rc];
    _btnLeft.titleLabel.numberOfLines = 2;
    _btnLeft.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnLeft.backgroundColor = [UIColor blackColor];
    [self addSubview:_btnLeft];
}

@end
