//
//  SortChoicesCell.m
//  PostVazut
//
//  Created by Adrian Mihai on 5/15/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import "SortChoicesCell.h"

@implementation SortChoicesCell
@synthesize isSelected = _isSelected;
@synthesize label = _label;
@synthesize checkbox = _checkbox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
