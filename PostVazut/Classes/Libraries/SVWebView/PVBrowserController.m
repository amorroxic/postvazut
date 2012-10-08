//
//  PVBrowserController.m
//  PostVazut
//
//  Created by Adrian Mihai on 5/8/12.
//  Copyright (c) 2012 liveBooks. All rights reserved.
//

#import "PVBrowserController.h"

@interface PVBrowserController ()

@end

@implementation PVBrowserController

@synthesize showControls,showNavigation;

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];

    if (self.showControls) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    } else {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    
    if (self.showNavigation) {
        [self.navigationController setNavigationBarHidden:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
    }

    // Get our custom nav bar
    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;
    
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"back_button_alpha.png"] highlight:nil leftCapWidth:24.0];
    [customNavigationBar setText:@"Back" onBackButton:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
