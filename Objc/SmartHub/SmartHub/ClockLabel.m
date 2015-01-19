//
//  ClockLabel.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/4/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "ClockLabel.h"

@implementation ClockLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    
	if(self)
	{
		self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:true];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"h:mm a"];
        
        [self setTimeWithDate:[NSDate date]];
        
		[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
	}
    
	return self;
}

- (void)tick
{
    [self setTimeWithDate:[NSDate date]];
}

- (void)setTimeWithDate:(NSDate *)date
{
    self.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:date]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end