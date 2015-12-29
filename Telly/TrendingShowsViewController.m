//
//  TrendingShowsViewController.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "Utilities.h"

#import "TrendingShowsViewController.h"
#import "ShowTableViewCell.h"
#import "ShowDetailViewController.h"

#import "MainViewController.h"
#import "RequestManager.h"

@interface TrendingShowsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *showsData;
@end

@implementation TrendingShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configTableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
}

#pragma mark - Config Controller

- (void)configTableView
{
    CGRect frame = self.view.frame;
    frame.size.height -= 44;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    [self.tableView registerNib:[UINib nibWithNibName:@"ShowTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"showIdentifier"];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"TRENDING SHOWS";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"PunkRockShow-Regular" size:22.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarRed"] forBarMetrics:UIBarMetricsDefault];
    
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

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    __block TrendingShowsViewController *weakSelf = self;
    
    RequestManager *manager = [RequestManager sharedManager];
    
    [manager requestTrendingShowsWithSuccessHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view addSubview:weakSelf.tableView];
            weakSelf.showsData = responseObject;
            [hud hide:YES];
            [weakSelf.tableView reloadData];
        });
        
    } andFailureHandler:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [weakSelf.tableView removeFromSuperview];
         [hud hide:YES];
     }];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"showIdentifier";
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *title = [Utilities validateString:[self.showsData[indexPath.item] objectForKey:@"name"]];
    NSString *channel = [Utilities validateString:[self.showsData[indexPath.item] objectForKey:@"air"]];
    NSString *url = [Utilities validateString:[self.showsData[indexPath.item] objectForKey:@"img"]];

    [cell setupCellWithTitle:title airingOn:channel withImgUrl:url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowDetailViewController *showDetail = [[ShowDetailViewController alloc] initWithShowName:[self.showsData[indexPath.item] objectForKey:@"name"]];
    
    MainViewController *deck = [MainViewController sharedInstance];
    [deck openMenuSection:ShowSelected];
    
    [self.navigationController pushViewController:showDetail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
