#import "GalleryThumbnailsController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NimbusCore.h"
#import "NimbusNetworkImage.h"

static const CGFloat kFramePadding = 10;
static const CGFloat kTextBottomMargin = 10;
static const CGFloat kImageDimensions = 80;
static const CGFloat kImageSpacing = 10;

@implementation GalleryThumbnailsController

- (NINetworkImageView *)networkImageView {
    UIImage* initialImage = [UIImage imageWithContentsOfFile:
                             NIPathForBundleResource(nil, @"nimbus64x64.png")];
    
    NINetworkImageView* networkImageView = [[NINetworkImageView alloc] initWithImage:initialImage];
    networkImageView.delegate = self;
    networkImageView.contentMode = UIViewContentModeCenter;
    networkImageView.scaleOptions = NINetworkImageViewScaleToFitCropsExcess;
    networkImageView.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
    networkImageView.layer.borderWidth = 1;
    
    return networkImageView;
}


- (void)layoutImageViews {
    
    CGFloat currentX = kFramePadding;
    CGFloat currentY = kFramePadding;
    
    for (NINetworkImageView* imageView in _networkImageViews) {
        imageView.frame = CGRectMake(currentX, currentY, kImageDimensions, kImageDimensions);
        currentX += kImageDimensions + kImageSpacing;
    }
    
    _scrollView.contentSize = CGSizeMake(currentX + kFramePadding,
                                         currentY + kImageDimensions + kFramePadding);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
    
    _networkImageViews = [[NSMutableArray alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 230, self.view.bounds.size.width, kImageDimensions+kFramePadding+kTextBottomMargin)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleHeight);
    
    
    for (NSInteger ix = UIViewContentModeScaleToFill; ix <= UIViewContentModeBottomRight; ++ix) {
        if (UIViewContentModeRedraw == ix) {
            // Unsupported mode.
            continue;
        }
        NINetworkImageView* networkImageView = [self networkImageView];
        
        // From: http://www.flickr.com/photos/thonk25/3929945380/
        // We fetch the network image by explicitly setting the display size and content mode.
        // This overrides the use of the frame to determine the display size.
        [networkImageView setPathToNetworkImage:
         @"http://farm3.static.flickr.com/2484/3929945380_deef6f4962_z.jpg"
                                 forDisplaySize: CGSizeMake(kImageDimensions, kImageDimensions)
                                    contentMode: ix];
        
        [_scrollView addSubview:networkImageView];
        [_networkImageViews addObject:networkImageView];
    }
    
    [self.view addSubview:_scrollView];
    
    [self layoutImageViews];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    _scrollView = nil;
    [super viewDidUnload];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scrollView flashScrollIndicators];
    
    self.title = @"";
    // Get our custom nav bar
    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;
    
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"back_button_alpha.png"] highlight:nil leftCapWidth:24.0];
    [customNavigationBar setText:@"Back" onBackButton:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NIIsSupportedOrientation(toInterfaceOrientation);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
                                         duration: (NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation: toInterfaceOrientation
                                            duration: duration];
    [self layoutImageViews];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_scrollView flashScrollIndicators];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NINetworkImageViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)networkImageView:(NINetworkImageView *)imageView didLoadImage:(UIImage *)image {
}

@end
