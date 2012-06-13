//
//  ALAppDelegate.h
//  al7ios
//
//  Created by Alexandre Leite on 6/6/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchPadController.h"

@interface ALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LaunchPadController *launchPadController;

@end
