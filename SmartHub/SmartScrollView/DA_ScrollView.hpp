//
//  DA_ScrollView.hpp
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "DA_Animator.hpp"

@interface DAScrollView : UIScrollView
@property (nonatomic) DA::Animator* animator;
@end
