//
//  al7ios framework
//  (C) Copyright 2010-11 Alexandre Leite. All rights reserved. 
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ALFlipView.h"


@implementation ALFlipView

@synthesize views, transitionType, flipDuration;

#pragma mark - Initializers;

-(id)initWithFrame:(CGRect)aFrame andViews:(NSArray *)someViews {
    self = [super initWithFrame:aFrame];
    if (self) {
        //- set initial properties;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFlipDuration:0.5];

        //- set views;
        NSMutableArray *myViews = [NSMutableArray arrayWithArray:someViews];
        [self setViews:myViews];
        
        //- adjust views frame;
        for (UIView *aView in [self views]) {
            [aView setFrame:CGRectMake(0.0, 0.0, [self frame].size.width, [self frame].size.height)];
        }
        
        //- place view;
        if ([[self views] count] > 0) {
            [self flipToViewAtIndex:0];
        }
    }
    return self;
}

#pragma mark - Public Methods;

-(void)flipToViewAtIndex:(NSUInteger)viewIndex {
    if ([[self subviews] count] > 0) {
        UIView *oldView = [[self subviews] objectAtIndex:0];
        UIView *newView = [[self views] objectAtIndex:viewIndex];

        if (newView != nil && newView != oldView) {
            UIViewAnimationOptions flipTransitionType = UIViewAnimationOptionTransitionFlipFromLeft;
            switch ([self transitionType]) {
                case ALFlipViewTransitionTypeFlipFromLeft:
                    flipTransitionType = UIViewAnimationOptionTransitionFlipFromLeft;
                    break;
                case ALFlipViewTransitionTypeFlipFromRight:
                    flipTransitionType = UIViewAnimationOptionTransitionFlipFromRight;
                    break;
                case ALFlipViewTransitionTypeCurlUp:
                    flipTransitionType = UIViewAnimationOptionTransitionCurlUp;
                    break;
                case ALFlipViewTransitionTypeCurlDown:
                    flipTransitionType = UIViewAnimationOptionTransitionCurlDown;
                    break;
                default:
                    flipTransitionType = UIViewAnimationOptionTransitionFlipFromLeft;                    
                    break;
            }
            
            [UIView transitionFromView:oldView toView:newView duration:[self flipDuration]
                               options:flipTransitionType
                            completion:^(BOOL finished){

                            }];
        }
        else {
            NSLog(@"New View doesn't exist or is currently showing");
        }
    }
    else {
        [self addSubview:[[self views] objectAtIndex:viewIndex]];
    }
}

-(NSInteger)currentViewIndex {
    UIView *currentView = [[self subviews] objectAtIndex:0];
    if (currentView) {
        return [[self views] indexOfObject:currentView];
    }
    else {
        return -1;
    }
}

@end
