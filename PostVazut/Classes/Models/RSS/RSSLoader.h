#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Post.h"

#define pvRSSUrl @"http://postvazut.blogspot.com/feeds/posts/default?alt=rss&max-results=2000&orderby=updated&published-min="

@protocol RSSLoaderDelegate
@required
-(void)updatedFeedWithRSS;
-(void)failedFeedUpdateWithError:(NSError*)error;
-(Post*)addEntryWithXml:(GDataXMLElement*)xmlItem;
-(void)addCategoryWithXML: (GDataXMLElement*) xmlItem;
-(void)setLastUpdated:(GDataXMLNode*)node;
-(NSDate*)getLastUpdate;
@end

@interface RSSLoader : NSObject {
    NSObject<RSSLoaderDelegate> * delegate;
    BOOL loaded;
    BOOL loadedLocalFile;
}

@property (retain, nonatomic) NSObject<RSSLoaderDelegate> * delegate;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) BOOL loadedLocalFile;

-(void)loadFeedThenPerformAction:(SEL)action;

@end
