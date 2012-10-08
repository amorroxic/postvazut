//
//  PostList.m
//  Test6
//
//  Created by Adrian Mihai on 4/17/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import "PostList.h"
#import "PostItem.h"
#import "Trailers.h"
#import "Gallery.h"
#import "Categories.h"
#import "Preferences.h"
#import "AppDelegate.h"
#import "Timer.h"

static PostList *postInstance = nil;

@implementation PostList

@synthesize posts = _posts;
@synthesize filteredPosts = _filteredPosts;
@synthesize searchResults = _searchResults;
@synthesize categories = _categories;
@synthesize lastUpdate = _lastUpdate;
@synthesize delegate;

+ (id)getInstance {
    @synchronized(self) {
        if (postInstance == nil)
            postInstance = [[self alloc] init];
    }
    return postInstance;
}

-(id)init
{
	if ([super init]!=nil) {
        self.posts = [NSMutableArray array];
        self.filteredPosts = [NSMutableArray array];
        self.searchResults = [NSMutableArray array];
        self.categories = [NSMutableArray array];
        rss = [[RSSLoader alloc] init];
        rss.delegate = self;
        postsLoaded = NO;
        listFiltered = NO;
	}
	return self;
}

-(void) resetFilters {
    
    _filters = [NSMutableArray array];
    [_filteredPosts removeAllObjects];
    
    NSMutableDictionary *categoryFilter = [[ NSMutableDictionary alloc] init];    
    NSMutableArray *chosenOptions = [NSMutableArray array];
    [categoryFilter setObject:@"categories" forKey:@"name"];
    [categoryFilter setObject:chosenOptions forKey:@"chosen-values"];
    [categoryFilter setObject:@"0" forKey:@"applied"];
    
    
    NSMutableDictionary *authorFilter = [[ NSMutableDictionary alloc] init];    
    NSMutableArray *chosenAuthors = [NSMutableArray array];
    [authorFilter setObject:@"authors" forKey:@"name"];
    [authorFilter setObject:chosenAuthors forKey:@"chosen-values"];
    [authorFilter setObject:@"0" forKey:@"applied"];

    NSMutableDictionary *sortingFilter = [[ NSMutableDictionary alloc] init];    
    NSMutableArray *chosenSorting = [NSMutableArray array];
    [sortingFilter setObject:@"sorting" forKey:@"name"];
    [sortingFilter setObject:chosenSorting forKey:@"chosen-values"];
    [sortingFilter setObject:@"0" forKey:@"applied"];
    
    [_filters insertObject:categoryFilter atIndex:0];
    [_filters insertObject:authorFilter atIndex:0];
    [_filters insertObject:sortingFilter atIndex:0];
    
    listFiltered = NO;
    
    [self populateFilters];
    
}

-(void) populateFilters {
    for (NSMutableDictionary *filter in _filters) {
        NSString *filterName = [filter objectForKey:@"name"];
        if ([filterName isEqualToString:@"categories"]) {
            NSArray *theCategories = [self getUniqueCategories];
            [filter setObject:theCategories forKey:@"values"];
        } else if ([filterName isEqualToString:@"authors"]) {
            NSArray *authors = [self getUniqueAuthorsFromPosts];
            [filter setObject:authors forKey:@"values"];
        } else if ([filterName isEqualToString:@"sorting"]) {
            NSArray *sorting = [self getSortingOptions];
            [filter setObject:sorting forKey:@"values"];
        }
    }
}

-(NSArray*) getUniqueAuthorsFromPosts {
    NSMutableArray *authors = [NSMutableArray array];
    [authors addObject:@"All"];
    for (Post* post in _posts) {
        if (![self stringExists:post.author inArray:authors]) {
            [authors addObject:post.author];
        }
    }
    return authors;
}

-(NSArray*) getUniqueCategories {
    NSMutableArray *returnCategories = [NSMutableArray array];
    [returnCategories addObject:@"All"];
    for (NSString* category in _categories) {
        if (![self stringExists:category inArray:returnCategories]) {
            [returnCategories addObject:category];
        }
    }
    return returnCategories;
}

-(NSArray*) getSortingOptions {
    NSMutableArray *returnCategories = [NSMutableArray array];
    [returnCategories addObject:@"Newest movies"];
    [returnCategories addObject:@"Best movies"];
    [returnCategories addObject:@"Worst movies"];
    return returnCategories;
}



