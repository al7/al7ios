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

#import "ALDrawingUtilities.h"

@implementation ALDrawingUtilities

#pragma mark Fill and Gradient Methods;

+(void)drawLinearGradientIn:(CGContextRef)context withColors:(NSArray *)colors andLocations:(NSArray *)locations {
    //    // Drawing code
    //    NSLog(@"-- draw rect");
    //    NSArray *colors = [self getGradientColors];
    //    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat gSteps[] = {0.0, 0.48, 0.5, 1.0};
    //    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, gSteps);
    //    
    //    CGPoint stPoint = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMinY([self bounds]));
    //    CGPoint endPoint = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMaxY([self bounds]));
    //    
    //    CGContextSaveGState(context);
    //    CGContextAddRect(context, [self bounds]);
    //    CGContextClip(context);
    //    CGContextDrawLinearGradient(context, gradient, stPoint, endPoint, 0);
    //    CGContextRestoreGState(context);
    
}

#pragma mark Drawing Path Methods;

+(void)addPathToContext:(CGContextRef)context roundRectangle:(CGRect)rectangle withCornerRadius:(CGFloat)radius {
    [ALDrawingUtilities addPathToContext:context roundRectangle:rectangle withCornerRadius:radius roundTopLeftCorner:YES andRoundTopRightCorner:YES andRoundBottomLeftCorner:YES andRoundBottomRightCorner:YES];
}

+(void)addPathToContext:(CGContextRef)context roundRectangle:(CGRect)rectangle withCornerRadius:(CGFloat)radius roundTopLeftCorner:(BOOL)rtl andRoundTopRightCorner:(BOOL)rtr andRoundBottomLeftCorner:(BOOL)rbl andRoundBottomRightCorner:(BOOL)rbr {
    
    CGFloat rWidth = rectangle.size.width;
    CGFloat rHeight = rectangle.size.height;
    CGFloat rMinX = rectangle.origin.x;
    CGFloat rMinY = rectangle.origin.y;
    CGFloat rMaxX = rMinX + rWidth;
    CGFloat rMaxY = rMinY + rHeight;
    CGFloat rMinRadX = rMinX + radius;
    CGFloat rMaxRadX = rMaxX - radius;
    CGFloat rMinRadY = rMinY + radius;
    CGFloat rMaxRadY = rMaxY - radius;

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rMinRadX, rMinY);
    CGContextAddLineToPoint(context, rMaxRadX, rMinY);
    
    if(rtr){
        CGContextAddArcToPoint(context, rMaxX, rMinY, rMaxX, rMinRadY, radius);
    }
    else{
        CGContextAddLineToPoint(context, rMaxX, rMinY);
        CGContextAddLineToPoint(context, rMaxX, rMinRadY);
    }
    
    CGContextAddLineToPoint(context, rMaxX, rMaxRadY);
    
    if (rbr) {
        CGContextAddArcToPoint(context, rMaxX, rMaxY, rMaxRadX, rMaxY, radius);
    }
    else {
        CGContextAddLineToPoint(context, rMaxX, rMaxY);
        CGContextAddLineToPoint(context, rMaxRadX, rMaxY);        
    }

    CGContextAddLineToPoint(context, rMinRadX, rMaxY);
    
    if (rbl) {
        CGContextAddArcToPoint(context, rMinX, rMaxY, rMinX, rMaxRadY, radius);
    }
    else {
        CGContextAddLineToPoint(context, rMinX, rMaxRadY);
        CGContextAddLineToPoint(context, rMinX, rMaxRadY);        
    }
    
    CGContextAddLineToPoint(context, rMinX, rMinRadY);
    
    if (rtl) {
        CGContextAddArcToPoint(context, rMinX, rMinY, rMinRadX, rMinY, radius);
    }
    else {
        CGContextAddLineToPoint(context, rMinX, rMinY);
        CGContextAddLineToPoint(context, rMinRadX, rMinY);        
    }
    CGContextClosePath(context);
}

+(CGPathRef)newBubbleShapePathWithSize:(CGSize)bubbleSize cornerRadius:(CGFloat)cornerRadius handleOrientation:(ALBubbleViewBubbleHandleOrientation)handleOrientation handlePositon:(CGFloat)handlePosition {
    return [ALDrawingUtilities newBubbleShapePathInRect:CGRectMake(0.0, 0.0, bubbleSize.width, bubbleSize.height) cornerRadius:cornerRadius handleOrientation:handleOrientation handlePositon:handlePosition];
}

