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

#import "ALTabBox.h"
#import "ALTabBoxHeaderBar.h"
#import "ALColorUtilities.h"
#import "ALDrawingUtilities.h"

@implementation ALTabBox

@synthesize currentView, contentSize;
@synthesize delegate = _delegate;

#pragma mark - Initializers;

-(id)initWithViewTitles:(NSArray *)someViewTitles andHeight:(CGFloat)aHeight {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 300.0, aHeight)];
    if (self) {
        //- set properties;
        [self setBackgroundColor:[UIColor clearColor]];
        
        //- declare fixed dimensions;
        margin = 8.0;
        headerHeight = 41.0;
        
        //- calculate dimensions;
        CGRect viewFrame = [self frame];
        viewFrame.origin.x = margin;
        viewFrame.origin.y = headerHeight + margin - 1.0;
        viewFrame.size.width -= 2.0 * margin;
        viewFrame.size.height -= (headerHeight + (2.0 * margin) + 1.0);
        
        [self setContentSize:viewFrame.size];
        
        //- create views;
        NSMutableArray *provViews = [NSMutableArray array];
        for (NSString *aTitle in someViewTitles) {
            ALTabBoxView *newView = [[ALTabBoxView alloc] initWithFrame:viewFrame
                                                               andTitle:aTitle];
            [provViews addObject:newView];
        }
        views = [[NSArray alloc] initWithArray:provViews];
        
        //- build view hierarchy;
        ALTabBoxHeaderBar *headerBar = [[ALTabBoxHeaderBar alloc] initWithTitles:someViewTitles
                                                                       andHeight:headerHeight];
        [headerBar setTargetBox:self];
        [self addSubview:headerBar];
        
        [self showViewWithIndex:0];
    }
    return self;
}

-(id)initWithViewTitles:(NSArray *)someViewTitles {
    return [self initWithViewTitles:someViewTitles andHeight:300.0];
}

#pragma mark - Drawing Methods;

-(void)drawRect:(CGRect)rect {
    //- calculate dimensions;
    CGFloat cornerRadius = 8.0;
    CGFloat borderY = headerHeight - 1.0;
    CGRect borderRect = CGRectMake(0.0, borderY, [self frame].size.width, [self frame].size.height - (headerHeight + 1.0));
    CGRect innerBorderRect = borderRect;
    innerBorderRect.origin.x = 1.0;
    innerBorderRect.origin.y += 1.0;
    innerBorderRect.size.width -= 2.0;
    innerBorderRect.size.height -= 2.0;
    CGFloat innerCornerRadius = cornerRadius - 1.0;
    
    //- get context and draw;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[ALColorUtilities rgbColorWithRed:51 green:102 blue:204 alpha:1.0] CGColor]);
    [ALDrawingUtilities addPathToContext:context
                          roundRectangle:borderRect
                        withCornerRadius:cornerRadius
                      roundTopLeftCorner:NO
                  andRoundTopRightCorner:NO
                andRoundBottomLeftCorner:YES
               andRoundBottomRightCorner:YES];
    
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, [[ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0] CGColor]);
    [ALDrawingUtilities addPathToContext:context
                          roundRectangle:innerBorderRect
                        withCornerRadius:innerCornerRadius
                      roundTopLeftCorner:NO
                  andRoundTopRightCorner:NO
                andRoundBottomLeftCorner:YES
               andRoundBottomRightCorner:YES];
    
    CGContextFillPath(context);
}

#pragma mark - Public Methods;

-(void)showViewWithIndex:(NSUInteger)anIndex {
    if (currentView) {
        NSUInteger currentViewIndex = [views indexOfObject:[self currentView]];
        [currentView removeFromSuperview];
        if (currentViewIndex != anIndex) {
            ALTabBoxView *viewToShow = [views objectAtIndex:anIndex];
            [self addSubview:viewToShow];
            [self setCurrentView:viewToShow];
        }
    }
    else {
        ALTabBoxView *viewToShow = [views objectAtIndex:anIndex];
        [self addSubview:viewToShow];
        [self setCurrentView:viewToShow];
    }
    
    if ([self delegate]) {
        if ([[self delegate] respondsToSelector:@selector(tabBox:switchedToViewAtIndex:)]) {
            [[self delegate] tabBox:self switchedToViewAtIndex:anIndex];
        }
    }
}

-(void)addSubview:(UIView *)aSubview toViewWithIndex:(NSUInteger)anIndex {
    UIView *targetView = [views objectAtIndex:anIndex];
    if (targetView) {
        [targetView addSubview:aSubview];
    }
}

@end