- (BOOL) stringExists: (NSString*) str inArray: (NSArray *) arr {
    for (NSString* item in arr)
    {
        if ([item rangeOfString:str].location != NSNotFound) return YES;
    }
    return NO;
}

-(void) setValues:(NSArray *)values forFilter:(NSString*) filterName {
    for (NSMutableDictionary *filter in _filters) {
        NSString *fName = [filter objectForKey:@"name"];
        if ([fName isEqualToString:filterName]) {
            
            [filter setObject:@"1" forKey:@"applied"];

            if ([self stringExists:@"All" inArray:values]) {
                [filter setObject:@"0" forKey:@"applied"];
            }
            
            if ([values count] == 0) {
                [filter setObject:@"0" forKey:@"applied"];
            }
            
            [filter setObject:values forKey:@"chosen-values"];
            
        }
    }
}

-(BOOL) hasChosenValue:(NSString*)value forFilter:(NSString*)filterName {

    for (NSMutableDictionary *filter in _filters) {
        NSString *fName = [filter objectForKey:@"name"];
        if ([fName isEqualToString:filterName]) {
            
            NSArray *chosenValues = [filter objectForKey:@"chosen-values"];
            if ([self stringExists:value inArray:chosenValues]) {
                return YES;
            }
        }
    }
    
    return NO;

}

-(void) addChosenValue:(NSString*)value forFilter:(NSString*)filterName {
    
    BOOL alreadyPresent = [self hasChosenValue:value forFilter:filterName];
    if (!alreadyPresent) {
        for (NSMutableDictionary *filter in _filters) {
            NSString *fName = [filter objectForKey:@"name"];
            if ([fName isEqualToString:filterName]) {
                NSMutableArray *arr = [filter objectForKey:@"chosen-values"]; 
                [arr insertObject:value atIndex:[arr count]];
            }
        }
        
    }
        
}

-(void) removeChosenValue:(NSString*)value forFilter:(NSString*)filterName {
    
    BOOL alreadyPresent = [self hasChosenValue:value forFilter:filterName];
    if (alreadyPresent) {
        for (NSMutableDictionary *filter in _filters) {
            NSString *fName = [filter objectForKey:@"name"];
            if ([fName isEqualToString:filterName]) {
                NSMutableArray *arr = [filter objectForKey:@"chosen-values"]; 
                for (NSString*item in arr) {
                    if ([item isEqualToString:value]) {
                        [arr removeObject:item];
                    }
                }
            }
        }
        
    }
    
}



-(NSDictionary*) getFilterForName: (NSString*) name {
    for (NSMutableDictionary *filter in _filters) {
        NSString *filterName = [filter objectForKey:@"name"];
        if ([filterName isEqualToString:name]) {
            return filter;
        }
    }
    return nil;
}

-(NSString*) getChosenValuesFor: (NSString*) filterName {
    NSString *returnValue;
    NSDictionary *filter = [self getFilterForName:filterName];
    NSMutableArray *values = [filter objectForKey:@"values"]; 
    NSMutableArray *arr = [filter objectForKey:@"chosen-values"]; 
    if ([[filter objectForKey:@"applied"] isEqualToString:@"0"]) {
        returnValue = [values objectAtIndex:0];
    } else {
        if ([arr count] == 0) {
            returnValue = [values objectAtIndex:0];
        } else {
            returnValue = [arr componentsJoinedByString:@", "];
        }
    }
    return returnValue;
    
}

-(void) filterPosts {
    
    BOOL postValid;
    
    [self.filteredPosts removeAllObjects];

    for (int i=0; i<[_posts count]; i++) {

        postValid = YES;
        Post *thePost = (Post*)[_posts objectAtIndex:i]; 
        NSDictionary *filter1 = [self getFilterForName:@"authors"];
        NSArray *chosenAuthors = [filter1 objectForKey:@"chosen-values"]; 
        NSString *chosenAuthorsApplied = [filter1 objectForKey:@"applied"]; 
        NSDictionary *filter2 = [self getFilterForName:@"categories"];
        NSArray *chosenCategories = [filter2 objectForKey:@"chosen-values"]; 
        NSString *chosenCategoriesApplied = [filter2 objectForKey:@"applied"]; 

        if ([chosenAuthorsApplied isEqualToString:@"1"]) {
            postValid = NO;
            if ([self post:thePost hasAuthorInArray:chosenAuthors]) {
                postValid = YES;
            }
        }

        if (postValid && [chosenCategoriesApplied isEqualToString:@"1"]) {
            postValid = NO;
            if ([self post:thePost hasCategoryInArray:chosenCategories]) {
                postValid = YES;
            }
        }
        
        if (postValid) [self.filteredPosts addObject:thePost];        
        
    }
    
    [self arraySorted];
    
    listFiltered = YES;
    
}

