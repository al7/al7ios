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

#import <UIKit/UIKit.h>

typedef enum {
    ALBubbleViewColorSchemeLightGold,
    ALBubbleViewColorSchemeLightGray,
    ALBubbleViewColorSchemeLightBlue,
    ALBubbleViewColorSchemeLightGreen,
    ALBubbleViewColorSchemeLightRed,
    ALBubbleViewColorSchemeModernGray
} ALBubbleViewColorScheme;

typedef enum {
    ALBubbleViewBubbleHandleOrientationTop,
    ALBubbleViewBubbleHandleOrientationBottom,
    ALBubbleViewBubbleHandleOrientationLeft,
    ALBubbleViewBubbleHandleOrientationRight,
} ALBubbleViewBubbleHandleOrientation;

@interface ALBubbleView : UIView {

}

@property (nonatomic, unsafe_unretained) UIView *contentView;
@property (nonatomic, assign) ALBubbleViewColorScheme colorScheme;
@property (nonatomic, assign) ALBubbleViewBubbleHandleOrientation bubbleHandleOrientation;
@property (nonatomic, assign) BOOL hasDropDownShadow;
@property (nonatomic, assign) CGFloat cornerRadius, bubbleHandlePosition;

#pragma mark - Initializers;

-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation bubbleHandlePosition:(CGFloat)aBubbleHandlePosition cornerRadius:(CGFloat)aCornerRadius withDropShadow:(BOOL)withDropShadow;
-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation bubbleHandlePosition:(CGFloat)aBubbleHandlePosition cornerRadius:(CGFloat)aCornerRadius;
-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation bubbleHandlePosition:(CGFloat)aBubbleHandlePosition;
-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme bubbleHandleOrientation:(ALBubbleViewBubbleHandleOrientation)aBubbleHandleOrientation;
-(id)initWithContentView:(UIView *)aContentView colorScheme:(ALBubbleViewColorScheme)aColorScheme;
-(id)initWithContentView:(UIView *)aContentView;

@end
