#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "PostList.h"
#import "FiltersController.h"
#import "SortChoicesController.h"
#import "PullRefreshTableViewController.h"
#import "SCNavigationBar.h"
#import "WEPopoverController.h"

@interface PostListController : PullRefreshTableViewController <UISearchDisplayDelegate,PopoverControllerDelegate> {
    NSObject *delegate;
    UISearchBar *mySearchBar;
    BOOL bSearchIsOn;
    PostList *postList;
    UIInterfaceOrientation m_orientation;
	WEPopoverController *popoverController;
}

@property (nonatomic, retain) PostViewController *postViewController;
@property (nonatomic, retain) SortChoicesController *sortController;
@property (nonatomic, retain) FiltersController *filtersController;
@property (retain, nonatomic) NSObject *delegate;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) WEPopoverController *popoverController;

-(void) postsRefreshed;
-(void) postsFailed;
@end
