//
//  DemoModalMatteController.m
//  al7ios
//
//  Created by Alexandre Leite on 6/15/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import "DemoModalMatteController.h"

@implementation DemoModalMatteController

@synthesize modalMatte = _modalMatte;
@synthesize gradientRadius = _gradientRadius;

#pragma mark - Initializers;

-(id)init {
    self = [super initWithHeaderText:@"Modal Matte"];
    if (self) {
        [self setGradientRadius:100.0];
    }
    return self;
}

#pragma mark - Base Overrides;

-(void)buildViewHierarchyInView:(UIView *)contentView {
    CGRect instructionsLabelFrame = [contentView bounds];
    instructionsLabelFrame.size.height -= 30.0;
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:instructionsLabelFrame];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [instructionsLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:13.0]];
    [instructionsLabel setTextColor:[UIColor whiteColor]];
    [instructionsLabel setShadowColor:[UIColor blackColor]];
    [instructionsLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [instructionsLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"The modal matte gives you a nice,\nsubtle spotlight effect.\n\nTap inside this rectangle to\nsee modal matte.\n\nTo dismiss the matte, just\ntap the screen again.\n\nUse the slider below to\nchange gradient radius."];
    [contentView addSubview:instructionsLabel];
    [ALLayoutUtilities setLayerInView:instructionsLabel withCornerRadius:0.0 borderWidth:1.0 borderColor:[UIColor whiteColor]];
    
    UISlider *gradientRadiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0, [contentView frame].size.height - 25.0, [contentView frame].size.width, 25.0)];
    [gradientRadiusSlider setMinimumValue:20.0];
    [gradientRadiusSlider setMaximumValue:250.0];
    [gradientRadiusSlider setValue:[self gradientRadius]];
    [gradientRadiusSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:gradientRadiusSlider];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScreenTap:)];
    [contentView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Action Targets;

-(void)onSliderValueChanged:(id)sender {
    [self setGradientRadius:[(UISlider *)sender value]];
}

-(void)onScreenTap:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint locationInView = [tapRecognizer locationInView:[self view]];
    
    [self setModalMatte:[[ALModalMatte alloc] initWithGradientCenter:locationInView gradientRadius:[self gradientRadius]]];
    [[self modalMatte] setAlpha:0.0];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:[self modalMatte]];
    [UIView animateWithDuration:0.3 animations:^{
        [[self modalMatte] setAlpha:1.0];
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *modalMatteTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onModalMatteTap:)];
        [modalMatteTapRecognizer setNumberOfTapsRequired:1];
        [[self modalMatte] addGestureRecognizer:modalMatteTapRecognizer];
    }];
}

-(void)onModalMatteTap:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [[self modalMatte] setAlpha:0.0];
    } completion:^(BOOL finished) {
        [[self modalMatte] removeFromSuperview];
        [self setModalMatte:nil];
    }];
}

@end
