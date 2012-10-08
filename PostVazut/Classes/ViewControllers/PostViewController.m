#import "PostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NimbusCore.h"
#import "NimbusNetworkImage.h"
#import "ScrollViewTouches.h"
#import "SVWebViewController.h"
#import "PVBrowserController.h"

static const CGFloat kFramePadding = 10;
static const CGFloat kTextBottomMargin = 10;
static const CGFloat kImageDimensions = 60;
static const CGFloat kImageSpacing = 10;

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize thePost;
@synthesize galleryHolder;
@synthesize bottomHolder;
@synthesize tiltInfo;
@synthesize categoryInfo;
@synthesize movieName;
@synthesize movieDescription;
@synthesize postAuthor;
@synthesize movieRank;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NINetworkImageView *)networkImageView {
    //UIImage* initialImage = [UIImage imageNamed:@"egopv_photo_placeholder.png"];
    
    NINetworkImageView* networkImageView = [[NINetworkImageView alloc] initWithImage:nil];
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
    
    int i = 0;;
    for (NINetworkImageView* imageView in _networkImageViews) {
        imageView.frame = CGRectMake(currentX, currentY, kImageDimensions, kImageDimensions);
        currentX += kImageDimensions + kImageSpacing;
        UIButton *b=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kImageDimensions, kImageDimensions)];
        b.tag = i;
        [b addTarget:self action:@selector(thumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:b];
        imageView.autoresizesSubviews = YES;
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        imageView.userInteractionEnabled = YES;
        i++;
        
    }
    
    _scrollView.contentSize = CGSizeMake(currentX + kFramePadding,
                                         currentY + kImageDimensions + kFramePadding);
    _scrollView.canCancelContentTouches = YES;
    _scrollView.delaysContentTouches = YES;
    
    
}

- (PostVazutPhotoViewController*) instantiatePhotoViewController {
    
    NSMutableArray *photoSource = [NSMutableArray array];
    EGOQuickPhoto *photo;
        
    for (NSDictionary *galleryItem in thePost.gallery) {
        photo = [[EGOQuickPhoto alloc] initWithImageURL:[NSURL URLWithString:[galleryItem objectForKey:@"image"]]];
        [photoSource insertObject:photo atIndex:[photoSource count]];
        photo = nil;
    }      
    
    EGOQuickPhotoSource *source = [[EGOQuickPhotoSource alloc] initWithPhotos:photoSource];
    PostVazutPhotoViewController *controller = [[PostVazutPhotoViewController alloc] initWithPhotoSource:source];
    
    return controller;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _networkImageViews = [[NSMutableArray alloc] init];
    _scrollView = [[ScrollViewTouches alloc] initWithFrame:CGRectMake(0, 0, self.galleryHolder.bounds.size.width, self.galleryHolder.bounds.size.height)];
    //_scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleHeight);
    
    [self.galleryHolder addSubview:_scrollView];
    
    postList = [PostList getInstance];
    
}

