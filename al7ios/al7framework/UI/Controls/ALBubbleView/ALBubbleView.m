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

#import "ALBubbleView.h"
#import "ALLayoutUtilities.h"
#import "ALDrawingUtilities.h"
#import "ALColorUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALBubbleView

@synthesize contentView, colorScheme, bubbleHandleOrientation, bubbleHandlePosition, cornerRadius, hasDropDownShadow;

#pragma mark - Initializers;

-(id)initWithContentView:(UIView *)aContentView 
             colorScheme:(ALBubbleViewColorScheme)aColorScheme 
 bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation 
    bubbleHandlePosition:(CGFloat)aBubbleHandlePosition 
            cornerRadius:(CGFloat)aCornerRadius 
          withDropShadow:(BOOL)withDropShadow {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    if (self) {
        //- set properties;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setContentView:aContentView];
        [self setColorScheme:aColorScheme];
        [self setBubbleHandleOrientation:aBubbleHandleOrientation];
        [self setBubbleHandlePosition:aBubbleHandlePosition];
        [self setCornerRadius:aCornerRadius];
        [self setHasDropDownShadow:withDropShadow];

        //- set frame;
        CGSize bubbleSize = [[self contentView] frame].size;
        bubbleSize.width += (2 * [self cornerRadius]) + 1.0;
        bubbleSize.height += (2 * [self cornerRadius]) + 1.0;
        if ([self bubbleHandleOrientation] == ALBubbleViewBubbleHandleOrientationLeft || [self bubbleHandleOrientation] == ALBubbleViewBubbleHandleOrientationRight) {
            bubbleSize.width += [self cornerRadius];
        }        
        if ([self bubbleHandleOrientation] == ALBubbleViewBubbleHandleOrientationBottom || [self bubbleHandleOrientation] == ALBubbleViewBubbleHandleOrientationTop) {
            bubbleSize.height += [self cornerRadius];
        }
        [self setFrame:CGRectMake([self frame].origin.x, [self frame].origin.y, bubbleSize.width, bubbleSize.height)];
        
        //- calculate content view positions;
        CGPoint contentViewOrigin;
        switch ([self bubbleHandleOrientation]) {
            case ALBubbleViewBubbleHandleOrientationTop:
                contentViewOrigin = CGPointMake([self cornerRadius], 2 * [self cornerRadius]);
                break;
            case ALBubbleViewBubbleHandleOrientationBottom:
                contentViewOrigin = CGPointMake([self cornerRadius], [self cornerRadius]);
                break;                
            case ALBubbleViewBubbleHandleOrientationLeft:
                contentViewOrigin = CGPointMake(2 * [self cornerRadius], [self cornerRadius]);
                break;                
            case ALBubbleViewBubbleHandleOrientationRight:
                contentViewOrigin = CGPointMake([self cornerRadius], [self cornerRadius]);
                break;                
            default:
                break;
        }
        [ALLayoutUtilities moveView:[self contentView] toPosition:contentViewOrigin];
        
        //- build view hierarchy;
        [self addSubview:[self contentView]];
        
        //- adjust layer shadow;
        if (hasDropDownShadow) {
            CALayer *layer = [self layer];
            layer.shadowOpacity = 0.5;
            layer.shadowOffset = CGSizeMake(2.0, 2.0);
            layer.shadowColor = [[UIColor blackColor] CGColor];
        }
    }
    return self;
}

-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation bubbleHandlePosition:(CGFloat)aBubbleHandlePosition cornerRadius:(CGFloat)aCornerRadius {
    return [self initWithContentView:aContentView colorScheme:aColorScheme bubbleHandleOrientation:aBubbleHandleOrientation bubbleHandlePosition:aBubbleHandlePosition cornerRadius:aCornerRadius withDropShadow:YES];
}

-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation bubbleHandlePosition:(CGFloat)aBubbleHandlePosition {
    return [self initWithContentView:aContentView colorScheme:aColorScheme bubbleHandleOrientation:aBubbleHandleOrientation bubbleHandlePosition:aBubbleHandlePosition cornerRadius:8.0];
}

-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation {
    CGFloat aBubbleHandlePosition;
    if (aBubbleHandleOrientation == ALBubbleViewBubbleHandleOrientationBottom || aBubbleHandleOrientation == ALBubbleViewBubbleHandleOrientationTop) {
        aBubbleHandlePosition = roundf(([aContentView frame].size.width + 16.0) / 2);
    }
    else {
        aBubbleHandlePosition = roundf(([aContentView frame].size.height + 16.0) / 2);        
    }
    return [self initWithContentView:aContentView colorScheme:aColorScheme bubbleHandleOrientation:aBubbleHandleOrientation bubbleHandlePosition:aBubbleHandlePosition];
}

-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme {
    return [self initWithContentView:aContentView colorScheme:aColorScheme bubbleHandleOrientation:ALBubbleViewBubbleHandleOrientationBottom];
}

-(id)initWithContentView:(UIView *)aContentView {
    return [self initWithContentView:aContentView colorScheme:ALBubbleViewColorSchemeLightGold];
}

#pragma mark - Drawing Methods;

- (void)drawRect:(CGRect)rect
{
    //- determine colors;
    UIColor *borderColor;
    UIColor *topColor;
    UIColor *bottomColor;
    
    switch ([self colorScheme]) {
        case ALBubbleViewColorSchemeLightBlue:
            borderColor = [ALColorUtilities rgbColorWithRed:0 green:102 blue:255 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:153 green:204 blue:255 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;
        case ALBubbleViewColorSchemeLightGold:
            borderColor = [ALColorUtilities rgbColorWithRed:255 green:204 blue:0 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:204 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;
        case ALBubbleViewColorSchemeLightGray:
            borderColor = [ALColorUtilities rgbColorWithRed:102 green:102 blue:102 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:204 green:204 blue:204 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;
        case ALBubbleViewColorSchemeLightGreen:
            borderColor = [ALColorUtilities rgbColorWithRed:0 green:102 blue:0 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:204 green:255 blue:204 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;
        case ALBubbleViewColorSchemeLightRed:
            borderColor = [ALColorUtilities rgbColorWithRed:204 green:0 blue:0 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:205 green:220 blue:220 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;            
        default:
            borderColor = [ALColorUtilities rgbColorWithRed:255 green:204 blue:0 alpha:1.0];
            topColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:204 alpha:1.0];
            bottomColor = [ALColorUtilities rgbColorWithRed:255 green:255 blue:255 alpha:1.0];
            break;
    }
    //- get context;
    CGContextRef context = UIGraphicsGetCurrentContext();    

    //- get bubble path;
    CGRect bubbleRect = [self frame];
    bubbleRect.origin.x = 1.0;
    bubbleRect.origin.y = 1.0;
    bubbleRect.size.width -= 2.0;
    bubbleRect.size.height -= 2.0;
    
    CGPathRef bubblePath = [ALDrawingUtilities newBubbleShapePathInRect:bubbleRect cornerRadius:[self cornerRadius] handleOrientation:[self bubbleHandleOrientation] handlePositon:[self bubbleHandlePosition]];        
    
    //- draw gradient and clip bubble;
    NSArray *colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gSteps[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, gSteps);

    CGColorSpaceRelease(colorSpace);
    CGPoint stPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextSaveGState(context);
    CGContextAddPath(context, bubblePath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, stPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);    
    
    //- stroke border;
    CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddPath(context, bubblePath);    
    CGContextStrokePath(context);
    CGPathRelease(bubblePath);
}


@end
