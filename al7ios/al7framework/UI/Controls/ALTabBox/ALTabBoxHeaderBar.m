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

#import "ALTabBoxHeaderBar.h"
#import "ALLayoutUtilities.h"

@implementation ALTabBoxHeaderBar

@synthesize targetBox, pressedButton;

#pragma mark - Initializers;

-(id)initWithTitles:(NSArray *)someTitles andHeight:(CGFloat)aHeight {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 300.0, aHeight)];
    if (self) {
        //- set properties;
        [self setBackgroundColor:[UIColor clearColor]];
        
        //- calculate dimensions;
        
        int numberOfButtons = [someTitles count];
        CGFloat buttonGapWidth = 1.0;
        int numberOfGaps = numberOfButtons - 1;
        CGFloat widthToSplit = [self frame].size.width - (numberOfGaps * buttonGapWidth);
        CGFloat standardButtonWidth = roundf(widthToSplit / numberOfButtons);
        CGFloat lastItemCompensation = [self frame].size.width - ((standardButtonWidth * numberOfButtons) + (buttonGapWidth * numberOfGaps));
        
        //- add buttons;
        int buttonIndex = 0;
        UIView *previousButton = nil;
        for (NSString *title in someTitles) {
            CGFloat currentButtonWidth = standardButtonWidth;
            if (buttonIndex == (numberOfButtons - 1)) {
                currentButtonWidth += lastItemCompensation;
            }
            ALTabBoxHeaderButton *newButton = [[ALTabBoxHeaderButton alloc] initWithButtonTitle:title buttonWidth:currentButtonWidth];
            if (previousButton) {
                [ALLayoutUtilities moveView:newButton toPosition:CGPointMake([previousButton frame].origin.x + [previousButton frame].size.width + buttonGapWidth, [previousButton frame].origin.y)];
            }
            else {
                [ALLayoutUtilities moveView:newButton toPosition:CGPointMake(0.0, 0.0)];
            }
            [newButton setButtonIndex:buttonIndex];
            [[newButton button] addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:newButton];
            
            //- prepare for next;
            previousButton = newButton;
            buttonIndex++;
        }
        [self selectButtonAtIndex:0];
    }
    return self;
}

#pragma mark - Action Targets;

-(void)onButtonTouch:(id)sender {
    ALTabBoxHeaderButton *senderSuperview = (ALTabBoxHeaderButton *)[(UIButton *)sender superview];
    [self selectButtonAtIndex:[senderSuperview buttonIndex]];
    [[self targetBox] showViewWithIndex:[senderSuperview buttonIndex]];
}

#pragma mark - Public Methods;

-(void)selectButtonAtIndex:(NSUInteger)anIndex {
    if (anIndex < [[self subviews] count]) {
        if ([self pressedButton]) {
            [[self pressedButton] deactivate];
            [[self pressedButton] setUserInteractionEnabled:YES];
        }
        ALTabBoxHeaderButton *newPressedButton = [[self subviews] objectAtIndex:anIndex];
        [self setPressedButton:newPressedButton];
        [[self pressedButton] activate];        
        [[self pressedButton] setUserInteractionEnabled:NO];
    }    
}

#pragma mark - Memory Management;


@end
