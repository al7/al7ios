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

#import "ALRefreshScrollView.h"

@implementation ALRefreshScrollView

@synthesize header, refreshDelegate, errorText, readyForRefreshText, normalStateText;

-(id)initWithFrame:(CGRect)frame normalStateText:(NSString *)aNormalStateText readyToRefreshText:(NSString *)aReadyToRefreshText errorText:(NSString *)anErrorText {
    self = [super initWithFrame:frame];
    if (self) {
        //- set BOOL's;
        readyToRefresh = NO;
        
        //- set initial properties;
        [self setBackgroundColor:[UIColor darkGrayColor]];
        [self setContentSize:CGSizeMake([self frame].size.width, [self frame].size.height + 0.5)];
        [self setBounces:YES];
        [self setDelegate:self];
        [self setNormalStateText:aNormalStateText];
        [self setReadyForRefreshText:aReadyToRefreshText];
        [self setErrorText:anErrorText];
        
        //- build refresh header;
        CGRect headerFrame = CGRectMake(0.0, 0.0, [self frame].size.width, 40.0);
        headerFrame.origin.y = -headerFrame.size.height;
        
        ALRefreshScrollViewHeader *newHeader = [[ALRefreshScrollViewHeader alloc] initWithFrame:headerFrame 
                                                                                normalStateText:[self normalStateText]
                                                                             readyToRefreshText:[self readyForRefreshText]];
        [self setHeader:newHeader];
        [self addSubview:[self header]];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame
               normalStateText:@"Pull Down to Refresh"
            readyToRefreshText:@"Release to Refresh"
                     errorText:@"Unable to Refresh Content"];
}

#pragma mark - Delegate methods;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView contentOffset].y < -([[self header] frame].size.height)) {
        [[self header] setState:ALRefreshScrollViewHeaderStateReadyToRefresh];
        readyToRefresh = YES;
    }
    else {
        [[self header] setState:ALRefreshScrollViewHeaderStateNormal];
        readyToRefresh = NO;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (readyToRefresh) {
        [self refresh];
    }
}

#pragma mark - Public Methods;

-(void)refresh {
    if (refreshDelegate) {
        if ([refreshDelegate respondsToSelector:@selector(refreshViewWillBeginRefresh:)]) {
            [refreshDelegate refreshViewWillBeginRefresh:self];
        }
    }
    [self clearViewHierarchy];
    progressMatte = [[ALRefreshScrollViewProgressMatte alloc] initWithFrame:[self frame]];
    [progressMatte setAlpha:0.0];
    [[self superview] addSubview:progressMatte];
    [UIView animateWithDuration:0.4 animations:^{
        [progressMatte setAlpha:1.0]; 
    } completion:^(BOOL finished) {
        if (refreshDelegate) {
            if ([refreshDelegate respondsToSelector:@selector(refreshViewDidBeginRefresh:)]) {
                [refreshDelegate refreshViewDidBeginRefresh:self];
            }
        }
    }];
}

-(void)cancelRefresh {
    [self finishRefreshWithSuccess:NO];
}

-(void)finishRefreshWithSuccess:(BOOL)success {
    if (refreshDelegate) {
        if ([refreshDelegate respondsToSelector:@selector(refreshViewWillEndRefresh:)]) {
            [refreshDelegate refreshViewWillEndRefresh:self];
        }
    }
    if (success) {
        if (refreshDelegate) {
            [refreshDelegate buildViewHierarchyInRefreshScrollView:self];
        }
    }
    else {
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        [errorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0]];
        [errorLabel setBackgroundColor:[UIColor clearColor]];
        [errorLabel setTextColor:[UIColor whiteColor]];
        [errorLabel setTextAlignment:NSTextAlignmentCenter];
        [errorLabel setText:[self errorText]];
        [self addSubview:errorLabel];
    }
    if (progressMatte) {
        [UIView animateWithDuration:0.3 animations:^{
            [progressMatte setAlpha:0.0];
        } completion:^(BOOL finished){
            [progressMatte removeFromSuperview];
            progressMatte = nil;
            if (refreshDelegate) {
                if ([refreshDelegate respondsToSelector:@selector(refreshViewDidEndRefresh:)]) {
                    [refreshDelegate refreshViewDidEndRefresh:self];
                }
            }            
        }];
    }
}

-(void)finishRefresh {
    [self finishRefreshWithSuccess:YES];
}

-(void)clearViewHierarchy {
    for (UIView *subview in [self subviews]) {
        if (subview != [self header]) {
            [subview removeFromSuperview];
        }
    }
}

@end
