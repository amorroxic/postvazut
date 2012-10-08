//
//  PostItem.h
//  Test6
//
//  Created by Adrian Mihai on 5/2/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PostItem : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * imdb;
@property (nonatomic, retain) NSString * metacritic;
@property (nonatomic, retain) NSString * rottentomatoes;
@property (nonatomic, retain) NSSet *gallery;
@property (nonatomic, retain) NSSet *trailers;
@property (nonatomic, retain) NSSet *categories;
@end

@interface PostItem (CoreDataGeneratedAccessors)

- (void)addGalleryObject:(NSManagedObject *)value;
- (void)removeGalleryObject:(NSManagedObject *)value;
- (void)addGallery:(NSSet *)values;
- (void)removeGallery:(NSSet *)values;
- (void)addTrailersObject:(NSManagedObject *)value;
- (void)removeTrailersObject:(NSManagedObject *)value;
- (void)addTrailers:(NSSet *)values;
- (void)removeTrailers:(NSSet *)values;
- (void)addCategoriesObject:(NSManagedObject *)value;
- (void)removeCategoriesObject:(NSManagedObject *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;
@end