-(BOOL) post:(Post*) post hasAuthorInArray:(NSArray*)arr {
    if ([self stringExists:post.author inArray:arr]) return YES;
    return NO;
}

-(BOOL) post:(Post*) post hasCategoryInArray:(NSArray*)arr {
    
    NSString* postCategory;
    
    for (int i=0; i<[post.categories count]; i++) {
        postCategory = [post.categories objectAtIndex:i];
        if ([self stringExists:postCategory inArray:arr]) return YES;
    }
    return NO;
}

-(NSString *)getSortOrder {
    NSDictionary *filter = [self getFilterForName:@"sorting"];
    NSArray *chosenSorting = [filter objectForKey:@"chosen-values"]; 
    if ([chosenSorting count] == 0) {
        return [[filter objectForKey:@"values"] objectAtIndex:0];
    }
    return [[filter objectForKey:@"chosen-values"] objectAtIndex:0];
}

-(void) arraySorted {
    
    NSString *sortOrder = [self getSortOrder];
    
    if ([sortOrder isEqualToString:@"Newest movies"]) {
        [self.filteredPosts sortUsingSelector:@selector(compareWithDate:)];
    } else if ([sortOrder isEqualToString:@"Best movies"]) {
        [self.filteredPosts sortUsingSelector:@selector(compareWithBest:)];
    } else if ([sortOrder isEqualToString:@"Worst movies"]) {
        [self.filteredPosts sortUsingSelector:@selector(compareWithWorst:)];
    }
    
}

-(void) searchResultsSorted {
    
    NSString *sortOrder = [self getSortOrder];
    
    if ([sortOrder isEqualToString:@"Newest movies"]) {
        [self.searchResults sortUsingSelector:@selector(compareWithDate:)];
    } else if ([sortOrder isEqualToString:@"Best movies"]) {
        [self.searchResults sortUsingSelector:@selector(compareWithBest:)];
    } else if ([sortOrder isEqualToString:@"Worst movies"]) {
        [self.searchResults sortUsingSelector:@selector(compareWithWorst:)];
    }
    
}

-(int) postsCount {
    if (listFiltered) return [_filteredPosts count];
    return [_posts count];
}

-(Post*) getPostAtIndex:(NSInteger) index {
    if (listFiltered) return [_filteredPosts objectAtIndex:index];
    return [_posts objectAtIndex:index];
}

-(void) updatePosts {
    [Timer lapse:@"[PostList updatePosts]: begin"];
    BOOL coreDataStatus = [self getCoreDataPosts];
    if (!coreDataStatus) {
        [Timer lapse:@"[PostList updatePosts]: no core data"];
        [rss loadFeedThenPerformAction:@selector(updatedFeedWithLocalRSS)];
    } else {
        [Timer lapse:@"[PostList updatePosts]: core data present"];
        rss.loadedLocalFile = YES;
        [self updatedFeedWithRSS];
    }
}

