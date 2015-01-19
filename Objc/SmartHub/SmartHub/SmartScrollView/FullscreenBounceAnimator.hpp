//
//  FullscreenBounceAnimator.h
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#ifndef __Solstice_Mobile__FullscreenBounceAnimator__
#define __Solstice_Mobile__FullscreenBounceAnimator__

#include "DA_Animator.hpp"

namespace DA
{
    class FullscreenBounceAnimator : public View
    {
        bool full;
    public:
        FullscreenBounceAnimator( UIView* view ): View(view)
        {
        }
        
        void activate()
        {
            CATransform3D pass   = CATransform3DMakeScale( 1.00f, 1.00f, 1.00f );
            CATransform3D repass = CATransform3DMakeScale( 0.92f, 0.92f, 0.92f );
            CATransform3D land   = CATransform3DMakeScale( 1.00f, 1.00f, 1.00f );
            
            this->animate(pass, repass, land);
        }
        
        void update_x( float x, float size )
        {            
            CGRect frame;
            frame.origin.x      = this->x;
            frame.origin.y      = this->y;
            frame.size.width    = this->w;
            frame.size.height   = this->h;
            
            [this->view setFrame:frame];
        }
    };
}


#endif
