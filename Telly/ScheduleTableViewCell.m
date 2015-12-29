//
//  ScheduleTableViewCell.m
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@interface ScheduleTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showChannel;
@property (strong, nonatomic) IBOutlet UILabel *showTime;
@property (strong, nonatomic) IBOutlet UILabel *showScheduleSystem;
@end

@implementation ScheduleTableViewCell

- (void)setupCellWithTitle:(NSString *)title airingOn:(NSString *)channel time:(NSString *)time
{
    // from xml
    
    [self.showTitle setText:[title uppercaseString]];
    
    NSString *airingOn = [NSString stringWithFormat:@"AIRING ON %@", [channel uppercaseString]];
    [self.showChannel setText:airingOn];
    
    // setting time
    NSArray *timeSeparator = [time componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *hourTime = timeSeparator[0];
    BOOL isAM = [timeSeparator[1] isEqualToString:@"am"];
    
    [self.showTime setText:[[hourTime uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@" "]];
    [self.showScheduleSystem setText:isAM ? @"AM" : @"PM"];
}

- (void)setupCellWithTitle:(NSString *)title time:(NSString *)time isAM:(BOOL)am
{
    // from json
    
    [self.showTitle setText:[title uppercaseString]];
    
    [self.showTime setText:[[time uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@" "]];
    
    [self.showScheduleSystem setText:am ? @"AM" : @"PM"];
    
    [self.showChannel setHidden:YES];
}

@end
