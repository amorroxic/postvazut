#import "Loader.h"

@interface Loader ()

@end

@implementation Loader
@synthesize loaderTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoader];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillDisappear:(BOOL)animated {
    [self hideLoader];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setView:nil];
    [self setLoaderTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void) showLoader {
	hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.delegate = self;
	hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

- (void) hideLoader {
	[hud hide:YES];
}

@end
