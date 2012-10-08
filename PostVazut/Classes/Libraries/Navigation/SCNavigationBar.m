//
//  SCNavigationBar.m
//  ExampleNavBarBackground
//
//  Created by Sebastian Celis on 3/1/2012.
//  Copyright 2012-2012 Sebastian Celis. All rights reserved.
//

#import "SCNavigationBar.h"
#import "AppDelegate.h"
#define MAX_BACK_BUTTON_WIDTH 160.0

@interface SCNavigationBar ()
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) NSMutableDictionary *backgroundImages;
- (void)updateBackgroundImage;
@end


@implementation SCNavigationBar

@synthesize backgroundImages = _backgroundImages;
@synthesize backgroundImageView = _backgroundImageView;

#pragma mark - Background Image

- (NSMutableDictionary *)backgroundImages
{
    if (_backgroundImages == nil)
    {
        _backgroundImages = [[NSMutableDictionary alloc] init];
    }
    
    return _backgroundImages;
}

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
        [_backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self insertSubview:_backgroundImageView atIndex:0];
    }
    
    return _backgroundImageView;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    }
    else
    {
        [[self backgroundImages] setObject:backgroundImage forKey:[NSNumber numberWithInt:barMetrics]];
        [self updateBackgroundImage];
    }
}

- (void)updateBackgroundImage
{
    UIBarMetrics metrics = ([self bounds].size.height > 40.0) ? UIBarMetricsDefault : UIBarMetricsLandscapePhone;
    UIImage *image = [[self backgroundImages] objectForKey:[NSNumber numberWithInt:metrics]];
    if (image == nil && metrics != UIBarMetricsDefault)
    {
        image = [[self backgroundImages] objectForKey:[NSNumber numberWithInt:UIBarMetricsDefault]];
    }
    
    if (image != nil)
    {
        [[self backgroundImageView] setImage:image];
        CGRect frame = [self.window bounds];
        frame.size.height = 65;
        [self backgroundImageView].frame = frame;

    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_backgroundImageView != nil)
    {
        [self updateBackgroundImage];
        [self sendSubviewToBack:_backgroundImageView];
    }
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)back:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController popViewControllerAnimated:YES];
}

// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth
{
    // store the cap width for use later when we set the text
    backButtonCapWidth = capWidth;
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:self.topItem.title onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// Set the text on the custom back button
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton
{
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}

-(UIButton*) actionButton:(NSString*)withText backButtonImage:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage {
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:24.0 topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:24.0 topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    //button.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:12];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:self.topItem.title onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Measure the width of the text
    CGSize textSize = [withText sizeWithFont:button.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + (24.0 * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (24.0 * 1.5)), button.frame.size.height);
    
    // Set the text on the button
    [button setTitle:withText forState:UIControlStateNormal];
    
    return button;
    
}


@end
