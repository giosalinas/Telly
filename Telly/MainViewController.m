//
//  MainViewController.m
//  Telly
//
//  Created by Gio Salinas on 26-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TrendingShowsViewController.h"
#import "FullScheduleViewController.h"
#import "SearchViewController.h"
#import "FavoritesViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) TrendingShowsViewController *trendingShowsVC;
@property (strong, nonatomic) FullScheduleViewController *fullScheduleVC;
@property (strong, nonatomic) SearchViewController *searchVC;
@property (strong, nonatomic) FavoritesViewController *favoriteVC;
@end

@implementation MainViewController

+ (instancetype)sharedInstance
{
    static MainViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance deckConfiguration];
    });
    
    return sharedInstance;
}

- (void)deckConfiguration
{
    // basic setup
    [self setElastic:NO];
    [self setLeftSize:182];
    [self setSizeMode:IIViewDeckViewSizeMode];
    
    self.openSlideAnimationDuration = 0.2f;
    self.closeSlideAnimationDuration = 0.2f;
    
    // config viewcontrollers
    self.trendingShowsVC = [[TrendingShowsViewController alloc] init];
    self.fullScheduleVC = [[FullScheduleViewController alloc] init];
    self.searchVC = [[SearchViewController alloc] init];
    self.favoriteVC = [[FavoritesViewController alloc] init];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:self.trendingShowsVC];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.selectedItem = TrendingShowsMenuItem;
    
    self.leftController = self.menuVC;
    self.centerController = navController;
}

#pragma mark - Actions

- (void)openMenuSection:(MenuItem)menuItem
{
    __block MainViewController *weakSelf = self;
    
    self.menuVC.selectedItem = menuItem;
    [self.menuVC.tableView reloadData];

    switch (menuItem) {
        case TrendingShowsMenuItem:
            [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:weakSelf.trendingShowsVC];
                controller.centerController = navController;
            }];
            break;
        case FullScheduleMenuItem:
            [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:weakSelf.fullScheduleVC];
                controller.centerController = navController;
            }];
            break;
        case SearchMenuItem:
            [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:weakSelf.searchVC];
                controller.centerController = navController;
            }];
            break;
        case FavoritesMenuItem:
            [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:weakSelf.favoriteVC];
                controller.centerController = navController;
            }];
        case ShowSelected:
            
        default:
            break;
    }
}

- (void)didPressSlideMenu
{
    self.isAnySideOpen ? [self closeLeftViewAnimated:YES] : [self openLeftViewAnimated:YES];
}

@end
