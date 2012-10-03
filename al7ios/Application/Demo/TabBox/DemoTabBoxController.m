//
//  DemoTabBoxController.m
//  al7ios
//
//  Created by Alexandre Leite on 10/3/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import "DemoTabBoxController.h"

@implementation DemoTabBoxController

@synthesize tabBox = _tabBox;

#pragma mark - Initializers;

-(id)init {
    self = [super initWithHeaderText:@"Tab Box"];
    if (self) {
        
    }
    return self;
}

#pragma mark - Base Overrides;

-(void)buildViewHierarchyInView:(UIView *)contentView {
    [self setTabBox:[[ALTabBox alloc] initWithViewTitles:[NSArray arrayWithObjects:@"Red", @"Green", @"Blue", nil]
                                               andHeight:320.0]];
    [contentView addSubview:[self tabBox]];
    [ALLayoutUtilities centerViewInSuperview:[self tabBox]];
    
    CGRect tabBoxContentFrame = CGRectZero;
    tabBoxContentFrame.size.width = [[self tabBox] contentSize].width;
    tabBoxContentFrame.size.height = [[self tabBox] contentSize].height;
    
    UIView *redView = [[UIView alloc] initWithFrame:tabBoxContentFrame];
    [redView setBackgroundColor:[UIColor redColor]];
    [[self tabBox] addSubview:redView toViewWithIndex:0];

    UIView *greenView = [[UIView alloc] initWithFrame:tabBoxContentFrame];
    [greenView setBackgroundColor:[UIColor greenColor]];
    [[self tabBox] addSubview:greenView toViewWithIndex:1];
    
    UIView *blueView = [[UIView alloc] initWithFrame:tabBoxContentFrame];
    [blueView setBackgroundColor:[UIColor blueColor]];
    [[self tabBox] addSubview:blueView toViewWithIndex:2];
}

@end
