//
//  SmartScrollView.m
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/17/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "DynamicScrollView.hpp"
#import <QuartzCore/QuartzCore.h>

#include "DynamicAnimator.hpp"
#include "ThumbnailAnimator.hpp"


@interface DynamicScrollView()
@property (nonatomic) bool pinched;
@property (nonatomic,strong) UIDynamicAnimator* uianimator;
@property (nonatomic,assign) int numberOfViews;
@end

@implementation DynamicScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animator = &dynamicAnimator;
        self.uianimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return self;
}

-(void)prepareIntro
{
    [self setContentOffset:CGPointMake( -self.frame.size.width, 0 ) animated:false];
}
-(void)animateIntro
{
    [self setContentOffset:CGPointZero animated:true];
}

-(void)addView:(UIView*)view
{
    float width  = self.frame.size.width;
    float height = self.frame.size.height;

    int   index         = self.numberOfViews++;
    float offset        = index  * width;

        // update frame.
    CGRect viewFrame   = { offset, 0, width, height };
    view.frame = viewFrame;
    
        // update content size.
    CGSize contentSize = { offset + width,   height };
    self.contentSize = contentSize;
    
        // add view
    [self addSubview:view];
}

-(void)addDynamicView:(UIView*)view
{
    [self addView:view];
    
    // ready, add it to super.
    DA::DynamicAnimator* animator_pointer = new DA::DynamicAnimator( view, self.uianimator );
    
    dynamicAnimator.add( DA::View::pointer_type( animator_pointer ) );
    dynamicAnimator.activate();
}
-(void)addFastDynamicView:(UIView*)view
{
    [self addView:view];
    
    // ready, add it to super.
    DA::DynamicAnimator* animator_pointer = new DA::DynamicAnimator( view, self.uianimator, DA::DynamicAnimator::Speed::Fast );
    
    dynamicAnimator.add( DA::View::pointer_type( animator_pointer ) );
    dynamicAnimator.activate();
}

-(void)addThumbnailView:(UIView*)view
{
    [self addView:view];
    
    DA::ThumbnailAnimator* animator_pointer = new DA::ThumbnailAnimator( view );
    dynamicAnimator.add( DA::View::pointer_type( animator_pointer ) );
    dynamicAnimator.activate();
}


-(void)scrollToPage:(int)page
{
    [self setContentOffset:CGPointMake(page*self.frame.size.height, 0) animated:true];
}

@end


