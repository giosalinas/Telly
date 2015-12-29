//
//  ShowDetailTableViewCell.m
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Utilities.h"

#import "ShowDetailTableViewCell.h"

@interface ShowDetailTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showChannel;
@property (strong, nonatomic) IBOutlet UILabel *showDescription;
@property (strong, nonatomic) IBOutlet UILabel *showListing;
@end

@implementation ShowDetailTableViewCell

- (void)setupCellWithTitle:(NSString *)title airingOn:(NSString *)channel withDescription:(NSString *)description withImgUrl:(NSString *)url andListing:(BOOL)listing
{
    if ([Utilities validateUrl:url])
        [self.showImageView setImageWithURL:[NSURL URLWithString:url]];

    [self.showTitle setText:[title uppercaseString]];
    
    NSString *airingOn = [NSString stringWithFormat:@"AIRING ON %@", [channel uppercaseString]];
    [self.showChannel setText:airingOn];
    
    [self.showDescription setText:[description uppercaseString]];
    [self.showDescription sizeToFit];
    
    [self.showListing setText:listing ? @"SHOW LISTINGS" : @"NO LISTINGS INFORMATION"];
}


@end
