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

#import "LaunchPadController.h"
#import "LaunchPadImports.h"

@implementation LaunchPadController

-(id)init {
    self = [super init];
    if (self) {
        //-- get selected index from preferences;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(![userDefaults integerForKey:@"selectedScreenIndex"]) {
            [userDefaults setInteger:0 forKey:@"selectedScreenIndex"];
        }
        selectedScreenIndex = [userDefaults integerForKey:@"LaunchPad_selectedScreenIndex"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    
    UIView *myView = [[UIView alloc] initWithFrame:(isIos7) ? [[UIScreen mainScreen] bounds] : [[UIScreen mainScreen] applicationFrame]];
    [myView setBackgroundColor:[ALColorUtilities rgbColorWithRed:0 green:51 blue:153 alpha:1.0]];
    [self setView:myView];

    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchPad_Bg.png"]];
    [[self view] addSubview:bgView];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 0.0)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView selectRow:selectedScreenIndex inComponent:0 animated:YES];
    [pickerView moveToPosition:CGPointMake(0.0, [myView frame].size.height - [pickerView frame].size.height - 85.0)];
    if (isIos7) {
        [pickerView setBackgroundColor:[UIColor whiteColor]];
    }
    [[self view] addSubview:pickerView];
    
    UIFont *labelFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0];
    UIColor *labelColor = [UIColor whiteColor];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setFrame:CGRectMake([[self view] frame].size.width - 100.0, [pickerView frame].origin.y - 27.0, 95.0, 24.0)];
    [saveButton addTarget:self  action:@selector(onSaveButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [[self view] addSubview:saveButton];
    
    UILabel *launchpadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, [pickerView frame].origin.y - 30.0, 310.0, 30.0)];
    [launchpadLabel setBackgroundColor:[UIColor clearColor]];
    [launchpadLabel setFont:labelFont];
    [launchpadLabel setTextColor:labelColor];
    [launchpadLabel setText:@"Select demo to launch:"];
    [[self view] addSubview:launchpadLabel];
    
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goButton setFrame:CGRectMake(5.0, [myView frame].size.height - 80.0, 310.0, 40.0)];
    [goButton setTitle:@"Go!" forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(onGoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:goButton];
    
    UIButton *testbedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testbedButton setFrame:CGRectMake(5.0, [myView frame].size.height - 35.0, 240.0, 30.0)];
    [testbedButton setTitle:@"Testbed" forState:UIControlStateNormal];
    [testbedButton addTarget:self action:@selector(onTestbedButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:testbedButton];
    
    UIButton *memButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [memButton setFrame:CGRectMake(250.0, [testbedButton frame].origin.y, 65.0, 30.0)];
    [memButton setTitle:@"MEM" forState:UIControlStateNormal];
    [memButton addTarget:self action:@selector(onMemButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:memButton];
    
    if (isIos7) {
        for (UIView *view in [[self view] subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerView Protocol Implementations;

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = @"Unknown";
    switch (row) {
        case 0:
            result = @"ALFlipView";
            break;
        case 1:
            result = @"ALTooltip";
            break;
        case 2:
            result = @"ALModalMatte";
            break;
        case 3:
            result = @"ALTabBox";
            break;
    }
    return result;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedScreenIndex = row;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
};

#pragma mark - Redirector Methods;

-(void)goToLaucherSelection {
    UIViewController *targetRootController;
    UIViewController *targetController;
    switch (selectedScreenIndex) {
        case 0:
            targetRootController = nil;
            targetController = [[DemoFlipViewController alloc] init];
            break;
        case 1:
            targetRootController = nil;
            targetController = [[DemoTooltipController alloc] init];
            break;            
        case 2:
            targetRootController = nil;
            targetController = [[DemoModalMatteController alloc] init];
            break;
        case 3:
            targetRootController = nil;
            targetController = [[DemoTabBoxController alloc] init];
            break;
        default:
            targetRootController = nil;
            targetController = nil;
            break;
    }
    if (targetController) {
        if ([targetController isKindOfClass:[UINavigationController class]]) {
            [[(UINavigationController *)targetController navigationBar] setTintColor:[ALColorUtilities rgbColorWithRed:0 green:103 blue:0 alpha:1.0]];
        }     
        [targetController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:targetController animated:YES completion:nil];
    }
}

-(void)beginTestbed {
    TestbedController *targetController = [[TestbedController alloc] init];
    [self presentViewController:targetController animated:YES completion:nil];
}

-(void)beginMemoryTest {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Memory Test" message:@"No Memory Test is set." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(void)saveSelectedScreenIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedScreenIndex forKey:@"LaunchPad_selectedScreenIndex"];
    [userDefaults synchronize];
}

#pragma mark - Action Targets;

-(void)onSaveButtonTouch:(id)sender {
    [self saveSelectedScreenIndex];
}

-(void)onGoButtonTouch:(id)sender {
    [self goToLaucherSelection];
}

-(void)onTestbedButtonTouch:(id)sender {
    [self beginTestbed];
}

-(void)onMemButtonTouch:(id)sender {
    [self beginMemoryTest];
}

@end
