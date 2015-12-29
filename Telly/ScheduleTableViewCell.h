//
//  ScheduleTableViewCell.h
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell
- (void)setupCellWithTitle:(NSString *)title time:(NSString *)time isAM:(BOOL)am;
- (void)setupCellWithTitle:(NSString *)title airingOn:(NSString *)channel time:(NSString *)time;
@end
