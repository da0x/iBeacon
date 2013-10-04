//
//  ThumbnailAnimator.h
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#ifndef __Solstice_Mobile__ThumbnailAnimator__
#define __Solstice_Mobile__ThumbnailAnimator__

#include "DA_Animator.hpp"

namespace DA
{
    class ThumbnailAnimator : public View
    {
        bool focus;
    public:
        ThumbnailAnimator( UIView* view ): View(view)
        {
        }
        
        void activate()
        {
            focus = true;
            this->exitFocus();
        }
        
        // f(a,p,s,s') returns a'' ( position of a around axis p in domain 1 with scaled domain s'
        // domain 1 is full view
        // domain 2 is scaled view
        // domain 3 is domain 2 around reference point p
        // a position in domain 1
        // p reference point in domain 1
        // s is size of domain 1
        // s' is size in domain 2
        // returns a in domain 3 per reference p
        // ----------------------------------
        // a'  = a * s' / s
        // p'  = p * s' / s
        // ----------------------------------
        // a'' = p + a' - p'
        //     = p + a * s' / s - p * s' / s
        //     = p + ( s / s' ) * ( a - p )
        // ----------------------------------
        float f( float a, float p, float s, float s_ )
        {
            return p + ( s_ / s ) * ( a - p );
        }
        
        void update_x( float x, float size )
        {
            if ( size == 0 )
                return;
            
                // move the view get params.
            float a = this->x;       // position in domain 1
            float p = x;             // offset in domain 1
            float s = size;          // size for domain 1
            float s_ = s * 0.5f;    // one third the size.
            
            float a__ = f( a, p, s, s_ );
            
            CGRect frame;
            frame.origin.x      = a__;
            frame.origin.y      = 0.0f;
            frame.size.width    = this->w;
            frame.size.height   = this->h;
            
            [this->view setFrame:frame];
            
                // apply transformations.
            float offset   = x;
            float distance = ( offset - this->x );
            bool  inView   = fabs(distance) < 200;
            if( inView )
                this->enterFocus();
            else
                this->exitFocus();
            
            if( inView )
            {
                [this->view.superview bringSubviewToFront:this->view];
            }
        }
    
        void enterFocus()
        {
            if( this->focus )
                return;
            
            this->focus = true;
            
            // going in.
            CATransform3D pass = CATransform3DMakeScale( 0.90f, 0.90f, 0.90f );
            CATransform3D land = CATransform3DMakeScale( 0.80f, 0.80f, 0.80f );
            
            this->animate(pass,land);
        }
        
        void exitFocus()
        {
            if( !this->focus )
                return;
            
            this->focus = false;
            
            // going out.
            CATransform3D pass = CATransform3DMakeScale( 0.68f, 0.68f, 0.68f );
            CATransform3D land = CATransform3DMakeScale( 0.70f, 0.70f, 0.70f );
            
            this->animate(pass, land);
        }

    };
}

#endif
