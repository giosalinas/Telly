//
//  MainViewController.h
//  Telly
//
//  Created by Gio Salinas on 26-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "IIViewDeckController.h"

@interface MainViewController : IIViewDeckController
+ (instancetype)sharedInstance;
- (void)openMenuSection:(MenuItem)menuItem;
- (void)didPressSlideMenu;
@end
