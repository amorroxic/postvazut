#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "PostItem.h"
#import "Gallery.h"
#import "Trailers.h"
#import "Categories.h"

@interface Post : NSObject {
    
    NSString *_title;
    NSString *_body;
    NSString *_url;
    NSString *_dateString;    
    NSDate *_date;    
    NSString *_author;    
    NSString *_thumbnail;
    NSString *_rank;
    NSString *_imdbLink;
    NSString *_metacriticLink;
    NSString *_rottenTomatoesLink;
    NSMutableArray *_ratings;
    NSMutableArray *_categories;
    NSMutableArray *_gallery;
    NSMutableArray *_trailers;
    
}

@property (copy) NSString *title;
@property (copy) NSString *body;
@property (copy) NSString *url;
@property (copy) NSString *dateString;
@property (copy) NSDate *date;
@property (copy) NSString *author;
@property (copy) NSString *rank;
@property (copy) NSString *thumbnail;
@property (copy) NSMutableArray *categories;
@property (copy) NSMutableArray *gallery;
@property (copy) NSMutableArray *ratings;
@property (copy) NSString *imdbLink;
@property (copy) NSString *metacriticLink;
@property (copy) NSString *rottenTomatoesLink;
@property (copy) NSMutableArray *trailers;

- (id)initWithXML:(GDataXMLElement*)xmlItem;
- (id)initWithCoreData:(PostItem*)postItem;
- (NSString*) getCategoriesAsString;
- (NSString*) showDate;

@end
