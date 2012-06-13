//
//  DemoBaseViewController.h
//  al7ios
//
//  Created by Alexandre Leite on 6/6/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALUtilities.h"

@interface DemoBaseViewController : UIViewController

@property (strong, nonatomic) NSString *headerText;

#pragma mark - Initializers;

-(id)initWithHeaderText:(NSString *)headerText;

#pragma mark - Overridable Methods;

-(void)buildViewHierarchyInView:(UIView *)contentView;

#pragma mark - Action Targets;

-(void)onOkTouch:(id)sender;

@end
