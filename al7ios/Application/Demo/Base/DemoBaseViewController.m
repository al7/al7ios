//
//  DemoBaseViewController.m
//  al7ios
//
//  Created by Alexandre Leite on 6/6/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import "DemoBaseViewController.h"

@implementation DemoBaseViewController

@synthesize headerText = _headerText;

#pragma mark - Initializers;

-(id)initWithHeaderText:(NSString *)headerText {
    self = [super init];
    if (self) {
        [self setHeaderText:headerText];
    }
    return self;
}

-(id)init {
    return [self initWithHeaderText:@"No Title"];
}

#pragma mark - View Lifecycle;

-(void)loadView {
    BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    
    [self setView:[[UIView alloc] initWithFrame:(isIos7) ? [[UIScreen mainScreen] bounds] : [[UIScreen mainScreen] applicationFrame]]];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Demo_Bg.png"]];
    [[self view] addSubview:backgroundView];
    [backgroundView centerInSuperview];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, (isIos7) ? 20.0 : 0.0, 310.0, 30.0)];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setShadowColor:[UIColor blackColor]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 2.0)];
    [headerLabel setText:[self headerText]];
    [[self view] addSubview:headerLabel];
    
    CGRect contentViewFrame = CGRectZero;
    CGFloat heightCompensation = (isIos7) ? 110.0 : 90.0;
    contentViewFrame.origin.x = 5.0;
    contentViewFrame.origin.y = [headerLabel frame].origin.y + [headerLabel frame].size.height;
    contentViewFrame.size.width = 310.0;
    contentViewFrame.size.height = [[self view] frame].size.height - heightCompensation;
    
    UIView *contentView = [[UIView alloc] initWithFrame:contentViewFrame];
    [self buildViewHierarchyInView:contentView];
    [[self view] addSubview:contentView];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(onOkTouch:) forControlEvents:UIControlEventTouchUpInside];

    CGRect okButtonFrame = CGRectMake(0.0, 0.0, 300.0, 40.0);
    okButtonFrame.origin.x = 10.0;
    okButtonFrame.origin.y = [[self view] frame].size.height - (okButtonFrame.size.height + 10.0);
    [okButton setFrame:okButtonFrame];
    [[self view] addSubview:okButton];
    
    if (isIos7) {
        [okButton setBackgroundColor:[UIColor rgbColorWithRed:0 green:204 blue:0 alpha:1.0]];
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - Overridable Methods;

-(void)buildViewHierarchyInView:(UIView *)contentView {
    
}

#pragma mark - Action Targets;

-(void)onOkTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end