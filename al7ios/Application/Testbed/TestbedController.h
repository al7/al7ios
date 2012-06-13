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

#import <UIKit/UIKit.h>
#import "ALUtilities.h"
#import "TestbedSettingsController.h"

//- Import Custom Test Headers Here (REMOVE THEM AFTER TESTING IS COMPLETE TO KEEP CODE CLEAN!!!)

@interface TestbedController : UIViewController {
    @private
    UILabel *titleLabel;
    UISwitch *bgSwitch;
    UIButton *dismissButton;
    UIButton *settingsButton;
    UIScrollView *testbedView;
    UISegmentedControl *segmentedControl;
    TestbedSettingsController *testbedSettingsController;
    
    //- Declare Custom Test Views Here (REMOVE THEM AFTER TESTING IS COMPLETE TO KEEP CODE CLEAN!!!)
}

@property (strong, nonatomic) UIColor *darkColor;
@property (strong, nonatomic) UIColor *lightColor;

#pragma mark - Class Methods;

-(void)toggleBackgroundColor;
-(void)presentSettings;

#pragma mark - Overridable Methods;

-(void)buildViewHierarchyIn:(UIView *)testbedView;
-(void)doStuffWithIndex:(NSInteger)index;

#pragma mark - Notification Responders;

-(void)onTestbedSettingsControllerValuesSaved:(id)sender;

#pragma mark - Action Targets;

-(void)onDismissButtonTouch:(id)sender;
-(void)onSettingsButtonTouch:(id)sender;
-(void)onBgSwitchToggle:(id)sender;
-(void)onSegmentedControlValueChanged:(id)sender;

#pragma mark - Temp Action Targets -- REMOVE AFTER TESTING!!!

#pragma mark - Temp Methods -- REMOVE AFTER TESTING!!!;

@end
