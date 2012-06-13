//
//  DemoFlipViewController.h
//  al7ios
//
//  Created by Alexandre Leite on 6/6/12.
//  Copyright (c) 2012 al7dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoBaseViewController.h"
#import "ALFlipView.h"

@interface DemoFlipViewController : DemoBaseViewController {
    int flipI;
};

@property (strong, nonatomic) ALFlipView *flipView;

#pragma mark - Action Targets;

-(void)onFlipButtonTouch:(id)sender;
-(void)onSelectedSegmentIndexChange:(id)sender;

@end
