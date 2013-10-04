//
//  SmartView.m
//  McDonalds View
//
//  Created by Daher Alfawares on 7/9/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "SmartView.h"
#import "DynamicScrollView.hpp"

@interface SmartView () <UIScrollViewDelegate>
@property IBOutlet DynamicScrollView* scrollView;
@property NSTimer* timer;
@end

@implementation SmartView

-(void)addViewFromNibNamed:(NSString*)name
{
    UIView* page = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.scrollView addDynamicView:page];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.scrollView addSubview:[[[NSBundle mainBundle] loadNibNamed:@"AllBackgroundsView" owner:self options:nil] objectAtIndex:0]];
    
    [self addViewFromNibNamed:@"WeatherView"];
    [self addViewFromNibNamed:@"AwesomenessView"];
    [self addViewFromNibNamed:@"Twitter"];
    [self addViewFromNibNamed:@"Meetings"];
}



#pragma mark -
#pragma mark UIScrollViewDelegate methods


-(void)prepareIntro
{
    [self.scrollView prepareIntro];
}

-(void)animateIntro
{
    [self.scrollView animateIntro];
}


@end
