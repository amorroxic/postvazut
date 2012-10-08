#import "PostListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostListCell
@synthesize postThumbnail;
@synthesize postCategories;
@synthesize postTitle;
@synthesize postDescription;
@synthesize postAuthor;
@synthesize postRank;
@synthesize postDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDetailWithPostItem: (Post*) postItem {
    
    self.postAuthor.text = postItem.author;
    [self.postAuthor setFont:[UIFont fontWithName:@"Dosis-SemiBold" size:12]];
    
    self.postCategories.text = [postItem getCategoriesAsString];
    [self.postCategories setFont:[UIFont fontWithName:@"Dosis-SemiBold" size:12]];
    
    self.postTitle.text = [postItem.title uppercaseString];   
    
    [self.postTitle setFont:[UIFont fontWithName:@"Dosis-Bold" size:14]];
    
    self.postDescription.text = postItem.body;
    self.postRank.text = postItem.rank;
    [self.postRank setFont:[UIFont fontWithName:@"Dosis-Bold" size:28]];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    self.postDate.text = [postItem showDate];
    
    NSString *urlString = postItem.thumbnail;
    if (urlString) {
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] success:^(UIImage *requestedImage) {
            self.postThumbnail.image = requestedImage;
            [self setNeedsDisplay];
        }];
        [operation start];    
    
//    NSURL *url = [NSURL URLWithString:postItem.thumbnail];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *imageThumbnail = [UIImage imageWithData:imageData];
    }
    
}

@end
