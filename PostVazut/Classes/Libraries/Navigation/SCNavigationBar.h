//
//  SCNavigationBar.h
//  ExampleNavBarBackground
//
//  Created by Sebastian Celis on 3/1/2012.
//  Copyright 2012-2012 Sebastian Celis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNavigationBar : UINavigationBar {
    CGFloat backButtonCapWidth;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics;
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;
-(UIButton*) actionButton:(NSString*)withText backButtonImage:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage;

@end
