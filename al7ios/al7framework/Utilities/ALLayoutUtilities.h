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

#import <Foundation/Foundation.h>


@interface ALLayoutUtilities : NSObject {
    
}

+(void)spaceSubviewsEvenlyIn:(UIView *)targetView withDistance:(float)aDistance;
+(void)alignSubviewsLeftIn:(UIView *)targetView;
+(void)alignSubviewsLeftIn:(UIView *)targetView atXPosition:(CGFloat)xPos;
+(void)alignSubviewsRightIn:(UIView *)targetView;
+(void)alignSubviewsRightIn:(UIView *)targetView atXPosition:(CGFloat)xPos;
+(void)alignSubviewsCenterIn:(UIView *)targetView;
+(void)alignSubviewsCenterIn:(UIView *)targetView atXPosition:(CGFloat)xPos;
+(void)centerViewInSuperview:(UIView *)targetView;
+(void)moveView:(UIView *)targetView toPosition:(CGPoint)aPoint; 
+(CGRect)getMaximumBoundsInView:(UIView *)aView;
+(BOOL)doesDeviceSupportHighResolution;
+(void)setLayerInView:(UIView *)aView withCornerRadius:(CGFloat)aCornerRadius borderWidth:(CGFloat)aBorderWidth borderColor:(UIColor *)aBorderColor;
+(void)setLayerInView:(UIView *)aView withCornerRadius:(CGFloat)aCornerRadius;
+(void)applyRedBorderToView:(UIView *)aView;
+(CGFloat)degreesToRadians:(CGFloat)angle;
+(void)setShadowInView:(UIView *)aView withColor:(UIColor *)shadowColor radius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset opacity:(CGFloat)shadowOpacity;
+(CGSize)sizeProportionalToSize:(CGSize)originalSize withMaximumSpan:(CGFloat)maximumSpan;
+(void)bounceView:(UIView *)view withMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale duration:(NSTimeInterval)duration;
+(void)bounceView:(UIView *)view withMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale;
+(void)bounceView:(UIView *)view;

@end

#pragma mark - Categories;

@interface UIView (LayoutUtilities)

-(void)centerInSuperview;
-(void)moveToPosition:(CGPoint)newOrigin animated:(BOOL)animated duration:(NSTimeInterval)duration;
-(void)moveToPosition:(CGPoint)newOrigin animated:(BOOL)animated;
-(void)moveToPosition:(CGPoint)newOrigin;
-(CGRect)getMaximumBounds;

@end