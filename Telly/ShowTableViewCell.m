//
//  ShowTableViewCell.m
//  Telly
//
//  Created by Gio Salinas on 27-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "ShowTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Utilities.h"

@interface ShowTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *showChannel;
@end

@implementation ShowTableViewCell

- (void)setupCellWithTitle:(NSString *)title airingOn:(NSString *)channel withImgUrl:(NSString *)url
{
    [self.showTitle setText:[title uppercaseString]];

    NSString *airingOn = [NSString stringWithFormat:@"AIRING ON %@", [channel uppercaseString]];
    [self.showChannel setText:airingOn];
    
    if ([Utilities validateUrl:url])
        [self.showImageView setImageWithURL:[NSURL URLWithString:url]];
}

@end
