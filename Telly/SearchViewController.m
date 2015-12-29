//
//  SearchViewController.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright © 2015 Gio Salinas. All rights reserved.
//

#import "SearchViewController.h"
#import "MainViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"SEARCH FOR SHOWS";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"PunkRockShow-Regular" size:22.0], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5216 green:0.6157 blue:0.2039 alpha:1.0]};
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarWhite"] forBarMetrics:UIBarMetricsDefault];
    
    MainViewController *deck = [MainViewController sharedInstance];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton addTarget:deck action:@selector(didPressSlideMenu) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"hamburguerIconGreen"];
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
