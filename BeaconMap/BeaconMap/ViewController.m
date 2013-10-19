//
//  ViewController.m
//  BeaconMap
//
//  Created by Pablo Bartolome on 10/10/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *beacons;
@property (weak, nonatomic) IBOutlet UILabel *beacon0;
@property (weak, nonatomic) IBOutlet UILabel *beacon1;
@property (weak, nonatomic) IBOutlet UILabel *beacon2;
@property (weak, nonatomic) IBOutlet UILabel *beacon3;
@property (weak, nonatomic) IBOutlet UILabel *beacon4;

//One of the beacons is going to be our destination
@property (assign, nonatomic) int destination;

@property (nonatomic, weak) UILabel *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beacons = @{@0:self.beacon0,
                    @1:self.beacon1,
                    @2:self.beacon2,
                    @3:self.beacon3,
                    @4:self.beacon4};
    
    
    AppDelegate* appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.mapViewController = self;
    
    [self updateDestinationAnimationWithStatus:CLProximityUnknown];
}

- (int)destination {
    if (_destination == 0){
        _destination = 1;
    }
    return _destination;
}

- (void)beaconReceived:(CLBeacon*)beacon {
    if (beacon.major.integerValue < [self.beacons count]) {
        if (beacon.major.intValue == self.destination) [self updateDestinationAnimationWithStatus:beacon.proximity];
        
        UILabel *tableBeacon = [self.beacons objectForKey:beacon.major];
        switch (beacon.proximity) {
            case CLProximityImmediate:
            {
                [tableBeacon setBackgroundColor:[UIColor greenColor]];
            }
                break;
            case CLProximityNear:
            {
                
                [tableBeacon setBackgroundColor:[UIColor yellowColor]];
            }
                break;
            case CLProximityFar:
            {
                [tableBeacon setBackgroundColor:[UIColor redColor]];
            }
                break;
            case CLProximityUnknown:
            {
                [tableBeacon setBackgroundColor:[UIColor grayColor]];
            }
                break;
                
            default:
                [tableBeacon setBackgroundColor:[UIColor whiteColor]];
                
                break;
        }
        
    }
    
}

-(void)updateDestinationAnimationWithStatus:(CLProximity)proximity {
    UILabel *destinationBeacon = (UILabel *)[self.beacons objectForKey:[NSNumber numberWithInt:self.destination]];
    [destinationBeacon.layer removeAllAnimations];

    float duration;
    
    switch (proximity) {
        case CLProximityImmediate:
        {
            duration = 0.3f;
        }
            break;
        case CLProximityNear:
        {
            
            duration = 0.5f;
        }
            break;
        case CLProximityFar:
        {
            duration = 1.f;
        }
            break;
        case CLProximityUnknown:
        {
            duration = 3.f;
        }
            break;
            
        default:
            
            
            break;
    }
    
    CABasicAnimation *blinkAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    blinkAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    blinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
    blinkAnimation.additive = NO;
    blinkAnimation.removedOnCompletion = YES;
    blinkAnimation.beginTime = 0;
    blinkAnimation.duration = duration;
    blinkAnimation.fillMode = kCAFillModeForwards;
    blinkAnimation.repeatCount = INFINITY;
    
    [destinationBeacon.layer addAnimation:blinkAnimation forKey:@"blink"];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UILabel *label in self.view.subviews) {
            if (CGRectContainsPoint(label.frame, touchPoint)) {
                
                label.center = CGPointMake(touchPoint.x, touchPoint.y);
                label.frame = CGRectInset(label.frame, -10, -10);
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UILabel *label in self.view.subviews) {
            if (CGRectContainsPoint(label.frame, touchPoint)) {
                
                label.center = CGPointMake(touchPoint.x, touchPoint.y);
                
            }
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UILabel *label in self.view.subviews) {
            if (CGRectContainsPoint(label.frame, touchPoint)) {
                
                label.center = CGPointMake(touchPoint.x, touchPoint.y);
                label.frame = CGRectInset(label.frame, 10, 10);

            }
        }
    }
}

@end
