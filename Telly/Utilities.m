//
//  Utilities.m
//  Telly
//
//  Created by Gio Salinas on 28-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)validateString:(NSString *)string
{    
    if (string && ![string isEqual:[NSNull null]] && ![string isEqualToString:@""])
    {
        return string;
    }
    
    return @"No Information";
}

+ (BOOL)validateUrl:(NSString *)url
{
    NSURL *candidateURL = [NSURL URLWithString:url];

    if (candidateURL && candidateURL.scheme && candidateURL.host)
        return YES;
    
    return NO;
}

@end