-(void) viewWillAppear:(BOOL)animated {

    if ([galleryHolder.subviews count] > 0) {
        UIView *scroller = (UIView*)[galleryHolder.subviews objectAtIndex:0];
        if ([scroller.subviews count] >0) {
            for (UIView *theview in scroller.subviews) [theview removeFromSuperview];
        }
        
    }
    
    while ([_networkImageViews count] > 0) [_networkImageViews removeObjectAtIndex:0];
        
    for (NSDictionary *galleryItem in thePost.gallery) {

        NINetworkImageView* networkImageView = [self networkImageView];
        
        [networkImageView setPathToNetworkImage: [galleryItem objectForKey:@"thumb"]
                                 forDisplaySize: CGSizeMake(kImageDimensions, kImageDimensions)
                                    contentMode: UIViewContentModeScaleAspectFill];
        
        
        [_scrollView addSubview:networkImageView];
        [_networkImageViews addObject:networkImageView];
    }        
    [self layoutImageViews];
    photoController = [self instantiatePhotoViewController];
    
    self.title = @"";
    // Get our custom nav bar
    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;
    
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"back_button_alpha.png"] highlight:nil leftCapWidth:24.0];
    [customNavigationBar setText:@"Back" onBackButton:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [movieName setFont:[UIFont fontWithName:@"Dosis-Bold" size:16]];
    movieName.text = [thePost.title uppercaseString];

    [movieDescription setFont:[UIFont fontWithName:@"Dosis-Bold" size:12]];
    movieDescription.text = thePost.body;
    
    [postAuthor setFont:[UIFont fontWithName:@"Dosis-Bold" size:11]];
    postAuthor.text = [thePost.author uppercaseString];

    [movieRank setFont:[UIFont fontWithName:@"Dosis-Bold" size:32]];
    movieRank.text = [thePost.rank uppercaseString];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    for (UIView *view in [self.bottomHolder subviews]) {
        [view removeFromSuperview];
    }
    
    UIImageView *backgroundLinks = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-movie-links.png"]];
    [self.bottomHolder addSubview:backgroundLinks];
    
    int slice = 0;
    int noLinks = 0;
    CGRect frame;
    UIImageView *separator;
    if (thePost.imdbLink != nil) noLinks++;
    if (thePost.rottenTomatoesLink != nil) noLinks++;
    if (thePost.metacriticLink != nil) noLinks++;
    if (noLinks > 0) {
        slice = round(self.bottomHolder.frame.size.width / noLinks);
    }

    for (int i=0; i<noLinks-1; i++) {
        separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
        frame = separator.frame;
        frame.origin.x = slice*(i+1);
        separator.frame = frame;
        [self.bottomHolder addSubview:separator];
    }    
    
    int startPos = 0;
    int buttonXAdder = 1;
    
    if (thePost.imdbLink != nil) {
        UIButton* imdbButton = [customNavigationBar actionButton:@"IMDB" backButtonImage:[UIImage imageNamed:@"transparent_header.png"] highlight:nil];
        imdbButton.tag = 1;
        [imdbButton addTarget:self action:@selector(showExternalPage:) forControlEvents:UIControlEventTouchUpInside];
        frame = imdbButton.frame;
        frame.origin.x = startPos + buttonXAdder + round((slice-frame.size.width)/2);
        imdbButton.frame = frame;
        startPos += slice;
        [self.bottomHolder addSubview:imdbButton];
        //totalSpace += imdbButton.frame.size.width + spaceBetweenButtons;
    }

    if (thePost.rottenTomatoesLink != nil) {
        UIButton* rtButton = [customNavigationBar actionButton:@"RT" backButtonImage:[UIImage imageNamed:@"transparent_header.png"] highlight:nil];
        rtButton.tag = 2;
        [rtButton addTarget:self action:@selector(showExternalPage:) forControlEvents:UIControlEventTouchUpInside];
        frame = rtButton.frame;
        frame.origin.x = startPos + buttonXAdder + round((slice-frame.size.width)/2);
        rtButton.frame = frame;
        startPos += slice;
        [self.bottomHolder addSubview:rtButton];
        //totalSpace += rtButton.frame.size.width + spaceBetweenButtons;
    }
    
    if (thePost.metacriticLink != nil) {
        UIButton* mcButton = [customNavigationBar actionButton:@"MC" backButtonImage:[UIImage imageNamed:@"transparent_header.png"] highlight:nil];
        mcButton.tag = 3;
        [mcButton addTarget:self action:@selector(showExternalPage:) forControlEvents:UIControlEventTouchUpInside];
        frame = mcButton.frame;
        frame.origin.x = startPos + buttonXAdder + round((slice-frame.size.width)/2);
        mcButton.frame = frame;
        startPos += slice;
        [self.bottomHolder addSubview:mcButton];
        //totalSpace += mcButton.frame.size.width + spaceBetweenButtons;
    }
    //totalSpace -= spaceBetweenButtons;
    


//    int startPos = round((self.bottomHolder.frame.size.width - totalSpace)/2);
//    CGRect frame;
//    for (UIButton *button in self.bottomHolder.subviews) {
//        frame = button.frame;
//        frame.origin.x = startPos;
//        frame.origin.y = 5;
//        startPos += button.frame.size.width + 25;
//        button.frame = frame;
//    }
//    
    [self.tiltInfo setFont:[UIFont fontWithName:@"Dosis-SemiBold" size:14]];
    if ([thePost.trailers count] > 0) {
        self.tiltInfo.text = @"TILT SCREEN FOR TRAILER";
    } else {
        self.tiltInfo.text = @"";
    }

    [self.categoryInfo setFont:[UIFont fontWithName:@"Dosis-SemiBold" size:12]];
    self.categoryInfo.text = [[thePost getCategoriesAsString] lowercaseString];
    
    
}

- (void)viewDidUnload
{
    [self setMovieName:nil];
    [self setMovieDescription:nil];
    [self setPostAuthor:nil];
    [self setPostAuthor:nil];
    [self setView:nil];
    [self setThePost:nil];
    [self setMovieRank:nil];
    [self setGalleryHolder:nil];
    [self setBottomHolder:nil];
    [self setTiltInfo:nil];
    [self setCategoryInfo:nil];
    [self setCategoryInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([thePost.trailers count] > 0) {
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            [self showTrailer];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self showTrailer];
            break;
        case UIInterfaceOrientationPortrait:
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            break;            
    }
}
- (void) thumbnailClicked:(id)sender
{
    UIButton *clickedButton = (UIButton *)sender;
	int buttonTag = [[clickedButton valueForKey:@"tag"] intValue];
    [self.navigationController pushViewController:photoController animated:YES];
    [photoController moveToPhotoAtIndex:buttonTag animated:NO];
}

- (void) showTrailer
{
    if ([thePost.trailers count] > 0) {
        NSURL *URL = [NSURL URLWithString:[thePost.trailers objectAtIndex:0]];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }    
}

-(void) showExternalPage:(id)sender {

    UIButton *clickedButton = (UIButton *)sender;
	int buttonTag = [[clickedButton valueForKey:@"tag"] intValue];
    NSURL *URL;
    PVBrowserController *webViewController;
    
    if (buttonTag==1) {
        URL = [NSURL URLWithString:thePost.imdbLink];
        webViewController = [[PVBrowserController alloc] initWithURL:URL];
        webViewController.showControls = YES;
        webViewController.showNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if (buttonTag==2) {
        URL = [NSURL URLWithString:thePost.rottenTomatoesLink];
        webViewController = [[PVBrowserController alloc] initWithURL:URL];
        webViewController.showControls = YES;
        webViewController.showNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if (buttonTag==3) {
        URL = [NSURL URLWithString:thePost.metacriticLink];
        webViewController = [[PVBrowserController alloc] initWithURL:URL];
        webViewController.showControls = YES;
        webViewController.showNavigation = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
}



@end
