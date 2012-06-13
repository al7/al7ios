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

#import "ALTabBoxHeaderButton.h"
#import "ALColorUtilities.h"
#import "ALLayoutUtilities.h"

@implementation ALTabBoxHeaderButton

@synthesize buttonTitle, active, button, buttonIndex;

#pragma mark - Initializers;

-(id)initWithButtonTitle:(NSString *)aButtonTitle buttonWidth:(CGFloat)aButtonWidth active:(BOOL)isActive {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, aButtonWidth, 41.0)];
    if (self) {
        //- set properties;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setButtonTitle:aButtonTitle];
        [self setActive:isActive];
        
        //- draw images;
        [self drawImages];
        
        //- build view hierarchy;
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tabButton setFrame:CGRectMake(0.0, 0.0, [self frame].size.width, [self frame].size.height)];
        [self setButton:tabButton];
        [self addSubview:[self button]];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, [self frame].size.width - 16.0, [self frame].size.height)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setNumberOfLines:0];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setUserInteractionEnabled:NO];
        [label setText:[self buttonTitle]];
        [self addSubview:label];

        //- update view;
        [self updateView];
    }
    return self;
}

-(id)initWithButtonTitle:(NSString *)aButtonTitle buttonWidth:(CGFloat)aButtonWidth {
    return [self initWithButtonTitle:aButtonTitle buttonWidth:aButtonWidth active:NO];
}

#pragma mark - Public Methods;

-(void)activate {
    if ([self active] == NO) {
        [self setActive:YES];        
        [self updateView];
    }
}

-(void)deactivate {
    if ([self active]) {
        [self setActive:NO];        
        [self updateView];
    }
}

#pragma mark - View State Methods;

-(void)updateView {
    if ([self active]) {
        [[self button] setImage:activeImage forState:UIControlStateNormal];
        [label setTextColor:[ALColorUtilities rgbColorWithRed:0 green:51 blue:153 alpha:1.0]];
    }
    else {
        [[self button] setImage:inactiveImage forState:UIControlStateNormal];
        [label setTextColor:[UIColor whiteColor]];
    }
}

#pragma mark - Drawing Methods;

-(void)drawImages {
    //- calculate device resolution;
    NSString *resolutionString;
    CGFloat scale;
    
    if ([ALLayoutUtilities doesDeviceSupportHighResolution]) { 
        scale = 2.0; 
        resolutionString = [NSString stringWithString:@"@2x"];
    }
    else {
        resolutionString = [NSString string];
        scale = 1.0;
    }
    CGRect faceFrame = CGRectMake(0.0, 0.0, [self frame].size.width * scale, [self frame].size.height * scale);
    
    //- load and calculate image parts;
    UIImage *inactiveImageLeftCorner = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Inactive_LeftCorner%@.png", resolutionString]];
    UIImage *inactiveImageRightCorner = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Inactive_RightCorner%@.png", resolutionString]];
    UIImage *inactiveImageBg = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Inactive_Bg%@.png", resolutionString]];    
    
    UIImage *activeImageLeftCorner = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Active_LeftCorner%@.png", resolutionString]];
    UIImage *activeImageRightCorner = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Active_RightCorner%@.png", resolutionString]];
    UIImage *activeImageBg = [UIImage imageNamed:[NSString stringWithFormat:@"img_ALTabBoxHeaderButton_Active_Bg%@.png", resolutionString]];    
    
    CGRect leftCornerFrame = CGRectMake(0.0, 0.0, [inactiveImageLeftCorner size].width, [inactiveImageLeftCorner size].height);
    CGRect rightCornerFrame = CGRectMake(faceFrame.size.width - [inactiveImageRightCorner size].width, 0.0, [inactiveImageRightCorner size].width, [inactiveImageRightCorner size].height);
    CGRect bgFrame = CGRectMake(leftCornerFrame.origin.x + leftCornerFrame.size.width, 0.0, faceFrame.size.width - leftCornerFrame.size.width - rightCornerFrame.size.width, faceFrame.size.height);
    
    //- create context and draw inactive image;
    UIGraphicsBeginImageContext(faceFrame.size);
    [inactiveImageLeftCorner drawAtPoint:leftCornerFrame.origin];
    [inactiveImageRightCorner drawAtPoint:rightCornerFrame.origin];
    [inactiveImageBg drawInRect:bgFrame];
    inactiveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //- create context and draw active image;
    UIGraphicsBeginImageContext(faceFrame.size);
    [activeImageLeftCorner drawAtPoint:leftCornerFrame.origin];
    [activeImageRightCorner drawAtPoint:rightCornerFrame.origin];
    [activeImageBg drawInRect:bgFrame];
    activeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Memory Management;


@end
