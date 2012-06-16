//
//  DemoTooltipController.h
//  al7ios
//
//  Created by Alexandre Leite on 6/15/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoBaseViewController.h"
#import "ALTooltip.h"

@interface DemoTooltipController : DemoBaseViewController

@property (strong, nonatomic) ALTooltip *tooltip;

#pragma mark - Action Targets;

-(void)onColorSegmentChange:(id)sender;

@end
