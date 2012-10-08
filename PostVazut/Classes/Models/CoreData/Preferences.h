//
//  Preferences.h
//  Test6
//
//  Created by Adrian Mihai on 5/3/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preferences : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * type;

@end
