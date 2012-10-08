//
//  Gallery.h
//  Test6
//
//  Created by Adrian Mihai on 5/2/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PostItem;

@interface Gallery : NSManagedObject

@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) PostItem *post;

@end
