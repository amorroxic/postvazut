//
//  PostList.h
//  Test6
//
//  Created by Adrian Mihai on 4/17/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "RSSLoader.h"

@protocol PostListProtocol
@required
-(void)postListLoaded;
-(void)postListFailed;
-(void) postListUpdated;
@end

@interface PostList : NSObject <RSSLoaderDelegate> {
    NSObject<PostListProtocol> *delegate;
    NSMutableArray *_posts;
    NSMutableArray *_filteredPosts;
    NSMutableArray *_categories;
    NSMutableArray *_searchResults;
    RSSLoader* rss;
    BOOL postsLoaded;
    NSDate *_lastUpdate;
    NSMutableArray *_filters;
    BOOL listFiltered;
}
@property (retain) NSMutableArray *posts;
@property (retain) NSMutableArray *filteredPosts;
@property (retain) NSMutableArray *searchResults;
@property (retain) NSMutableArray *categories;
@property (retain) NSDate *lastUpdate;
@property (retain, nonatomic) NSObject<PostListProtocol> *delegate;

+ (id)getInstance;

-(int) postsCount;
-(Post*) getPostAtIndex:(NSInteger) index;
-(void) updatePosts;
-(NSDictionary*) getFilterForName: (NSString*) name;
-(void) resetFilters;
-(void) setValues:(NSArray *)values forFilter:(NSString*) filterName;
-(NSString*) getChosenValuesFor: (NSString*) filterName;
-(BOOL) hasChosenValue:(NSString*)value forFilter:(NSString*)filterName;
-(BOOL) listIsFiltered;
-(void) addChosenValue:(NSString*)value forFilter:(NSString*)filterName;
-(void) removeChosenValue:(NSString*)value forFilter:(NSString*)filterName;
- (BOOL) stringExists: (NSString*) str inArray: (NSArray *) arr;
-(void) filterPosts;
-(NSDate*)getLastUpdate;
-(void) refreshPosts;
-(BOOL) doPostsExist;
-(void) searchPostsForString:(NSString*)search;
-(Post*) getPostWithSearchAtIndex:(NSInteger) index;
-(NSInteger) getSearchResultsCount;
@end
