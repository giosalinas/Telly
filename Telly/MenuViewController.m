//
//  MenuViewController.m
//  Telly
//
//  Created by Gio Salinas on 25-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "MainViewController.h"

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation MenuViewController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    CGRect frame = self.view.frame;
    frame.size.width = 139;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? 139 : 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    if (indexPath.section == 0)
        cellIdentifier = @"MenuCell";
    else
        cellIdentifier = @"versionCell";
    
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (indexPath.section == 0)
    {
        switch (indexPath.item)
        {
            case TrendingShowsMenuItem:
                if (self.selectedItem == TrendingShowsMenuItem)
                  cell.imageView.image = [UIImage imageNamed:@"TrendingShowsItemSelected"];
                else
                  cell.imageView.image = [UIImage imageNamed:@"TrendingShowsItem"];
                break;
            case FullScheduleMenuItem:
                if (self.selectedItem == FullScheduleMenuItem)
                    cell.imageView.image = [UIImage imageNamed:@"FullScheduleItemSelected"];
                else
                    cell.imageView.image = [UIImage imageNamed:@"FullScheduleItem"];
                break;
            case SearchMenuItem:
                if (self.selectedItem == SearchMenuItem)
                    cell.imageView.image = [UIImage imageNamed:@"SearchItemSelected"];
                else
                    cell.imageView.image = [UIImage imageNamed:@"SearchItem"];
                break;
            case FavoritesMenuItem:
                if (self.selectedItem == FavoritesMenuItem)
                    cell.imageView.image = [UIImage imageNamed:@"FavoritesItemSelected"];
                else
                    cell.imageView.image = [UIImage imageNamed:@"FavoritesItem"];
                break;
            default:
                break;
        }
        
    }
    else
    {   cell.backgroundColor = [UIColor redColor];
        cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:9.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"version 1.0";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedItem == indexPath.item)
        return;
    
    MainViewController *deck = [MainViewController sharedInstance];
    [deck openMenuSection:(int)indexPath.item];
    
    [self.tableView reloadData];
}

- (CGSize)preferredContentSize
{
    [self.tableView layoutIfNeeded];
    return self.tableView.contentSize;
}

@end
