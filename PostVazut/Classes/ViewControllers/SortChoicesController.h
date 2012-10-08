//
//  SortChoicesController.h
//  PostVazut
//
//  Created by Adrian Mihai on 5/15/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostList.h"

@interface SortChoicesController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    PostList *postList;
}
@property (retain, nonatomic) NSObject *delegate;
@property (retain, nonatomic) NSString *filterName;
@property (nonatomic) BOOL allowMultipleSelection;
@property (retain, nonatomic) NSMutableArray *chosenValues;
@property (retain, nonatomic) UITableView *tableView;

@end
