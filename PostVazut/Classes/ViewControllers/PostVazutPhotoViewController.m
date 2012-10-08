//
//  PostVazutPhotoViewController.m
//  Test6
//
//  Created by Adrian Mihai on 4/25/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import "PostVazutPhotoViewController.h"

@interface PostVazutPhotoViewController ()

@end

@implementation PostVazutPhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"";
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
