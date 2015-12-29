//
//  ShowDetailViewController.m
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "Utilities.h"

#import "ShowDetailViewController.h"

#import "ShowDetailTableViewCell.h"
#import "ScheduleTableViewCell.h"

#import "MainViewController.h"
#import "RequestManager.h"

@interface ShowDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *showInfo;
@property (strong, nonatomic) NSArray *listings;
@property (strong, nonatomic) NSString *showName;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ShowDetailViewController

- (id)initWithShowName:(NSString *)show
{
    self = [super init];
    if (self != nil)
    {
        self.showName = show;
    }
    return self;
}

#pragma mark - View Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self configTableView];
    [self loadDataForShow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
}

#pragma mark - Configuration

- (void)configTableView
{
    CGRect frame = self.view.frame;
    frame.size.height -= 44;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"showDetailIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"showScheduleIdentifier"];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"SHOW";
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

- (void)loadDataForShow
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    __block ShowDetailViewController *weakSelf = self;
    
    RequestManager *manager = [RequestManager sharedManager];
    
    [manager requestDetailsForShow:self.showName WithSuccessHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view addSubview:weakSelf.tableView];
            weakSelf.showInfo = responseObject;
            weakSelf.listings = [weakSelf.showInfo objectForKey:@"listings"] ? [weakSelf.showInfo objectForKey:@"listings"] : nil;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listings count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > 0)
    {
        NSDictionary *showTimes = [[self.listings[section-1] objectForKey:@"showTimes"] objectAtIndex:0];
        return [showTimes count];
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0)
        return 60;

    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    if (section > 0)
        return 25;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        
        CGRect frameHeader = CGRectMake(0, 0, self.tableView.frame.size.width, 25);
        CGRect frameLabel = CGRectMake(20, 0, self.tableView.frame.size.width-20, 25);

        UIView *viewHeader = [[UIView alloc] initWithFrame:frameHeader];
        viewHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        viewHeader.backgroundColor = [UIColor redColor];
        
        UILabel *sectionText = [[UILabel alloc] initWithFrame:frameLabel];
        sectionText.backgroundColor = [UIColor redColor];
        sectionText.textColor = [UIColor whiteColor];
        sectionText.font = [UIFont fontWithName:@"PunkRockShow-Regular" size:19];
        
        NSDictionary *listing = self.listings[section-1];
        
        NSString *day = [Utilities validateString:[listing objectForKey:@"day"]];
        sectionText.text = [day uppercaseString];
        
        [viewHeader addSubview:sectionText];
        return viewHeader;
    }
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier;
    
    if (indexPath.section == 0)
    {
        cellIdentifier = @"showDetailIdentifier";
        
        ShowDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[ShowDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        NSString *title = [Utilities validateString:[self.showInfo objectForKey:@"name"]];
        NSString *channel = [Utilities validateString:[self.showInfo objectForKey:@"air"]];
        NSString *url = [Utilities validateString:[self.showInfo objectForKey:@"img"]];
        NSString *description = [Utilities validateString:[self.showInfo objectForKey:@"info"]];
        BOOL hasListingInfo = [[self.showInfo objectForKey:@"listings"] count] > 0;
        
        if (!hasListingInfo)
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [cell setupCellWithTitle:title airingOn:channel withDescription:description withImgUrl:url andListing:hasListingInfo];
        
        return cell;
    }
    else
    {
        cellIdentifier = @"showScheduleIdentifier";
        
        ScheduleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[ScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        NSDictionary *showTimes = [[[self.listings[indexPath.section-1] objectForKey:@"showTimes"] objectAtIndex:0] objectAtIndex:indexPath.item];
        NSString *title = [Utilities validateString:[showTimes objectForKey:@"info"]];
        NSString *time = [Utilities validateString:[showTimes objectForKey:@"time"]];
        BOOL isAM = [[Utilities validateString:[showTimes objectForKey:@"ampm"]] isEqualToString:@"am"];
        
        [cell setupCellWithTitle:title time:time isAM:isAM];
        
        return cell;
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
