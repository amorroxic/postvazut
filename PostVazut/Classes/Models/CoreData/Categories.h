//
//  Categories.h
//  Test6
//
//  Created by Adrian Mihai on 5/2/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PostItem;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addPostsObject:(PostItem *)value;
- (void)removePostsObject:(PostItem *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;
@end
