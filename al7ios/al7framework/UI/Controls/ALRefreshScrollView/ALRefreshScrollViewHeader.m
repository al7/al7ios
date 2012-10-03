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

#import "ALRefreshScrollViewHeader.h"
#import "ALUtilities.h"

@implementation ALRefreshScrollViewHeader

@synthesize normalStateText, readyToRefreshText;

- (id)initWithFrame:(CGRect)frame normalStateText:(NSString *)aNormalStateText readyToRefreshText:(NSString *)aReadyToRefreshText {
    self = [super initWithFrame:frame];
    if (self) {
        //- set initial properties;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setNormalStateText:aNormalStateText];
        [self setReadyToRefreshText:aReadyToRefreshText];
        
        _state = ALRefreshScrollViewHeaderStateNormal;
        
        //- set control elements;
        UIImage *arrowImage = [UIImage imageNamed:@"img_ALRefreshScrollView_Arrow.png"];
        arrowView = [[UIImageView alloc] initWithImage:arrowImage];
        [ALLayoutUtilities moveView:arrowView toPosition:CGPointMake(10.0, roundf(([self frame].size.height / 2) - ([arrowView frame].size.height / 2)))];
        [self addSubview:arrowView];
        
        UIFont *statusLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        statusLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        [statusLabel setFont:statusLabelFont];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [statusLabel setTextColor:[UIColor whiteColor]];
        [statusLabel setTextAlignment:NSTextAlignmentCenter];
        [statusLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [statusLabel setText:[self normalStateText]];
        [self addSubview:statusLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame normalStateText:@"Pull Down to Refresh" readyToRefreshText:@"Release to Refresh"];
}

#pragma mark - Face Methods;

-(void)updateFace {
    BOOL arrowHidden;
    int arrowAngle;
    NSString *statusLabelText;
    
    switch ([self state]) {
        case ALRefreshScrollViewHeaderStateNormal:
            arrowHidden = NO;
            arrowAngle = 0;
            statusLabelText = [self normalStateText];
            break;
        case ALRefreshScrollViewHeaderStateReadyToRefresh:
            arrowHidden = NO;
            arrowAngle = 180;
            statusLabelText = [self readyToRefreshText];
            break;
        default:
            break;
    }
    
    [arrowView setHidden:arrowHidden];
    [statusLabel setText:statusLabelText];
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat arrowRad = [ALLayoutUtilities degreesToRadians:arrowAngle];
        CGAffineTransform transform = CGAffineTransformMakeRotation(arrowRad);
        [arrowView setTransform:transform];
    }];
}

#pragma mark - Custom Properties;

-(ALRefreshScrollViewHeaderState)state {
    return _state;
}

-(void)setState:(ALRefreshScrollViewHeaderState)state {
    if (state != [self state]) {
        _state = state;
        [self updateFace];
    }
}

@end
