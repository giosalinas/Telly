//
//  ShowTableViewCell.h
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTableViewCell : UITableViewCell
- (void)setupCellWithTitle:(NSString *)title airingOn:(NSString *)channel withImgUrl:(NSString *)url;
@end
