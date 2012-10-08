//
//  CheckboxControl.m
//  Test6
//
//  Created by Adrian Mihai on 4/28/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import "CheckboxControl.h"

@implementation CheckboxControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        normalImage = [UIImage imageNamed: @"cell_checkbox_off.png"];
        selectedImage = [UIImage imageNamed: @"cell_checkbox_on.png"];
        imageView = [[UIImageView alloc] initWithImage: normalImage];
        [self addSubview: imageView];
        selected = NO;
    }
    return self;
}

- (void) setChecked:(BOOL) status {
    selected = status;
    if (selected) {
        imageView.image = selectedImage;
    } else {
        imageView.image = normalImage;
    }
}

- (BOOL) getChecked {
    return selected;
}

- (BOOL) toggle
{
    selected = !selected;
    imageView.image = (selected ? selectedImage : normalImage); 
    if (selected) {
        NSLog(@"toggled on");
    } else {
        NSLog(@"toggled off");
    }
    return selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
