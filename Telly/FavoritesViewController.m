//
//  FavoritesViewController.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright © 2015 Gio Salinas. All rights reserved.
//

#import "FavoritesViewController.h"
#import "MainViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"MY FAVORITES";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"PunkRockShow-Regular" size:22.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarOrange"] forBarMetrics:UIBarMetricsDefault];
    
    MainViewController *deck = [MainViewController sharedInstance];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton addTarget:deck action:@selector(didPressSlideMenu) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"hamburguerIconWhite"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
