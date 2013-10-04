//
//  SmartView.m
//  McDonalds View
//
//  Created by Daher Alfawares on 7/9/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "SmartWelcomeView.h"
#import "DynamicScrollView.hpp"

@interface SmartWelcomeView () <UIScrollViewDelegate>
@property IBOutlet DynamicScrollView* scrollView;
@property NSTimer* timer;
@end

@implementation SmartWelcomeView

-(void)addViewFromNibNamed:(NSString*)name
{
    UIView* page = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.scrollView addDynamicView:page];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addViewFromNibNamed:@"Welcome"];
    [self addViewFromNibNamed:@"Goodbye"];
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


-(void)scrollToPage:(int)page
{
    [self.scrollView scrollToPage:page];
}

@end
