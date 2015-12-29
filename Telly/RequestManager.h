//
//  RequestManager.h
//  Telly
//
//  Created by Gio Salinas on 26-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface RequestManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTrendingShowsWithSuccessHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           andFailureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)requestFullScheduleWithSuccessHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             andFailureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)requestDetailsForShow:(NSString *)show WithSuccessHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            andFailureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
