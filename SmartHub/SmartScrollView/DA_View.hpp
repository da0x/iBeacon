//
//  View.hpp
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#ifndef __Solstice_Mobile__View__
#define __Solstice_Mobile__View__

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include <memory>

namespace DA
{
    class View
    {
    protected:
        float x, y;
        float w, h;
        UIView* view;
        
    public:
        typedef std::shared_ptr<View> pointer_type;
        
        View();
        
        View( UIView* v ): view(v)
        {
            this->x = view.frame.origin.x;
            this->y = view.frame.origin.y;
            this->w = view.frame.size.width;
            this->h = view.frame.size.height;
        }
        
        View( const View& copy ):View(copy.view)
        {
            x = copy.x;
            y = copy.y;
            w = copy.w;
            h = copy.h;
        }
        
        virtual void activate(){}
        virtual void update_x( float x, float size ){}
        virtual void update_y( float y, float size ){}
        
        void animate( CATransform3D pass, CATransform3D land )
        {
            [UIView animateWithDuration:0.1f delay:0.0f options:0 animations:^{
                this->view.layer.transform = pass;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05f animations:^{
                    this->view.layer.transform = land;
                }];
            }];
        }
        
        
        void animate( CATransform3D pass, CATransform3D repass, CATransform3D land )
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                this->view.layer.transform = pass;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    this->view.layer.transform = repass;
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        this->view.layer.transform = land;
                        
                    } completion:nil];
                }];
            }];
        }
    };
}

#endif
