//
//  Utilities.h
//  Telly
//
//  Created by Gio Salinas on 28-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+ (NSString *)validateString:(NSString *)string;
+ (BOOL)validateUrl:(NSString *)url;
@end
