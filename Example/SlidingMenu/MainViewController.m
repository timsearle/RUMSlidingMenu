//
//  MainViewController.m
//  SlidingMenu
//
//  Created by Tim Searle on 18/03/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

- (IBAction)showLeftMenu:(id)sender;
- (IBAction)showRightMenu:(id)sender;

@property (strong) IBOutletCollection(UIControl) NSArray *myControls;

@end

@implementation MainViewController

@synthesize delegate = _delegate;

#pragma mark - Interactions

- (IBAction)showLeftMenu:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toggleLeftMenu)]) {
        [self.delegate toggleLeftMenu];
    }
}

- (IBAction)showRightMenu:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toggleRightMenu)]) {
        [self.delegate toggleRightMenu];
    }
}

@end
