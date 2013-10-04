//
//  HubViewController.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/3/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "HubViewController.h"
#import "SmartView.h"
#import "SmartWelcomeView.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface HubViewController ()
@property bool welcomeDisplayed;
@property int page;
@property int pageFactor;
@end

@implementation HubViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pageFactor = -1;
    
    serverAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    serverAddress.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [serverAddress setTitle:[NSString stringWithFormat:@"Server Address: %@", [self getIPAddress]] forState:UIControlStateNormal];
    
	server = [[FastServerSocket alloc] initWithPort:@"35000"];
    
	[NSThread detachNewThreadSelector:@selector(listenAndRepeat:) toTarget:self withObject:nil];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
    timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(tick) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    CATransform3D transform = CATransform3DMakeRotation(3*M_PI_2, 0, 0, 1);
    
    [self.view.layer setTransform:transform];
    for(UIView *view in self.view.subviews){
        view.layer.transform = transform;
    }
}

- (void)restartSlides
{
    [(SmartView*)self.view prepareIntro];
    [(SmartView*)self.view performSelector:@selector(animateIntro) withObject:nil afterDelay:.2];
}

- (void)tick
{
    if( self.page >= 3 || self.page <= 0 )
    {
        self.pageFactor = self.pageFactor * -1;
    }
    
    self.page = self.page + self.pageFactor;

    [(SmartView*)self.view scrollToPage:self.page];
    
}

- (IBAction)toggleServerAddressHidden:(id)sender
{    
    static BOOL shouldHide = NO;
    
    if(shouldHide)
    {
        [serverAddress setTitle:[NSString stringWithFormat:@"Server Address: %@", [self getIPAddress]] forState:UIControlStateNormal];
    }
    else
    {
        [serverAddress setTitle:@"" forState:UIControlStateNormal];
    }
    
    shouldHide = !shouldHide;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)displayWelcome
{
    if( !self.welcomeDisplayed )
    {
        [self performSegueWithIdentifier:@"robbie" sender:self];
        self.welcomeDisplayed = true;
    }
}

- (void)dismissWelcome
{
    if( self.welcomeDisplayed )
    {
        [(SmartWelcomeView*)self.presentedViewController.view scrollToPage:1];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    }
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:true completion:nil];
    self.welcomeDisplayed = false;
}

- (void)dealloc
{
	[server close];
	server = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)simpleListen:(id)obj
{
	@autoreleasepool {
		[server listen]; // Incoming connections just queue up.
	}
}

- (void)listenAndRepeat:(id)obj
{
	@autoreleasepool {
		NSLog(@"started listening");
		[server listen];
        
		FastSocket *incoming = [server accept];
        
		if(!incoming)
		{
			NSLog(@"accept error: %@", [server lastError]);
			return;
		}
        
		// Read some bytes then echo them back.
		int bufSize = 2048;
		unsigned char buf[bufSize];
		long count = 0;
        
		do {
			// Read bytes.
			count = [incoming receiveBytes:buf limit:bufSize];
            
            //			// Write bytes.
            //			long remaining = count;
            //
            //			while(remaining > 0)
            //			{
            //				count = [incoming sendBytes:buf count:remaining];
            //				remaining -= count;
            //			}
            
			NSString *receivedString = [NSString stringWithUTF8String:(const char*)buf];
			NSLog(@"%@", receivedString);
            
            if( [receivedString isEqualToString:@"distance:0"] )
            {
                [self performSelectorOnMainThread:@selector(displayWelcome) withObject:nil waitUntilDone:true];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(dismissWelcome) withObject:nil waitUntilDone:true];
            }
            
			// Allow other threads to work.
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
		}
		while(count > 0);
        
		NSLog(@"stopped listening with error: %@", (count < 0 ?[incoming lastError] : @"none"));
	}
}

// Get IP Address
- (NSString *)getIPAddress
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
    
	if(success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
        
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
            
			temp_addr = temp_addr->ifa_next;
		}
	}
    
	// Free memory
	freeifaddrs(interfaces);
	return address;
    
}

@end