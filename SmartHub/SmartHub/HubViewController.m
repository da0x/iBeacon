//
//  HubViewController.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/3/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "HubViewController.h"


@interface HubViewController ()

@end

@implementation HubViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	server = [[FastServerSocket alloc] initWithPort:@"35000"];
	
    [NSThread detachNewThreadSelector:@selector(listenAndRepeat:) toTarget:self withObject:nil];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
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
            NSLog(@"%@",receivedString);
            
			// Allow other threads to work.
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
		}
		while(count > 0);
        
		NSLog(@"stopped listening with error: %@", (count < 0 ?[incoming lastError] : @"none"));
	}
}

@end