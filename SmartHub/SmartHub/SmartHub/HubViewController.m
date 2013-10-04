//
//  HubViewController.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/3/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "HubViewController.h"

#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Bravia_powerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSInputStream *iStream;
	NSOutputStream *oStream;
	NSString *resultText;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction) togglePower:(id)sender;



@end

@implementation Bravia_powerAppDelegate

@synthesize window;

- (IBAction)togglePower:(id)sender
{
	NSHost *host = [NSHost hostWithAddress: @"192.168.1.70"];
	if (host != nil)
	{
		// iStream and oStream are instance variables
		[NSStream getStreamsToHost:host port:4998 inputStream:&iStream outputStream:&oStream];
        [COLOR="red"]warning: 'NSStream' may not respond to '+getStreamsToHost:port:inputStream:outputStream:'[/COLOR]
		
        
		//iStream is instance var of NSSInputStream
		[iStream retain];
		[iStream setDelegate:self];
		[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[iStream open];
		
		//oStream is instance var of NSSOutputStream
		[oStream retain];
		[oStream setDelegate:self];
		[oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[oStream open];
		
		NSError *streamError;
		streamError = [iStream streamError];
		streamError = [oStream streamError];
		
		NSStreamStatus streamStatus;
		streamStatus = [iStream streamStatus];
		streamStatus = [oStream streamStatus];
	}
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	NSString *io;
	if (theStream == iStream) io = @">>";
	else io = @"<<";
	
	NSString *event;
	switch (streamEvent)
	{
		case NSStreamEventNone:
			event = @"NSStreamEventNone";
			break;
		case NSStreamEventOpenCompleted:
			event = @"NSStreamEventOpenCompleted";
			break;
		case NSStreamEventHasBytesAvailable:
			event = @"NSStreamEventHasBytesAvailable";
			if (theStream == iStream)
			{
				//read data
				uint8_t buffer[1024];
				int len;
				while ([iStream hasBytesAvailable])
				{
					len = [iStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
					{
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						if (nil != output)
						{
							NSLog(@"%@ : %@", io, output);
						}
					}
				}
			}
			break;
		case NSStreamEventHasSpaceAvailable:
			event = @"NSStreamEventHasSpaceAvailable";
			if (theStream == oStream)
			{
				//send data
				uint8_t buffer[] = "sendir,2:1,1,40000,1,1,96,22,49,22,24,23,49,22,24,23,49,22,24,23,24,23,49,22,24,23,24,23,24,23,24,1025,96,22,49,22,24,23,49,22,24,23,49,22,24,23,24,23,49,22,24,23,24,23,24,23,24,1025,96,22,49,22,24,23,49,22,24,23,49,22,24,23,24,23,49,22,24,23,24,23,24,23,24,1025,96,22,49,22,24,23,49,22,24,23,49,22,24,23,24,23,49,22,24,23,24,23,24,23,24,1025,96,22,49,22,24,23,49,22,24,23,49,22,24,23,24,23,49,22,24,23,24,23,24,23,24,1987\r";
				int len;
				
				len = [oStream write:buffer maxLength:sizeof(buffer)];
				
				if (len > 0)
				{
					NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
					NSLog(@"%@ : %@", io, output);
					[oStream close];
				}
			}
			break;
		case NSStreamEventErrorOccurred:
			event = @"NSStreamEventErrorOccurred";
			break;
		case NSStreamEventEndEncountered:
			event = @"NSStreamEventEndEncountered";
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            theStream = nil;
			
			break;
		default:
			event = @"** Unknown";
	}
	
	NSLog(@"%@ : %@", io, event);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

@end







@interface HubViewController ()

@end

@implementation HubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
