#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Loader : UIViewController <MBProgressHUDDelegate> {
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UILabel *loaderTitle;

@end
