#import <UIKit/UIKit.h>
#import "NimbusCore.h"
#import "NimbusNetworkImage.h"
#import "SCNavigationBar.h"

@interface GalleryThumbnailsController : UIViewController <NINetworkImageViewDelegate> {
@private
    UIScrollView*   _scrollView;
    NSMutableArray* _networkImageViews;
}
@end
