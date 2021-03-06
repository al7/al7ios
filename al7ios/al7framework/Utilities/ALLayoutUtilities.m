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

#import "ALLayoutUtilities.h"
#import "ALLayoutObjectWithOffset.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALLayoutUtilities

#pragma mark Moving and Spacing Operations

+(BOOL)doesDeviceSupportHighResolution {
    BOOL result = NO;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] > 1.0) {
            result = YES;
        }        
    }    
    return result;
}

+(void)spaceSubviewsEvenlyIn:(UIView *)targetView withDistance:(float)aDistance {
    if (targetView != nil) {
        UIView *lastView = nil;
        for (UIView *sView in [targetView subviews]) {
            if (lastView != nil) {
                CGFloat offsetBeforeCompensation = 0.0;
                CGFloat offsetAfterCompensation = 0.0;
                if ([lastView conformsToProtocol:@protocol(ALLayoutObjectWithOffset)]) {
                    id <ALLayoutObjectWithOffset> lastLayoutObject = (id)lastView;
                    offsetBeforeCompensation = [lastLayoutObject layoutOffsetBefore];
                    offsetAfterCompensation = [lastLayoutObject layoutOffsetAfter];
                }
               
                if (offsetBeforeCompensation > 0.0) {
                    CGRect lastViewFrame = [lastView frame];
                    lastViewFrame.origin.y -= offsetBeforeCompensation;
                    [lastView setFrame:lastViewFrame];
                }
                
                CGRect sFrame = [sView frame];
                sFrame.origin.y = lastView.frame.origin.y + lastView.frame.size.height + aDistance - offsetAfterCompensation;
                [sView setFrame:sFrame];
            }
            lastView = sView;
        }
    }
}

+(void)alignSubviewsLeftIn:(UIView *)targetView {
    [ALLayoutUtilities alignSubviewsLeftIn:targetView atXPosition:0.0];
}

+(void)alignSubviewsLeftIn:(UIView *)targetView atXPosition:(CGFloat)xPos {
    if (targetView != nil){
        for (UIView *subview in [targetView subviews]) {
            CGRect sFrame = [subview frame];
            sFrame.origin.x = xPos;
            [subview setFrame:sFrame];
        }
    }
}

+(void)alignSubviewsRightIn:(UIView *)targetView {
    if (targetView != nil) {
        CGFloat xPos = [targetView frame].size.width;
        [ALLayoutUtilities alignSubviewsRightIn:targetView atXPosition:xPos];
    }
}

+(void)alignSubviewsRightIn:(UIView *)targetView atXPosition:(CGFloat)xPos {
    if (targetView != nil) {
        for (UIView *subview in [targetView subviews]) {
            CGRect subviewFrame = [subview frame];
            subviewFrame.origin.x = xPos - subviewFrame.size.width;
        }
    }
}

+(void)alignSubviewsCenterIn:(UIView *)targetView {
    if (targetView != nil) {
        CGFloat xPos = [targetView frame].size.width / 2;
        [ALLayoutUtilities alignSubviewsCenterIn:targetView atXPosition:xPos];
    }
}

+(void)alignSubviewsCenterIn:(UIView *)targetView atXPosition:(CGFloat)xPos {
    if (targetView != nil) {
        for (UIView *subview in [targetView subviews]) {
            CGRect subviewFrame = [subview frame];
            subviewFrame.origin.x = roundf(xPos - (subviewFrame.size.width / 2));
            [subview setFrame:subviewFrame];
        }
    }    
}

+(void)centerViewInSuperview:(UIView *)targetView {
    if ([targetView superview]) {
        CGRect targetViewFrame = [targetView frame];
        CGRect superviewFrame = [[targetView superview] frame];
        targetViewFrame.origin.x = roundf((superviewFrame.size.width / 2) - (targetViewFrame.size.width / 2));
        targetViewFrame.origin.y = roundf((superviewFrame.size.height / 2) - (targetViewFrame.size.height / 2));        
        [targetView setFrame:targetViewFrame];
    }
}

+(void)moveView:(UIView *)targetView toPosition:(CGPoint)aPoint {
    CGRect viewFrame = [targetView frame];
    viewFrame.origin.x = aPoint.x;
    viewFrame.origin.y = aPoint.y;
    [targetView setFrame:viewFrame];
}

