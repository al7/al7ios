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

#import "ALImageUtilities.h"

@implementation ALImageUtilities

+(UIImage *)getGradientRectangleImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    UIImage *result;
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColorRef, endColorRef;

    startColorRef = [startColor CGColor];
    endColorRef = [endColor CGColor];
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColorRef, (__bridge id)endColorRef, nil];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gSteps[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, gSteps);
    CGColorSpaceRelease(colorSpace);
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    CGPoint stPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, stPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);    
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)cropImage:(UIImage *)sourceImage withRectangle:(CGRect)cropRect largestSpan:(CGFloat)largestSpan {
    //-- Declare variables;
    CGFloat cropScale = 1.0;
    CGSize outputImageSize = CGSizeZero;
    
    //-- Calculate new image size;
    if (cropRect.size.width > cropRect.size.height) {
        cropScale = largestSpan / cropRect.size.width;
    }
    else {
        cropScale = largestSpan / cropRect.size.height;
    }
    outputImageSize.width = cropRect.size.width * cropScale;
    outputImageSize.height = cropRect.size.height * cropScale;
    
    //-- draw image;
    UIGraphicsBeginImageContextWithOptions(outputImageSize, NO, 1.0);
    CGContextRef outputImageContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(outputImageContext);
    CGContextTranslateCTM(outputImageContext, 0.0, largestSpan);
    CGContextScaleCTM(outputImageContext, 1.0, -1.0);
    
    CGImageRef sourceImageRef = [sourceImage CGImage];
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
    CGContextDrawImage(outputImageContext, CGRectMake(0.0, 0.0, outputImageSize.width, outputImageSize.height), croppedImageRef);
    CGImageRelease(croppedImageRef);
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(outputImageContext);
    UIGraphicsEndImageContext();
    return outputImage;
}

+(UIImage *)cropImage:(UIImage *)sourceImage withRectangle:(CGRect)cropRect {
    CGFloat largestSpan = ([sourceImage size].width > [sourceImage size].height) ? [sourceImage size].height : [sourceImage size].width;
    return [ALImageUtilities cropImage:sourceImage
                            withRectangle:cropRect
                              largestSpan:largestSpan];
}

@end