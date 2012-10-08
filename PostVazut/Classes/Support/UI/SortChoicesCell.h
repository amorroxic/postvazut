//
//  SortChoicesCell.h
//  PostVazut
//
//  Created by Adrian Mihai on 5/15/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortChoicesCell : UITableViewCell
@property (nonatomic) NSString *isSelected;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *checkbox;

@end
