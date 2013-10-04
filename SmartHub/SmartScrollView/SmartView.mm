//
//  SmartView.m
//  McDonalds View
//
//  Created by Daher Alfawares on 7/9/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "SmartView.h"
#import "DynamicScrollView.hpp"

@interface SmartView () <UIScrollViewDelegate>
@property (nonatomic,weak) IBOutlet DynamicScrollView* scrollView;
@property (nonatomic,weak) IBOutlet UIPageControl*   pageControl;
@property (nonatomic,weak) IBOutlet UIButton*   locationButton;
@property (nonatomic,weak) IBOutlet UIButton*   largeLocationButton;
@property (nonatomic,strong) UIView *shade;
@property (nonatomic) CGRect  originalLargeButtonFrame;
@end

@implementation SmartView

-(void)addViewFromNibNamed:(NSString*)name
{   
    UIView* page = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    [self.scrollView addDynamicView:page];
    [self.largeLocationButton setHidden:YES];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.scrollView addSubview:[[[NSBundle mainBundle] loadNibNamed:@"AllBackgroundsView" owner:self options:nil] objectAtIndex:0]];
    
    [self addViewFromNibNamed:@"WeatherView"];
    [self addViewFromNibNamed:@"AwesomenessView"];
//    [self addViewFromNibNamed:@"LocationView"];
//    [self addViewFromNibNamed:@"PromotionView"];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    uint page = sender.contentOffset.x / sender.frame.size.width;
    [self.pageControl setCurrentPage:page];
}

#pragma mark - location alert animation

-(IBAction)orderPressed:(id)sender{
    //Hide the small button
    [self.locationButton setHidden:YES];
    
    //Add the shade
    self.shade = [[UIView alloc] initWithFrame:self.bounds];
    [self.shade setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadePressed)];
    [self.shade addGestureRecognizer:tap];
    [self addSubview:self.shade];
    
    //Bring the large button to the front
    [self.largeLocationButton setHidden:NO];
    [self bringSubviewToFront:self.largeLocationButton];
    
    [self performSelector:@selector(animateLocationButtonOn) withObject:nil afterDelay:.1];
}

-(void)shadePressed{
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.largeLocationButton setFrame:self.originalLargeButtonFrame];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Done");
                         [self.largeLocationButton setHidden:YES];
                         [self.locationButton setHidden:NO];
                         [self.shade removeFromSuperview];
                         self.shade = nil;
                     }];
}

-(void)animateLocationButtonOn
{
    self.originalLargeButtonFrame =self.largeLocationButton.frame;
    
    CGFloat newX = (self.frame.size.width - self.largeLocationButton.frame.size.width)/2.0;
    CGFloat newY = (self.frame.size.height - self.largeLocationButton.frame.size.height)/2.0;
    
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.largeLocationButton setFrame:CGRectMake(newX,
                                                                  newY,
                                                                  self.largeLocationButton.frame.size.width,
                                                                  self.largeLocationButton.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Done");
                     }];
}


-(void)cleanView{
    //Remove shade
    [self.shade removeFromSuperview];
    self.shade = nil;
    
    //move the button back and hide
    self.largeLocationButton.frame = self.originalLargeButtonFrame;
    [self.largeLocationButton setHidden:YES];
    [self.locationButton setHidden:NO];
}


-(void)prepareIntro
{
    [self.scrollView prepareIntro];
}

-(void)animateIntro
{
    [self.scrollView animateIntro];
}


@end