-(BOOL) getCoreDataPosts {
    NSManagedObjectContext *managedObjectContext;
    [Timer lapse:@"[PostList getCoreDataPosts]: begin"];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    @try {
        managedObjectContext = appDelegate.managedObjectContext;
    }
    @catch (NSException *e) {
        NSLog(@"Error getting managed object context");
    }
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *postItem = [NSEntityDescription entityForName:@"PostItem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:postItem];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] < 1) return NO;
    
    @try {

        NSLog(@"Trying Core Data - %d objects",fetchedObjects.count);
        int t = 0, g = 0, c = 0;
        for (PostItem *postItem in fetchedObjects)
        {
            t+=postItem.trailers.count;
            g+=postItem.gallery.count;
            c+=postItem.categories.count;
            [self addEntryWithCoreData:postItem];
        }
        //NSLog(@"%d %d %d",t,g,c);
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        return NO;
    }

//    for (Post *post in _posts) {
//        for (NSString *category in post.categories) {
//            if (![self stringExists:category inArray:self.categories]) {
//                [self.categories insertObject:category atIndex:0];
//            }
//        }
//    }
    self.categories = [NSMutableArray arrayWithArray:[self.categories sortedArrayUsingComparator:^(NSString *a, NSString *b) {
        return [a compare:b];
    }]];
     
    NSEntityDescription *preferences = [NSEntityDescription entityForName:@"Preferences" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:preferences];
    NSArray *fetchedPreferences = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedPreferences count] < 1) return NO;
    
    @try {
        
        for (Preferences *setting in fetchedPreferences)
        {
            
            NSString *settingKey = setting.key;
            //NSString *settingType = setting.type;
            NSString *settingValue = setting.value;
            
            if ([settingKey isEqualToString:@"lastupdated"]) {
                
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];    
                NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [inputFormatter setLocale: usLocale];
                [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                self.lastUpdate = [inputFormatter dateFromString: settingValue];
                
            }
        }
        
    }
    @catch (NSException * e) {
        return NO;
    }
    
    [Timer lapse:@"[PostList getCoreDataPosts]: end"];
    
    return YES;
}

-(BOOL) saveCoreDataPosts {
    
    Post *post;
    NSError *error;
    
    [Timer lapse:@"[PostList saveCoreDataPosts]: begin"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate recreatePersistentObjects];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    for (int i=0; i<[_posts count]; i++) {
        
        post = [_posts objectAtIndex:i];
        
        PostItem *postItem = (PostItem *)[NSEntityDescription insertNewObjectForEntityForName:@"PostItem" inManagedObjectContext:managedObjectContext];
        postItem.title = post.title;
        postItem.body = post.body;
        postItem.rank = post.rank;
        postItem.url = post.url;
        postItem.date = post.date;
        postItem.author = post.author;
        postItem.thumbnail = post.thumbnail;
        postItem.imdb = post.imdbLink;
        postItem.metacritic = post.metacriticLink;
        postItem.rottentomatoes = post.rottenTomatoesLink;
        
        for (int j=0; j<[post.gallery count]; j++) {
            Gallery *gallery = (Gallery *)[NSEntityDescription insertNewObjectForEntityForName:@"Gallery" inManagedObjectContext:managedObjectContext];
            gallery.thumb = [(NSDictionary*)[post.gallery objectAtIndex:j] objectForKey:@"thumb"];
            gallery.image = [(NSDictionary*)[post.gallery objectAtIndex:j] objectForKey:@"image"];
            [postItem addGalleryObject:gallery];
        }

        for (int j=0; j<[post.trailers count]; j++) {
            Trailers *trailers = (Trailers *)[NSEntityDescription insertNewObjectForEntityForName:@"Trailers" inManagedObjectContext:managedObjectContext];
            trailers.url = [post.trailers objectAtIndex:j];
            [postItem addTrailersObject:trailers];
        }

        for (int j=0; j<[post.categories count]; j++) {
            Categories *categories = (Categories *)[NSEntityDescription insertNewObjectForEntityForName:@"Categories" inManagedObjectContext:managedObjectContext];
            categories.name = [post.categories objectAtIndex:j];
            [postItem addCategoriesObject:categories];
        }
        
    }

    Preferences *preferences = (Preferences *)[NSEntityDescription insertNewObjectForEntityForName:@"Preferences" inManagedObjectContext:managedObjectContext];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [inputFormatter setLocale: usLocale];
    [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    preferences.value = [inputFormatter stringFromDate:self.lastUpdate];
    preferences.key = @"lastupdated";
    preferences.type = @"date";
    
    // here's where the actual save happens, and if it doesn't we print something out to the console
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
        return NO;
    }    
    [Timer lapse:@"[PostList saveCoreDataPosts]: end"];
    
    return YES;
}

-(Post*)addEntryWithXml:(GDataXMLElement*)xmlItem {
    Post *entry = [[Post alloc] initWithXML: xmlItem];
    [_posts insertObject:entry atIndex:0];
    return entry;
}

