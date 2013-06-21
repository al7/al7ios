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

#import "ALModalMatte.h"

@implementation ALModalMatte

@synthesize gradientCenter, gradientRadius, targetView;

#pragma mark - Initializers;

- (id)initWithFrame:(CGRect)frame
{
    return nil;
}

-(id)initWithGradientCenter:(CGPoint)aGradientCenter gradientRadius:(CGFloat)aGradientRadius {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        //- set properties;
        [self setMatteOpacity:0.7];
        [self setGradientCenter:aGradientCenter];
        [self setGradientRadius:aGradientRadius];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)initWithGradientCenter:(CGPoint)aGradientCenter {
    return [self initWithGradientCenter:aGradientCenter gradientRadius:120.0];
}

#pragma mark - Drawing Methods;

-(void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    CGFloat colors[] = {
        0.0, 0.0, 0.0, 0.0,//- black 0%;
        0.0, 0.0, 0.0, [self matteOpacity] //- black 70%;
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
    
    CGPoint startPoint = [self gradientCenter];
    CGFloat startRadius = 0.0;
    CGPoint endPoint = [self gradientCenter];
    CGFloat endRadius = [self gradientRadius];
    
    CGContextDrawRadialGradient(context, gradient, startPoint, startRadius, endPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - Touch Methods;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:ALModalMatteTouchesBeganNotification object:self];    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:ALModalMatteTouchesEndedNotification object:self];        
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:ALModalMatteTouchesMovedNotification object:self];        
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:ALModalMatteTouchesCancelledNotification object:self];        
}

#pragma mark - Public Methods;

-(void)dismissModalMatteAnimated:(BOOL)animate {
    void (^completeDismissal)(void) = ^{
        [self removeFromSuperview];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setAlpha:0.0];
        }
        completion:^(BOOL finished){
            completeDismissal();
        }];
    }
    else {
        completeDismissal();
    }
}

-(void)dismissModalMatte {
    [self dismissModalMatteAnimated:NO];
}

@end

#pragma mark - Notification Constants;

NSString *const ALModalMatteTouchesBeganNotification = @"ALModalMatte_TOUCHES_BEGAN";
NSString *const ALModalMatteTouchesEndedNotification = @"ALModalMatte_TOUCHES_ENDED";
NSString *const ALModalMatteTouchesMovedNotification = @"ALModalMatte_TOUCHES_MOVED";
NSString *const ALModalMatteTouchesCancelledNotification = @"ALModalMatte_TOUCHES_CANCELLED";
