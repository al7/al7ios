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

#import "ALTooltip.h"
#import "ALLayoutUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALTooltip

@synthesize bubbleContentView, tooltipView, badgeType, colorScheme, bubble, modalMatte;

#pragma mark - Initializers;

-(id)initWithBubbleContent:(UIView *)aBubbleContentView tooltipView:(UIView *)aTooltipView colorScheme:(ALBubbleViewColorScheme)aColorScheme badgeType:(ALTooltipBadgeType)aBadgeType {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, [aTooltipView frame].size.width, [aTooltipView frame].size.height)];
    if (self) {
        //- set properties;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBubbleContentView:aBubbleContentView];
        [self setTooltipView:aTooltipView];
        [self setSpotlightRadius:150.0];
        [self setMatteOpacity:0.7];
        [self setColorScheme:aColorScheme];
        [self setBadgeType:aBadgeType];
        
        //- build view hierarchy;
        [[self tooltipView] setUserInteractionEnabled:NO];
        [self addSubview:[self tooltipView]];
        
        if ([self badgeType] != ALTooltipBadgeTypeNone) {
            //- place badge;
            NSString *badgeImageNameSuffix;
            switch ([self badgeType]) {
                case ALTooltipBadgeTypeAlert:
                    badgeImageNameSuffix = @"Alert";
                    break;
                case ALTooltipBadgeTypeError:
                    badgeImageNameSuffix = @"Error";
                    break;
                case ALTooltipBadgeTypeInfo:
                    badgeImageNameSuffix = @"Info";
                    break;
                case ALTooltipBadgeTypeSuccess:
                    badgeImageNameSuffix = @"Success";
                    break;
                default:
                    badgeImageNameSuffix = [NSString string];
                    break;
            }
            NSString *badgeImageName = [NSString stringWithFormat:@"img_ALTooltip_badge_%@.png", badgeImageNameSuffix];
            UIImage *badgeImage = [UIImage imageNamed:badgeImageName];
            UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:badgeImage];
            [badgeImageView setUserInteractionEnabled:NO];
            
            CGRect badgeImageViewFrame = [badgeImageView frame];
            badgeImageViewFrame.origin.x = [[self tooltipView] frame].size.width - roundf(0.8 * badgeImageViewFrame.size.width);
            badgeImageViewFrame.origin.y = [[self tooltipView] frame].size.height - roundf(0.8 * badgeImageViewFrame.size.height);
            [badgeImageView setFrame:badgeImageViewFrame];
            [self addSubview:badgeImageView];
        }
    }
    return self;
}

-(id)initWithBubbleContent:(UIView *)aBubbleContentView tooltipView:(UIView *)aTooltipView colorScheme:(ALBubbleViewColorScheme)aColorScheme {
    return [self initWithBubbleContent:aBubbleContentView tooltipView:aTooltipView colorScheme:aColorScheme badgeType:ALTooltipBadgeTypeNone];
    
}

-(id)initWithBubbleContent:(UIView *)aBubbleContentView tooltipView:(UIView *)aTooltipView {
    return [self initWithBubbleContent:aBubbleContentView tooltipView:aTooltipView colorScheme:ALBubbleViewColorSchemeLightGold];
}

#pragma mark - Touch Events;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showBubble];
}

#pragma mark - Bubble Operations;