-(Post*)addEntryWithCoreData:(PostItem*)postItem {
    Post *entry = [[Post alloc] initWithCoreData: postItem];
    [_posts insertObject:entry atIndex:0];
    return entry;
}

-(void)setLastUpdated:(GDataXMLNode*)node {
    NSString *nodeValue = [node stringValue];
    nodeValue = [nodeValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [inputFormatter setLocale: usLocale];
    [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    self.lastUpdate = [inputFormatter dateFromString: nodeValue];
}

-(void)addCategoryWithXML: (GDataXMLElement*) xmlItem {
    NSString *category = [xmlItem stringValue];
    if (![self stringExists:category inArray:self.categories]) {
        [self.categories insertObject:category atIndex:0];
    }
}

-(void)updatedFeedWithLocalRSS {
    postsLoaded = YES;
    [_posts sortUsingSelector:@selector(compareWithDate:)];
    //update local feeds to include postvazut's newer feeds
    [rss loadFeedThenPerformAction:@selector(updatedFeedWithRSS)];
    
}
-(void)updatedFeedWithRSS {
    [Timer lapse:@"[PostList updatedFeedWithRSS]: begin"];
    postsLoaded = YES;
    [self resetFilters];
    [_posts sortUsingSelector:@selector(compareWithDate:)];
    [Timer lapse:@"[PostList updatedFeedWithRSS]: end"];
    [self.delegate performSelectorOnMainThread:@selector(postListLoaded) withObject:nil waitUntilDone:YES];
    [self saveThreadedCoreData];
}

-(void) saveThreadedCoreData {
        
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveCoreDataPosts) object:nil];
    [queue addOperation:operation];
        
}

-(void)updatedFeedWithNewPostsRSS {
    [Timer lapse:@"[PostList updatedFeedWithNewPostsRSS]: begin"];
    postsLoaded = YES;
    [self saveThreadedCoreData];
    [_posts sortUsingSelector:@selector(compareWithDate:)];
    [self.delegate performSelectorOnMainThread:@selector(postListUpdated) withObject:nil waitUntilDone:YES];
    [Timer lapse:@"[PostList updatedFeedWithNewPostsRSS]: end"];
}

-(void)failedFeedUpdateWithError:(NSError*)error {
    [self.delegate performSelectorOnMainThread:@selector(postListFailed) withObject:nil waitUntilDone:YES];
}

-(BOOL) listIsFiltered {
    return listFiltered;
}
-(NSDate*)getLastUpdate {
    return self.lastUpdate;
}

-(void) refreshPosts {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(refreshThreadedPosts) object:nil];
    [queue addOperation:operation];
    
}
-(void) refreshThreadedPosts {
    [Timer lapse:@"[PostList refreshThreadedPosts]: begin"];
    [rss loadFeedThenPerformAction:@selector(updatedFeedWithNewPostsRSS)];
    [Timer lapse:@"[PostList refreshThreadedPosts]: end"];
}

-(BOOL) doPostsExist {
    return postsLoaded;
}

-(void) searchPostsForString:(NSString*)search {

    [self.searchResults removeAllObjects];
    
    BOOL postValid;
    BOOL categoryValid;
    
    NSMutableArray *actualPosts;
    
    if (listFiltered) {
        actualPosts = [NSMutableArray arrayWithArray:self.filteredPosts];
    } else {
        actualPosts = [NSMutableArray arrayWithArray:_posts];
    }
    
    for (int i=0; i<[actualPosts count]; i++) {
        
        postValid = YES;
        categoryValid = YES;
        Post *thePost = (Post*)[actualPosts objectAtIndex:i]; 
        NSString *categories = [thePost getCategoriesAsString];
        NSRange range;
        range = [categories rangeOfString:search options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) {
            categoryValid = NO;
        }
        range = [thePost.title rangeOfString:search options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) {
            postValid = NO;
        }
        
        if (postValid || categoryValid) [self.searchResults addObject:thePost];        
        
    }
    
    //[self searchResultsSorted];
    
}

-(Post*) getPostWithSearchAtIndex:(NSInteger) index {
    return [self.searchResults objectAtIndex:index];
}

-(NSInteger) getSearchResultsCount {
    return [self.searchResults count];
}


@end
