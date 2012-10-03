//
//  DemoTooltipController.m
//  al7ios
//
//  Created by Alexandre Leite on 6/15/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import "DemoTooltipController.h"

@implementation DemoTooltipController

@synthesize tooltip = _tooltip;

#pragma mark - Initializers;

-(id)init {
    self = [super initWithHeaderText:@"Tooltip"];
    if (self) {
        
    }
    return self;
}

#pragma mark - Base Overrides;

-(void)buildViewHierarchyInView:(UIView *)contentView {
    UIImageView *tooltipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_tooltip_demo_iphone.png"]];
    
    //-- This is how you create a basic text content view;
    UIFont *contentFont = [UIFont fontWithName:@"TrebuchetMS" size:12.0];
    NSString *tooltipContent = @"Surprise! I'm a tooltip. I can hold important help info without obstructing the UI!";
    CGSize contentSize = [tooltipContent sizeWithFont:contentFont constrainedToSize:CGSizeMake(150.0, 5000.0) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, contentSize.width, contentSize.height)];
    [contentLabel setFont:contentFont];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setNumberOfLines:0];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setTextColor:[UIColor blackColor]];
    [contentLabel setText:tooltipContent];
    
    [self setTooltip:[[ALTooltip alloc] initWithBubbleContent:contentLabel tooltipView:tooltipImageView]];
    [contentView addSubview:[self tooltip]];
    [ALLayoutUtilities centerViewInSuperview:[self tooltip]];
    
    UISegmentedControl *tooltipColorControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Gold", @"Red", @"Green", @"Blue", @"Gray", nil]];
    [tooltipColorControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [tooltipColorControl setSelectedSegmentIndex:0];
    [tooltipColorControl setTintColor:[UIColor rgbColorWithRed:0 green:51 blue:153 alpha:1.0]];
    [tooltipColorControl setFrame:CGRectMake(5.0, 340.0, 300.0, 25.0)];
    [tooltipColorControl addTarget:self action:@selector(onColorSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:tooltipColorControl];   
}

#pragma mark - Action Targets;

-(void)onColorSegmentChange:(id)sender {
    NSInteger selectedIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            [[self tooltip] setColorScheme:ALBubbleViewColorSchemeLightGold];
            break;
        case 1:
            [[self tooltip] setColorScheme:ALBubbleViewColorSchemeLightRed];
            break;
        case 2:
            [[self tooltip] setColorScheme:ALBubbleViewColorSchemeLightGreen];
            break;
        case 3:
            [[self tooltip] setColorScheme:ALBubbleViewColorSchemeLightBlue];
            break;
        case 4:
            [[self tooltip] setColorScheme:ALBubbleViewColorSchemeLightGray];
            break;
        default:
            break;
    }
}

@end
