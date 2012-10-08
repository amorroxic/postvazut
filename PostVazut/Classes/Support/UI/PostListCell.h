#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *postThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *postCategories;
@property (strong, nonatomic) IBOutlet UILabel *postTitle;
@property (strong, nonatomic) IBOutlet UILabel *postDescription;
@property (strong, nonatomic) IBOutlet UILabel *postAuthor;
@property (strong, nonatomic) IBOutlet UILabel *postRank;
@property (strong, nonatomic) IBOutlet UILabel *postDate;

-(void)setDetailWithPostItem: (Post*) postItem;


@end
