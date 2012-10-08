#import <UIKit/UIKit.h>
#import "PostList.h"
#import "SCNavigationBar.h"

@interface FilterChoicesController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    PostList *postList;
    NSString *xibFile;
}
@property (retain, nonatomic) NSObject *delegate;
@property (retain, nonatomic) NSString *filterName;
@property (nonatomic) BOOL allowMultipleSelection;
@property (retain, nonatomic) NSMutableArray *chosenValues;
@property (retain, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *theBottomView;

-(void) displaySmallCell;

@end
