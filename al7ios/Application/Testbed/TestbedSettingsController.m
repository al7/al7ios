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

#import "TestbedSettingsController.h"
#import "ALColorUtilities.h"

@implementation TestbedSettingsController

@synthesize contentSize, testbedViewSize;

-(id)init {
    return [self initWithArguments:nil];
}

-(id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        //-- set properties with arguments;    
        CGSize argContentSize, argTestbedViewSize;

        CGFloat argContentWidth = [(NSNumber *)[arguments objectForKey:@"contentWidth"] floatValue];
        CGFloat argContentHeight = [(NSNumber *)[arguments objectForKey:@"contentHeight"] floatValue];        
        argContentSize = CGSizeMake(argContentWidth, argContentHeight);
        
        CGFloat argTestbedViewWidth = [(NSNumber *)[arguments objectForKey:@"testbedViewWidth"] floatValue];
        CGFloat argTestbedViewHeight = [(NSNumber *)[arguments objectForKey:@"testbedViewHeight"] floatValue];        
        argTestbedViewSize = CGSizeMake(argTestbedViewWidth, argTestbedViewHeight);
        
        [self setContentSize:argContentSize];
        [self setTestbedViewSize:argTestbedViewSize];
        
        //-- set modal parameters;
        [self setModalPresentationStyle:UIModalPresentationFullScreen];
        [self setModalTransitionStyle:UIModalTransitionStylePartialCurl];
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    CGRect settingsViewFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *settingsView = [[UIView alloc] initWithFrame:settingsViewFrame];    
    UIImage *backgroundImage = [UIImage imageNamed:@"img_testbedSettings_bg.jpg"];
    [settingsView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    [self setView:settingsView];
    
    CGFloat contentWidthSliderInitialValue = [self contentSize].width - [self testbedViewSize].width; 
    CGFloat contentHeightSliderInitialValue = [self contentSize].height - [self testbedViewSize].height;
    
    UIFont *headerLabelFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0];
    UIFont *labelFont = [UIFont fontWithName:@"TrebuchetMS" size:13.0];
    UIColor *labelColor = [UIColor whiteColor];

    CGFloat labelY = 320.0;
    
    UILabel *testbedViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, labelY, 310.0, 24.0)];
    [testbedViewHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [testbedViewHeaderLabel setFont:headerLabelFont];
    [testbedViewHeaderLabel setTextAlignment:NSTextAlignmentLeft];
    [testbedViewHeaderLabel setTextColor:labelColor];
    [testbedViewHeaderLabel setText:@"Testbed View Scrolling Settings"];
    [[self view] addSubview:testbedViewHeaderLabel];
    
    labelY += 30.0;
    
    UILabel *contentWidthLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, labelY, 100.0, 23.0)];
    [contentWidthLabel setFont:labelFont];
    [contentWidthLabel setBackgroundColor:[UIColor clearColor]];
    [contentWidthLabel setTextAlignment:NSTextAlignmentRight];
    [contentWidthLabel setTextColor:labelColor];
    [contentWidthLabel setText:@"Content Width:"];
    [[self view] addSubview:contentWidthLabel];
    
    contentWidthSlider = [[UISlider alloc] initWithFrame:CGRectMake(110.0, labelY, 150.0, 23.0)];
    [contentWidthSlider setMinimumValue:0.0];
    [contentWidthSlider setMaximumValue:500.0];
    [contentWidthSlider setValue:contentWidthSliderInitialValue];
    [contentWidthSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:contentWidthSlider];
    
    contentWidthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, labelY, 55.0, 23.0)];
    [contentWidthValueLabel setFont:labelFont];
    [contentWidthValueLabel setBackgroundColor:[UIColor clearColor]];    
    [contentWidthValueLabel setTextAlignment:NSTextAlignmentLeft];
    [contentWidthValueLabel setTextColor:labelColor];
    [contentWidthValueLabel setText:@"--"];
    [[self view] addSubview:contentWidthValueLabel];
    
    labelY += 30.0;
    
    UILabel *contentHeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, labelY, 100.0, 23.0)];
    [contentHeightLabel setFont:labelFont];
    [contentHeightLabel setBackgroundColor:[UIColor clearColor]];    
    [contentHeightLabel setTextAlignment:NSTextAlignmentRight];
    [contentHeightLabel setTextColor:labelColor];
    [contentHeightLabel setText:@"Content Height:"];
    [[self view] addSubview:contentHeightLabel];
    
    contentHeightSlider = [[UISlider alloc] initWithFrame:CGRectMake(110.0, labelY, 150.0, 23.0)];
    [contentHeightSlider setMinimumValue:0.0];
    [contentHeightSlider setMaximumValue:500.0];
    [contentHeightSlider setValue:contentHeightSliderInitialValue];
    [contentHeightSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:contentHeightSlider];
    
    contentHeightValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, labelY, 55.0, 23.0)];
    [contentHeightValueLabel setFont:labelFont];
    [contentHeightValueLabel setBackgroundColor:[UIColor clearColor]];        
    [contentHeightValueLabel setTextAlignment:NSTextAlignmentLeft];
    [contentHeightValueLabel setTextColor:labelColor];
    [contentHeightValueLabel setText:@"--"];
    [[self view] addSubview:contentHeightValueLabel];    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton addTarget:self action:@selector(onOkButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"Save Changes" forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(5.0, [[self view] frame].size.height - 35.0, 310.0, 30.0)];
    [[self view] addSubview:okButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat contentWidthSliderValue = [self contentSize].width - [self testbedViewSize].width;
    CGFloat contentHeightSliderValue = [self contentSize].height - [self testbedViewSize].height;
    
    [contentWidthSlider setValue:contentWidthSliderValue];
    [contentHeightSlider setValue:contentHeightSliderValue];
    
    [self updateSliderValues];
}

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

#pragma mark - Helper Methods;

-(void)updateSliderValues {
    contentWidthValue = [self testbedViewSize].width + [contentWidthSlider value];
    contentHeightValue = [self testbedViewSize].height + [contentHeightSlider value];    
    
    NSString *contentWidthValueString, *contentHeightValueString;
    if ([contentWidthSlider value] > 0) {
        contentWidthValueString = [NSString stringWithFormat:@"%0.0f", contentWidthValue];
    }
    else {
        contentWidthValueString = @"no scr.";
    }
    if ([contentHeightSlider value] > 0) {
        contentHeightValueString = [NSString stringWithFormat:@"%0.0f", contentHeightValue];
    }
    else {
        contentHeightValueString = @"no scr.";
    }
    
    [contentWidthValueLabel setText:contentWidthValueString];
    [contentHeightValueLabel setText:contentHeightValueString];
}

-(CGSize)getAdjustedContentSize {
    return CGSizeMake(contentWidthValue, contentHeightValue);
}

-(void)saveValues {
    [[NSUserDefaults standardUserDefaults] setFloat:contentWidthValue forKey:@"Testbed_contentWidthValue"];
    [[NSUserDefaults standardUserDefaults] setFloat:contentHeightValue forKey:@"Testbed_contentHeightValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:TestbedSettingsControllerValuesSavedNotification object:self];
}

#pragma mark - Action Targets;

-(void)onOkButtonTouch:(id)sender {
    [self saveValues];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onSliderValueChange:(id)sender {
    [self updateSliderValues];
}

@end

NSString *const TestbedSettingsControllerValuesSavedNotification = @"TestbedSettingsController_VALUES_SAVED";
