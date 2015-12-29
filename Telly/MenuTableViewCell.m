//
//  MenuTableViewCell.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.origin = CGPointMake(0, 0);
    self.imageView.frame = frame;
}

@end
