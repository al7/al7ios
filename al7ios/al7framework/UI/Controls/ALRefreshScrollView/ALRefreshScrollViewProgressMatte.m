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

#import "ALRefreshScrollViewProgressMatte.h"
#import "ALLayoutUtilities.h"

@implementation ALRefreshScrollViewProgressMatte

@synthesize title;

- (id)initWithFrame:(CGRect)frame title:(NSString *)aTitle {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        [self setTitle:aTitle];
        
        UIView *progressContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 80.0)];
        [progressContainerView setBackgroundColor:[UIColor blackColor]];
        [ALLayoutUtilities setLayerInView:progressContainerView withCornerRadius:8.0];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGPoint activityIndicatorOrigin = CGPointMake(0.0, 0.0);
        activityIndicatorOrigin.x = roundf(([progressContainerView frame].size.width / 2) - ([activityIndicator frame].size.width / 2));
        activityIndicatorOrigin.y = 20.0;
        [ALLayoutUtilities moveView:activityIndicator toPosition:activityIndicatorOrigin];
        [progressContainerView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, [progressContainerView bounds].size.width, 20.0)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[self title]];
        [progressContainerView addSubview:label];
        
        CGPoint progressContainerViewOrigin = [progressContainerView frame].origin;
        progressContainerViewOrigin.x = roundf(([self frame].size.width / 2) - ([progressContainerView frame].size.width / 2));
        progressContainerViewOrigin.y = roundf(([self frame].size.height / 2) - ([progressContainerView frame].size.height / 2));        
        [ALLayoutUtilities moveView:progressContainerView toPosition:progressContainerViewOrigin];
        [self addSubview:progressContainerView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame title:@"One Moment Please..."];
}

@end
