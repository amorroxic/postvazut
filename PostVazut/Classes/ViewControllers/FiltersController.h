#import <UIKit/UIKit.h>
#import "FilterChoicesController.h"
#import "PostList.h"
#import "SCNavigationBar.h"

@interface FiltersController : UITableViewController {
    PostList *postList;
}
@property (retain, nonatomic) NSObject *delegate;
@property (nonatomic, retain) FilterChoicesController *filterChoicesController;
@property (strong, nonatomic) IBOutlet UIView *actionView;

@end
