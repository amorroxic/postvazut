#import <UIKit/UIKit.h>

@interface FilterChoicesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *checkbox;
@property (nonatomic) NSString *isSelected;

@end
