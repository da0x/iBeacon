//
//  SmartScrollView.h
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/17/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#include "DA_ScrollView.hpp"

#include <UIKit/UIKit.h>

@interface DynamicScrollView : DAScrollView {
    DA::Animator    dynamicAnimator;
}

-(void)prepareIntro;
-(void)animateIntro;
-(void)addView:(UIView*)view;
-(void)addDynamicView:(UIView*)view;
-(void)addFastDynamicView:(UIView*)view;
-(void)addThumbnailView:(UIView*)view;

-(void)scrollToPage:(int)page;

@end
