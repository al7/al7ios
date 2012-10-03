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

#import "TestbedController.h"
#import "TestbedSettingsController.h"
#import "ALColorUtilities.h"
#import "ALLayoutUtilities.h"

@implementation TestbedController

@synthesize lightColor, darkColor;

-(id)init {
    self = [super init];
    if (self) {
        [self setLightColor:[ALColorUtilities rgbColorWithRed:240 green:240 blue:240 alpha:1.0]];
        [self setDarkColor:[ALColorUtilities rgbColorWithRed:0 green:51 blue:153 alpha:1.0]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIView *controllerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [controllerView setBackgroundColor:[self darkColor]];
    [self setView:controllerView];
    
    UIFont *titleLabelFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 235.0, 35.0)];
    [titleLabel setFont:titleLabelFont];
    [titleLabel setTextColor:[self lightColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"Testbed"];
    [[self view] addSubview:titleLabel];
    
    bgSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240.0, 4.0, 0.0, 0.0)];
    [bgSwitch setOn:YES];
    [bgSwitch addTarget:self action:@selector(onBgSwitchToggle:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:bgSwitch];
    
    testbedView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 35.0, [controllerView frame].size.width, [controllerView frame].size.height - 117.0)];

    CGFloat testbedViewContentWidth, testbedViewContentHeight;
    testbedViewContentWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"Testbed_contentWidthValue"];
    testbedViewContentHeight = [[NSUserDefaults standardUserDefaults] floatForKey:@"Testbed_contentHeightValue"];    
    if(testbedViewContentWidth < [testbedView contentSize].width) {
        testbedViewContentWidth = [testbedView contentSize].width; 
        [[NSUserDefaults standardUserDefaults] setFloat:testbedViewContentWidth forKey:@"Testbed_contentWidthValue"];
    }
    if(testbedViewContentHeight < [testbedView contentSize].height) {
        testbedViewContentHeight = [testbedView contentSize].height; 
        [[NSUserDefaults standardUserDefaults] setFloat:testbedViewContentHeight forKey:@"Testbed_contentHeightValue"];
    }
    [testbedView setContentSize:CGSizeMake(testbedViewContentWidth, testbedViewContentHeight)];
    
    [self buildViewHierarchyIn:testbedView];
    [[self view] addSubview:testbedView];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil]];
    [segmentedControl setFrame:CGRectMake(5.0, [testbedView frame].size.height + [testbedView frame].origin.y, 310, 32.0)];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:segmentedControl];
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dismissButton setFrame:CGRectMake(5.0, [controllerView frame].size.height - 45.0, 280.0, 40.0)];
    [dismissButton setTitle:@"Dismiss Testbed" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(onDismissButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:dismissButton];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [settingsButton addTarget:self action:@selector(onSettingsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [ALLayoutUtilities moveView:settingsButton toPosition:CGPointMake([[self view] frame].size.width - 25.0, [[self view] frame].size.height - 35.0)];
    [[self view] addSubview:settingsButton];
    
    [self setView:controllerView];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overridable Methods;

-(void)buildViewHierarchyIn:(UIView *)aView {
    
}

-(void)doStuffWithIndex:(NSInteger)index {
    //-- USE THIS METHOD FOR TESTING. IT IS TIED UP TO SEGMENTED CONTROL IN THE BOTTOM OF THE SCREEN.

}

#pragma mark - Class Methods;

-(void)toggleBackgroundColor {
    if ([bgSwitch isOn]) {
        [[self view] setBackgroundColor:[self darkColor]];
        [titleLabel setTextColor:[self lightColor]];
    }
    else {
        [[self view] setBackgroundColor:[self lightColor]];
        [titleLabel setTextColor:[self darkColor]];
    }
}

-(void)presentSettings {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:[NSNumber numberWithFloat:[testbedView contentSize].width] forKey:@"contentWidth"];
    [arguments setObject:[NSNumber numberWithFloat:[testbedView contentSize].height] forKey:@"contentHeight"];
    [arguments setObject:[NSNumber numberWithFloat:[testbedView frame].size.width] forKey:@"testbedViewWidth"];
    [arguments setObject:[NSNumber numberWithFloat:[testbedView frame].size.height] forKey:@"testbedViewHeight"];
    
    testbedSettingsController = [[TestbedSettingsController alloc] initWithArguments:arguments];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTestbedSettingsControllerValuesSaved:) name:TestbedSettingsControllerValuesSavedNotification object:testbedSettingsController];
    
    [self presentViewController:testbedSettingsController animated:YES completion:nil];
}

#pragma mark - Notification Responders;

-(void)onTestbedSettingsControllerValuesSaved:(id)sender {
    [testbedView setContentSize:[testbedSettingsController getAdjustedContentSize]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TestbedSettingsControllerValuesSavedNotification object:testbedSettingsController];
}

#pragma mark - Action Targets;

-(void)onBgSwitchToggle:(id)sender {
    [self toggleBackgroundColor];
}

-(void)onDismissButtonTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onSegmentedControlValueChanged:(id)sender {
    [self doStuffWithIndex:[(UISegmentedControl *)sender selectedSegmentIndex]];
}

-(void)onSettingsButtonTouch:(id)sender {
    [self presentSettings];
}

#pragma mark - Temp Action Targets -- REMOVE AFTER TESTING!!!

#pragma mark - Temp Methods -- REMOVE AFTER TESTING!!!;

@end
