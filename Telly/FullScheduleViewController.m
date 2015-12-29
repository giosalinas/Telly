//
//  FullScheduleViewController.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>
#import "Utilities.h"

#import "FullScheduleViewController.h"
#import "MainViewController.h"
#import "ScheduleTableViewCell.h"
#import "RequestManager.h"

@interface FullScheduleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *scheduleData;
@end

@implementation FullScheduleViewController

#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigationBar];
    if ([self.scheduleData count] < 1)
        [self loadData];
}

#pragma mark - Configuration Controller

- (void)configNavigationBar
{
    self.navigationItem.title = @"FULL SCHEDULE";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"PunkRockShow-Regular" size:22.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBlue"] forBarMetrics:UIBarMetricsDefault];
    
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

- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"scheduleIdentifier"];    
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    __block FullScheduleViewController *weakSelf = self;
    
    RequestManager *manager = [RequestManager sharedManager];
    
    [manager requestFullScheduleWithSuccessHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf generateShowsDataFromDictionary:responseObject];
            [weakSelf.tableView reloadData];
            [weakSelf.view addSubview:weakSelf.tableView];
            [hud hide:YES];
        });
        
    } andFailureHandler:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [weakSelf.tableView removeFromSuperview];
         [hud hide:YES];
     }];
}

- (void)generateShowsDataFromDictionary:(NSDictionary *)info
{
    self.scheduleData = [NSMutableArray new];
    
    for (NSDictionary *fullSchedule in info[@"schedule"][@"DAY"])
    {
        NSMutableDictionary *schedule = [NSMutableDictionary new];
        NSArray *timeline = [fullSchedule allValues];

        [schedule setValue:timeline[0] forKey:@"date"];

        NSMutableArray *shows = [NSMutableArray new];
        for (NSDictionary *times in [timeline objectAtIndex:1])
        {
            if ([times isKindOfClass:[NSString class]]) // "time attribute" grouped
            {
                for (NSDictionary *show in [timeline objectAtIndex:1][@"show"])
                {
                    if ([show isKindOfClass:[NSString class]]) // has just one show but nested
                    {
                        NSMutableDictionary *newShow = [NSMutableDictionary new];
                        [newShow setValue:[timeline objectAtIndex:1][@"attr"] forKey:@"time"];
                        [newShow setValue:[timeline objectAtIndex:1][@"show"][@"name"] forKey:@"title"];
                        [newShow setValue:[timeline objectAtIndex:1][@"show"][@"network"] forKey:@"channel"];
                        
                        [shows addObject:newShow];
                        break;
                    }
                    
                    NSMutableDictionary *newShow = [NSMutableDictionary new];
                    [newShow setValue:[timeline objectAtIndex:1][@"attr"] forKey:@"time"];
                    [newShow setValue:show[@"name"] forKey:@"title"];
                    [newShow setValue:show[@"network"] forKey:@"channel"];
                    
                    [shows addObject:newShow];
                }
            }
            else
            {
                if ([times[@"show"] isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *newShow = [NSMutableDictionary new];
                    [newShow setValue:times[@"attr"] forKey:@"time"];
                    [newShow setValue:times[@"show"][@"name"] forKey:@"title"];
                    [newShow setValue:times[@"show"][@"network"] forKey:@"channel"];
                    
                    [shows addObject:newShow];
                }
                else if ([times[@"show"] isKindOfClass:[NSArray class]]) // has multiple shows
                {
                    for (NSDictionary *show in times[@"show"])
                    {
                        if ([show isKindOfClass:[NSString class]]) // checking link attribute
                            continue;
                        
                        NSMutableDictionary *newShow = [NSMutableDictionary new];
                        [newShow setValue:times[@"attr"] forKey:@"time"];
                        [newShow setValue:show[@"name"] forKey:@"title"];
                        [newShow setValue:show[@"network"] forKey:@"channel"];
                        
                        [shows addObject:newShow];
                    }
                }
            }
            

        }

        [schedule setValue:shows forKey:@"shows"];
        [self.scheduleData addObject:schedule];
    }
    
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.scheduleData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.scheduleData objectAtIndex:section] objectForKey:@"shows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frameHeader = CGRectMake(0, 0, self.tableView.frame.size.width, 25);
    CGRect frameLabel = CGRectMake(20, 0, self.tableView.frame.size.width-20, 25);
    
    UIColor *headerColor = [UIColor colorWithRed:0.1882 green:0.5294 blue:0.7529 alpha:1.0];
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:frameHeader];
    viewHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    viewHeader.backgroundColor = headerColor;
    
    UILabel *sectionText = [[UILabel alloc] initWithFrame:frameLabel];
    sectionText.backgroundColor = headerColor;
    sectionText.textColor = [UIColor whiteColor];
    sectionText.font = [UIFont fontWithName:@"PunkRockShow-Regular" size:19];
    
    NSString *day = [Utilities validateString:[[self.scheduleData objectAtIndex:section] objectForKey:@"date"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *originalDate   =  [dateFormatter dateFromString:day];
    
    [dateFormatter setDateFormat:@"cccc dd LLLL yyyy"];
    NSString *finalString = [dateFormatter stringFromDate:originalDate];
    
    sectionText.text = [finalString uppercaseString];
    
    [viewHeader addSubview:sectionText];
    return viewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"scheduleIdentifier";
    
    ScheduleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[ScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *show = [[[self.scheduleData objectAtIndex:indexPath.section] objectForKey:@"shows"] objectAtIndex:indexPath.item];
    

    
    NSString *title = [Utilities validateString:[show objectForKey:@"title"]];
    NSString *channel = [Utilities validateString:[show objectForKey:@"channel"]];
    NSString *time = [Utilities validateString:[show objectForKey:@"time"]];
    
    [cell setupCellWithTitle:title airingOn:channel time:time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
