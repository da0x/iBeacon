//
//  DynamicsAnimator.h
//  McDonalds
//
//  Created by Daher Alfawares on 8/7/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#ifndef __McDonalds__DynamicAnimator__
#define __McDonalds__DynamicAnimator__

#include "DA_Animator.hpp"

namespace DA
{
    struct Subview
    {
        CGRect frame;
        UIView* view;
        UIAttachmentBehavior* attachment;
    };
    
    class DynamicAnimator : public View
    {
        UIAttachmentBehavior *attachment;
    public:
        std::vector<Subview> subviews;
        
        enum class Speed
        {
            Slow, Fast, Reserved
        };
        
        DynamicAnimator( UIView* view, UIDynamicAnimator* uiAnimator, Speed speed = Speed::Slow ): View(view)
        {
            
            attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:view.center];
            [attachment setDamping:.5];
            [attachment setFrequency:4.0];
            [uiAnimator addBehavior:attachment];
            
            // remove subviews and add them to animator
            for ( UIView* subview in view.subviews )
            {
                CGRect internalFrame = subview.frame;
                
                [subview removeFromSuperview];
                
                CGRect newFrame = CGRectMake(this->x+internalFrame.origin.x,
                                             this->y+internalFrame.origin.y,
                                             internalFrame.size.width,
                                             internalFrame.size.height);
                [subview setFrame:newFrame];
                
                [view.superview addSubview:subview];
            
                DynamicSettings constant = this->dynamic_settings(speed);
                
                UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:subview attachedToAnchor:subview.center];
                [attachment setDamping:constant.Damping];
                
                const float ViewArea = view.frame.size.width*view.frame.size.height;
                const float SubviewArea = subview.frame.size.width*subview.frame.size.height;
                
                const float FrequencyDifference = constant.DifferenceFactor*( SubviewArea/ViewArea );
                
                [attachment setFrequency:constant.MinimumFrequency + FrequencyDifference];
                [attachment setLength:5];
                
                
                [uiAnimator addBehavior:attachment];
                
                DA::Subview internal_view = {
                    internalFrame,
                    subview,
                    attachment
                };
                
                this->subviews.push_back(internal_view);
            }
        }
        
        void activate()
        {
            CATransform3D pass   = CATransform3DMakeScale( 1.00f, 1.00f, 1.00f );
            CATransform3D repass = CATransform3DMakeScale( 0.92f, 0.92f, 0.92f );
            CATransform3D land   = CATransform3DMakeScale( 1.00f, 1.00f, 1.00f );
            
            this->animate(pass, repass, land);
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
        //     = p + ( s' / s ) * ( a - p )
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
            float s_ = s * 3.f;      // three times the size.
            
            float a__ = f( a, p, s, s_ );
            /*
            CGPoint center;
            center.x      = a__+(this->w/2);
            center.y      = 0.0f + (this->h/2);
            
            [this->attachment setAnchorPoint:center];
            */
            
            CGRect frame;
            frame.origin.x      = a__;
            frame.origin.y      = 0.0f;
            frame.size.width    = this->w;
            frame.size.height   = this->h;
            
            [this->view setFrame:frame];
            
            
            CGPoint origin;
            origin.x = a__;
            origin.y = 0;
            for( int i=0; i< this->subviews.size(); i++ )
            {
                Subview &subview = this->subviews[i];
                
                CGPoint ancor = CGPointMake(origin.x + subview.frame.origin.x + subview.frame.size.width/2.f,
                                            origin.y + subview.frame.origin.y + subview.frame.size.height/2.f );
                [subview.attachment setAnchorPoint:ancor];
            }
        }
        
    protected:
        struct DynamicSettings {
            float Damping;
            float DifferenceFactor;
            float MinimumFrequency ;
        };
        
        virtual DynamicSettings dynamic_settings(Speed speed)
        {
            DynamicSettings dynamicConstants[] = {
                {  .7, 1, 1  }, // Speed::Slow
                {  .6, 3, 2  }, // Speed::Fast
                {  .3, 2, 3  }, // No name yet
            };
            
            return dynamicConstants[static_cast<int>(speed)];
        }
    };
}


#endif /* defined(__McDonalds__BackwardsAnimator__) */

