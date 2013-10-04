//
//  DA_ScrollView.cpp
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#include "DA_ScrollView.hpp"

@implementation DAScrollView

    // sets and activates the animator.
-(void)setAnimator:(DA::Animator*)animator
{
    _animator = animator;
    _animator->activate();
    
    [self setContentOffset:self.contentOffset];
}

    // updates the animator with offset changes.
-(void)setContentOffset:(CGPoint)offset
{
    [super setContentOffset:offset];
    
    if( _animator )
    {
        _animator->update_x( [self offset_x:offset], [self content_x] );
        _animator->update_y( [self offset_y:offset], [self content_y] );
    }
}

-(float)offset_x:(CGPoint)offset
{
    return offset.x;
}

-(float)offset_y:(CGPoint)offset
{
    return offset.y;
}

-(float)content_x
{
    return self.contentSize.width - self.frame.size.width;
}

-(float)content_y
{
    return self.contentSize.height - self.frame.size.height;
}

@end