-(void)showBubble {
    if ([self bubble] == nil) {
        //- get tooltip absolute position and center position;
        CGRect tooltipAbsRect = [[self tooltipView] convertRect:[[self tooltipView] frame] toView:nil]; 
        CGFloat tooltipCenterX = tooltipAbsRect.origin.x + roundf([tooltipView frame].size.width / 2);        
        CGFloat tooltipCenterY = tooltipAbsRect.origin.y + roundf([tooltipView frame].size.height / 2);  
        
        //- calculate bubble x position and handle position;
        CGSize bubbleSize = CGSizeMake(0.0, 0.0);
        bubbleSize.width = [[self bubbleContentView] frame].size.width + 16.0;
        bubbleSize.height = [[self bubbleContentView] frame].size.height + 24.0;
        
        CGFloat bubbleX = roundf(([[UIScreen mainScreen] applicationFrame].size.width / 2.0) - (bubbleSize.width / 2.0));
        CGFloat bubbleHandlePosition = tooltipCenterX - bubbleX;
        
        //- calculate bubble handle orientation and bubble Y;
        ALBubbleViewBubbleHandleOrientation bubbleOrientation = ALBubbleViewBubbleHandleOrientationBottom;        
        CGFloat bubbleY = 0.0;
        
        CGFloat bubbleHeightDiff = tooltipCenterY - bubbleSize.height;
        
        if (bubbleHeightDiff >= 30.0) {
            bubbleY = bubbleHeightDiff;
            bubbleOrientation = ALBubbleViewBubbleHandleOrientationBottom;
        }
        else {
            bubbleY = tooltipCenterY;
            bubbleOrientation = ALBubbleViewBubbleHandleOrientationTop;
        }
        
        //- create and place bubble and modal matte;
        ALModalMatte *newModalMatte = [[ALModalMatte alloc] initWithGradientCenter:CGPointMake(tooltipCenterX, tooltipCenterY)
                                                                    gradientRadius:[self spotlightRadius]];
        [newModalMatte setAlpha:0.0];
        [newModalMatte setMatteOpacity:[self matteOpacity]];
        [[self window] addSubview:newModalMatte];
        [self setModalMatte:newModalMatte];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onModalMatteTouchesBegan) name:ALModalMatteTouchesBeganNotification object:[self modalMatte]];        
        
        ALBubbleView *newBubble = [[ALBubbleView alloc] initWithContentView:[self bubbleContentView] colorScheme:[self colorScheme] bubbleHandleOrientation:bubbleOrientation bubbleHandlePosition:bubbleHandlePosition];
        [newBubble setUserInteractionEnabled:NO];
        [ALLayoutUtilities moveView:newBubble toPosition:CGPointMake(bubbleX, bubbleY)];
        [newBubble setAlpha:0.0];
        [[self window] addSubview:newBubble];
        [self setBubble:newBubble];                            

        //- fade bubble and modal matte in;
        [[NSNotificationCenter defaultCenter] postNotificationName:ALTooltipWillShowBubbleNotification object:self];
        
        CAKeyframeAnimation *bubbleBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        NSMutableArray *bubbleBounceValues = [NSMutableArray array];
        [bubbleBounceValues addObject:[NSNumber numberWithFloat:0.5]];
        [bubbleBounceValues addObject:[NSNumber numberWithFloat:1.2]];
        [bubbleBounceValues addObject:[NSNumber numberWithFloat:0.8]];        
        [bubbleBounceValues addObject:[NSNumber numberWithFloat:1.0]]; 
        [bubbleBounceAnimation setValues:bubbleBounceValues];
        [bubbleBounceAnimation setDuration:0.28];
        [[newBubble layer] addAnimation:bubbleBounceAnimation forKey:@"bounceAnimation"];
        
        [UIView animateWithDuration:0.3 animations:^{
            [newBubble setAlpha:1.0];
            [newModalMatte setAlpha:1.0];
        } completion:^(BOOL finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:ALTooltipDidShowBubbleNotification object:self];
        }];
    }    
}

-(void)hideBubble {
    if ([self bubble]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALModalMatteTouchesBeganNotification object:[self modalMatte]];                    
        [[NSNotificationCenter defaultCenter] postNotificationName:ALTooltipWillHideBubbleNotification object:self];        
        [UIView animateWithDuration:0.2 animations:^{
            [[self modalMatte] setAlpha:0.0];
            [[self bubble] setAlpha:0.0];
        }completion:^(BOOL finished){
            [[self bubble] removeFromSuperview];
            [[self modalMatte] removeFromSuperview];            
            [self setBubble:nil];
            [self setModalMatte:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:ALTooltipDidHideBubbleNotification object:self];            
        }];
    }
}

#pragma mark - Action Targets;

-(void)onModalMatteTouchesBegan {
    [self hideBubble];
}

@end

NSString *const ALTooltipWillShowBubbleNotification = @"ALTooltip_WILL_SHOW_BUBBLE";
NSString *const ALTooltipDidShowBubbleNotification = @"ALTooltip_DID_SHOW_BUBBLE";
NSString *const ALTooltipWillHideBubbleNotification = @"ALTooltip_WILL_HIDE_BUBBLE";
NSString *const ALTooltipDidHideBubbleNotification = @"ALTooltip_DID_HIDE_BUBBLE";
