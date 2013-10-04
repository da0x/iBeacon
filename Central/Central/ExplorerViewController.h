//
//  ExplorerViewController.h
//  Explorer
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastSocket.h"

@interface ExplorerViewController : UIViewController
{
    FastSocket *client;
}

- (IBAction)userNear:(id)sender;
- (IBAction)userAway:(id)sender;

@end