+(CGRect)getMaximumBoundsInView:(UIView *)aView {
    CGRect result = [aView bounds];
    for (UIView *subview in [aView subviews]) {
        CGRect svFrame = [subview frame];
        if (svFrame.origin.x < result.origin.x) {
            result.origin.x = svFrame.origin.x;
        }
        if (svFrame.origin.y < result.origin.y) {
            result.origin.y = svFrame.origin.y;
        }
        if (svFrame.origin.x + svFrame.size.width > result.size.width){
            result.size.width = svFrame.origin.x + svFrame.size.width;
        }
        if (svFrame.origin.y + svFrame.size.height > result.size.height){
            result.size.height = svFrame.origin.y + svFrame.size.height;
        }
    }
    return result;
}

+(void)setLayerInView:(UIView *)aView withCornerRadius:(CGFloat)aCornerRadius borderWidth:(CGFloat)aBorderWidth borderColor:(UIColor *)aBorderColor {
    if (aView) {
        CALayer *layer = [aView layer];        
        [layer setCornerRadius:aCornerRadius];
        [layer setBorderWidth:aBorderWidth];
        [layer setBorderColor:[aBorderColor CGColor]];
    }
}

+(void)setLayerInView:(UIView *)aView withCornerRadius:(CGFloat)aCornerRadius {
    [ALLayoutUtilities setLayerInView:aView withCornerRadius:aCornerRadius borderWidth:1.0 borderColor:[UIColor blackColor]];
}

+(void)applyRedBorderToView:(UIView *)aView {
    [ALLayoutUtilities setLayerInView:aView withCornerRadius:0.0 borderWidth:1.0 borderColor:[UIColor redColor]];
}

+(CGFloat)degreesToRadians:(CGFloat)angle {
    CGFloat pi = 3.14159265358979323846264338327950288;
    return (angle / 180.0 * pi);
}

+(void)setShadowInView:(UIView *)aView withColor:(UIColor *)shadowColor radius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset opacity:(CGFloat)shadowOpacity {
    if (aView) {
        CALayer *layer = [aView layer];
        [layer setShadowColor:[shadowColor CGColor]];
        [layer setShadowRadius:shadowRadius];
        [layer setShadowOffset:shadowOffset];
        [layer setShadowOpacity:shadowOpacity];
    }
}

+(CGSize)sizeProportionalToSize:(CGSize)originalSize withMaximumSpan:(CGFloat)maximumSpan {
    CGSize result = originalSize;
    CGFloat proportionPct = 1.0;
    if (originalSize.width > originalSize.height) {
        proportionPct = maximumSpan / originalSize.height;
    }
    else {
        proportionPct = maximumSpan / originalSize.width;
    }
    
    result.width = originalSize.width * proportionPct;
    result.height = originalSize.height * proportionPct;
    
    return result;
}

+(void)bounceView:(UIView *)view withMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale duration:(NSTimeInterval)duration {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [bounceAnimation setDelegate:self];
    NSMutableArray *bounceValues = [NSMutableArray array];
    [bounceValues addObject:[NSNumber numberWithFloat:1.0]];
    [bounceValues addObject:[NSNumber numberWithFloat:minScale]];
    [bounceValues addObject:[NSNumber numberWithFloat:maxScale]];
    [bounceValues addObject:[NSNumber numberWithFloat:1.0]];
    [bounceAnimation setValues:bounceValues];
    [bounceAnimation setDuration:duration];
    [[view layer] addAnimation:bounceAnimation forKey:@"bounceAnimation"];
}

+(void)bounceView:(UIView *)view withMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale {
    [ALLayoutUtilities bounceView:view withMinScale:minScale maxScale:maxScale duration:0.3];
}

+(void)bounceView:(UIView *)view {
    [ALLayoutUtilities bounceView:view withMinScale:0.8 maxScale:1.2];
}

@end

#pragma mark - Categories;

@implementation UIView (LayoutUtilities)

-(void)centerInSuperview {
    [ALLayoutUtilities centerViewInSuperview:self];
}

-(void)moveToPosition:(CGPoint)newOrigin animated:(BOOL)animated duration:(NSTimeInterval)duration {
    void (^moveAnimation)(void) = ^{
        [ALLayoutUtilities moveView:self toPosition:newOrigin];
    };
    
    if (animated) {
        [UIView animateWithDuration:duration animations:moveAnimation];
    }
    else {
        moveAnimation();
    }
}

-(void)moveToPosition:(CGPoint)newOrigin animated:(BOOL)animated {
    [self moveToPosition:newOrigin animated:animated duration:0.3];
}

-(void)moveToPosition:(CGPoint)newOrigin {
    [self moveToPosition:newOrigin animated:NO];
}

-(CGRect)getMaximumBounds {
    return [ALLayoutUtilities getMaximumBoundsInView:self];
}

@end