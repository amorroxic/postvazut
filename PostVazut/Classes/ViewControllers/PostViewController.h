#import <UIKit/UIKit.h>
#import "PostList.h"
#import "NimbusCore.h"
#import "NimbusNetworkImage.h"
#import "ScrollViewTouches.h"
#import "EGOPhotoGlobal.h"
#import "PostVazutPhotoViewController.h"
#import "SCNavigationBar.h"

@interface PostViewController : UIViewController <NINetworkImageViewDelegate> {
@private
    ScrollViewTouches*   _scrollView;
    NSMutableArray* _networkImageViews;
    PostVazutPhotoViewController *photoController;
    PostList *postList;
}
@property (strong, nonatomic) IBOutlet UILabel *movieName;
@property (strong, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) IBOutlet UILabel *postAuthor;
@property (strong, nonatomic) IBOutlet UILabel *movieRank;
@property (strong, nonatomic) Post *thePost;
@property (strong, nonatomic) IBOutlet UIView *galleryHolder;
@property (strong, nonatomic) IBOutlet UIView *bottomHolder;
@property (strong, nonatomic) IBOutlet UILabel *tiltInfo;
@property (strong, nonatomic) IBOutlet UILabel *categoryInfo;

@end
