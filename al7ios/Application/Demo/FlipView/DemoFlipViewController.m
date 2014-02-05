//
//  DemoFlipViewController.m
//  al7ios
//
//  Created by Alexandre Leite on 6/6/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import "DemoFlipViewController.h"

@implementation DemoFlipViewController

@synthesize flipView = _flipView;

#pragma mark - Initializers;

-(id)init {
    flipI = 1;
    return [super initWithHeaderText:@"Flip View"];
}

#pragma mark - Base Overrides;

-(void)buildViewHierarchyInView:(UIView *)contentView {
    BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    
    UIImageView *demoImageView01 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_flipview_demo_01.png"]];
    UIImageView *demoImageView02 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_flipview_demo_02.png"]];
    NSArray *flipViews = [NSArray arrayWithObjects:demoImageView01, demoImageView02, nil];
    
    [self setFlipView:[[ALFlipView alloc] initWithFrame:CGRectMake(55.0, 20.0, 200.0, 200.0) andViews:flipViews]];
    
    [contentView addSubview:[self flipView]];
    
    NSMutableArray *flipOptions = [NSMutableArray array];
    [flipOptions addObject:@"From Left"];
    [flipOptions addObject:@"From Right"];
    [flipOptions addObject:@"Curl Up"];
    [flipOptions addObject:@"Curl Down"];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:flipOptions];
    [segmentedControl setTintColor:[UIColor rgbColorWithRed:0 green:51 blue:153 alpha:1.0]];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segmentedControl setFrame:CGRectMake(5.0, [contentView frame].size.height - 80.0, 300.0, 30.0)];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(onSelectedSegmentIndexChange:) forControlEvents:UIControlEventValueChanged];
    if (isIos7) {
        [segmentedControl setTintColor:[UIColor whiteColor]];
    }
    
    [contentView addSubview:segmentedControl];
    
    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [flipButton setFrame:CGRectMake(5.0, [contentView frame].size.height - 40.0, 300.0, 40.0)];
    [flipButton setTitle:@"Flip!" forState:UIControlStateNormal];
    if (isIos7) {
        [flipButton setBackgroundColor:[UIColor whiteColor]];
        [flipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [flipButton addTarget:self action:@selector(onFlipButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:flipButton];
}

#pragma mark - Action Targets;

-(void)onFlipButtonTouch:(id)sender {
    NSInteger nextIndex = flipI % [[[self flipView] views] count];
    [[self flipView] flipToViewAtIndex:nextIndex];
    flipI++;
}

-(void)onSelectedSegmentIndexChange:(id)sender {
    NSInteger value = [(UISegmentedControl *)sender selectedSegmentIndex];
    switch (value) {
        case 0:
            [[self flipView] setTransitionType:ALFlipViewTransitionTypeFlipFromLeft];
            break;
        case 1:
            [[self flipView] setTransitionType:ALFlipViewTransitionTypeFlipFromRight];
            break;
        case 2:
            [[self flipView] setTransitionType:ALFlipViewTransitionTypeCurlUp];
            break;
        case 3:
            [[self flipView] setTransitionType:ALFlipViewTransitionTypeCurlDown];
            break;
        default:
            break;
    }
}

@end
