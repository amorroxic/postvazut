//
//  CheckboxControl.h
//  Test6
//
//  Created by Adrian Mihai on 4/28/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckboxControl : UIControl {
    BOOL selected;
    UIImageView *imageView;
    UIImage *normalImage;
    UIImage *selectedImage;
}
- (void) setChecked:(BOOL) status;
- (BOOL) getChecked;
- (BOOL) toggle;

@end
