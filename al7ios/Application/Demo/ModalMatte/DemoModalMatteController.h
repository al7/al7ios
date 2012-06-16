//
//  DemoModalMatteController.h
//  al7ios
//
//  Created by Alexandre Leite on 6/15/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import "ALModalMatte.h"

@interface DemoModalMatteController : DemoBaseViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) ALModalMatte *modalMatte;
@property (assign, nonatomic) CGFloat gradientRadius;

#pragma mark - Action Targets;

-(void)onSliderValueChanged:(id)sender;
-(void)onModalMatteTap:(id)sender;
-(void)onScreenTap:(id)sender;

@end