+(CGPathRef)newBubbleShapePathInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius handleOrientation:(ALBubbleViewBubbleHandleOrientation)handleOrientation handlePositon:(CGFloat)handlePosition {
    CGMutablePathRef path = CGPathCreateMutable();
    
    //- reference vars;
    CGPoint bubbleMinPoint;
    CGPoint bubbleMaxPoint;
    CGFloat handlePointA;
    CGFloat handlePointB;
    CGFloat handleHalfLength = 0.75 * cornerRadius;
    
    //- determine handle points;
    
    if (handlePosition < (1.5 * cornerRadius)) {
        handlePosition = 1.5 * cornerRadius;
    }
    switch (handleOrientation) {
        case ALBubbleViewBubbleHandleOrientationTop:
            bubbleMinPoint = CGPointMake(rect.origin.x, rect.origin.y + cornerRadius);
            bubbleMaxPoint = CGPointMake(rect.size.width, rect.size.height);
            handlePointA = handlePosition - handleHalfLength;
            handlePointB = handlePosition + handleHalfLength;
            break;
        case ALBubbleViewBubbleHandleOrientationBottom:
            bubbleMinPoint = CGPointMake(rect.origin.x, rect.origin.y);
            bubbleMaxPoint = CGPointMake(rect.size.width, rect.size.height - cornerRadius);
            handlePointA = handlePosition + handleHalfLength;
            handlePointB = handlePosition - handleHalfLength;
            break;
        case ALBubbleViewBubbleHandleOrientationLeft:
            bubbleMinPoint = CGPointMake(rect.origin.x + cornerRadius, rect.origin.y);
            bubbleMaxPoint = CGPointMake(rect.size.width, rect.size.height);
            handlePointA = handlePosition + handleHalfLength;
            handlePointB = handlePosition - handleHalfLength;
            break;
        case ALBubbleViewBubbleHandleOrientationRight:
            bubbleMinPoint = CGPointMake(rect.origin.x, rect.origin.y);
            bubbleMaxPoint = CGPointMake(rect.size.width - cornerRadius, rect.size.height);
            handlePointA = handlePosition - handleHalfLength;
            handlePointB = handlePosition + handleHalfLength;
            break;            
        default:
            break;
    }
    
    //- add geometry to path;
    CGPathMoveToPoint(path, NULL, bubbleMinPoint.x + cornerRadius, bubbleMinPoint.y);
    if (handleOrientation == ALBubbleViewBubbleHandleOrientationTop) {
        CGPathAddLineToPoint(path, NULL, handlePointA, bubbleMinPoint.y);
        CGPathAddLineToPoint(path, NULL, handlePointA + handleHalfLength, bubbleMinPoint.y - cornerRadius);
        CGPathAddLineToPoint(path, NULL, handlePointB, bubbleMinPoint.y);
    }
    CGPathAddLineToPoint(path, NULL, bubbleMaxPoint.x - cornerRadius, bubbleMinPoint.y);
    CGPathAddArcToPoint(path, NULL, bubbleMaxPoint.x, bubbleMinPoint.y, bubbleMaxPoint.x, bubbleMinPoint.y + cornerRadius, cornerRadius);
    if (handleOrientation == ALBubbleViewBubbleHandleOrientationRight) {
        CGPathAddLineToPoint(path, NULL, bubbleMaxPoint.x, handlePointA);
        CGPathAddLineToPoint(path, NULL, bubbleMaxPoint.x + cornerRadius, handlePointA + handleHalfLength);
        CGPathAddLineToPoint(path, NULL, bubbleMaxPoint.x, handlePointB);
    }
    CGPathAddLineToPoint(path, NULL, bubbleMaxPoint.x, bubbleMaxPoint.y - cornerRadius);
    CGPathAddArcToPoint(path, NULL, bubbleMaxPoint.x, bubbleMaxPoint.y, bubbleMaxPoint.x - cornerRadius, bubbleMaxPoint.y, cornerRadius);
    if (handleOrientation == ALBubbleViewBubbleHandleOrientationBottom) {
        CGPathAddLineToPoint(path, NULL, handlePointA, bubbleMaxPoint.y);
        CGPathAddLineToPoint(path, NULL, handlePointA - handleHalfLength, bubbleMaxPoint.y + cornerRadius);
        CGPathAddLineToPoint(path, NULL, handlePointB, bubbleMaxPoint.y);
    }
    CGPathAddLineToPoint(path, NULL, bubbleMinPoint.x + cornerRadius, bubbleMaxPoint.y);
    CGPathAddArcToPoint(path, NULL, bubbleMinPoint.x, bubbleMaxPoint.y, bubbleMinPoint.x, bubbleMaxPoint.y - cornerRadius, cornerRadius);
    if (handleOrientation == ALBubbleViewBubbleHandleOrientationLeft) {
        CGPathAddLineToPoint(path, NULL, bubbleMinPoint.x, handlePointA);
        CGPathAddLineToPoint(path, NULL, bubbleMinPoint.x - cornerRadius, handlePointA - handleHalfLength);
        CGPathAddLineToPoint(path, NULL, bubbleMinPoint.x, handlePointB);
    }
    CGPathAddLineToPoint(path, NULL, bubbleMinPoint.x, bubbleMinPoint.y + cornerRadius);
    CGPathAddArcToPoint(path, NULL, bubbleMinPoint.x, bubbleMinPoint.y, bubbleMinPoint.x + cornerRadius, bubbleMinPoint.y, cornerRadius);
    CGPathCloseSubpath(path);
    return path;
}

@end
