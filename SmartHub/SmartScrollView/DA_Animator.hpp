//
//  Animator.h
//  Solstice-Mobile
//
//  Created by Daher Alfawares on 6/24/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#ifndef __Solstice_Mobile__Animator__
#define __Solstice_Mobile__Animator__

#include "DA_View.hpp"

#include <memory>
#include <vector>

namespace DA
{
    class Animator
    {
    protected:
        std::vector<View::pointer_type> views;
        
    public:
        void add( View::pointer_type view )
        {
            this->views.push_back(view);
        }
        
        size_t size() const
        {
            return this->views.size();
        }

        virtual void activate()
        {
            for( size_t i=0; i< this->size(); i++ )
            {
                View::pointer_type& pointer = this->views[i];
                pointer->activate();
            }
        }
        
        virtual void update_x( float x, float size )
        {
            for( size_t i=0; i< this->size(); i++ )
            {
                View::pointer_type& pointer = this->views[i];
                pointer->update_x(x,size);
            }
        }
        
        virtual void update_y( float y, float size )
        {
            for( size_t i=0; i< this->size(); i++ )
            {
                View::pointer_type& pointer = this->views[i];
                pointer->update_y(y,size);
            }
        }

    protected:
    };
}

#endif
