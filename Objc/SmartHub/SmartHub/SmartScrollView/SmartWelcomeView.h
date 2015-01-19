//
//  SmartView.h
//  McDonalds View
//
//  Created by Daher Alfawares on 8/6/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartWelcomeView : UIView
-(void)prepareIntro;
-(void)animateIntro;

-(void)scrollToPage:(int)page;
@end
