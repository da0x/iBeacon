//
//  HubViewController.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/3/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "HubViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface HubViewController ()
@property bool welcomeDisplayed;
@end

@implementation HubViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *ipAddress = [self getIPAddress];
    
    [serverAddress setText:[NSString stringWithFormat:@"Server Address: %@", ipAddress]];
    
	server = [[FastServerSocket alloc] initWithPort:@"35000"];
    
	[NSThread detachNewThreadSelector:@selector(listenAndRepeat:) toTarget:self withObject:nil];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}

-(void)displayWelcome
{
    if( !self.welcomeDisplayed )
    {
        [self performSegueWithIdentifier:@"robbie" sender:self];
        self.welcomeDisplayed = true;
    }
}

-(void)dismissWelcome
{
    if( self.welcomeDisplayed )
    {
        [self dismissViewControllerAnimated:true completion:nil];
        self.welcomeDisplayed = false;
    }
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
            
			NSString *receivedString = [NSString stringWithUTF8String:buf];
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