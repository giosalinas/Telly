//
//  MenuViewController.h
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    TrendingShowsMenuItem = 0,
    FullScheduleMenuItem,
    SearchMenuItem,
    FavoritesMenuItem,
    ShowSelected
}
typedef MenuItem;

@interface MenuViewController : UIViewController
@property (nonatomic) MenuItem selectedItem;
@property (strong, nonatomic) UITableView *tableView;
@end
