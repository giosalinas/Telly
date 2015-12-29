//
//  RequestManager.m
//  Telly
//
//  Created by Gio Salinas on 26-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <TBXML/TBXML.h>
#import "TBXML+NSDictionary.h"

#import "RequestManager.h"

@interface RequestManager ()
@property (strong, atomic) NSOperationQueue *operationQueue;
@end

@implementation RequestManager

+ (instancetype)sharedManager
{
    static id __sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.operationQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)requestTrendingShowsWithSuccessHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             andFailureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *string = [NSString stringWithFormat:@"http://guilmo.com/tvguide/showtrends.php"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            success(operation, responseObject);
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            failure(operation, error);
        });
        
    }];
    
    
    [self.operationQueue addOperation:operation];
}

- (void)requestFullScheduleWithSuccessHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            andFailureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *string = [NSString stringWithFormat:@"http://services.tvrage.com/feeds/fullschedule.php?country=US"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    // passing a NSData instead, to be use by TBXML
//    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            success(operation, [self parseXML:responseObject]);
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            failure(operation, error);
        });
        
    }];
    
    
    [self.operationQueue addOperation:operation];
}

- (void)requestDetailsForShow:(NSString *)show WithSuccessHandler:(void (^)(AFHTTPRequestOperation *, id))success andFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *friendlyShowName = [show stringByReplacingOccurrencesOfString:@" " withString:@"-"];

    NSString *string = [NSString stringWithFormat:@"http://guilmo.com/tvguide/getShowInfo.php?url=/m/shows/%@", friendlyShowName];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            success(operation, responseObject);
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            failure(operation, error);
        });
        
    }];
    
    
    [self.operationQueue addOperation:operation];
}

- (NSDictionary *)parseXML:(NSData *)xml
{
    NSAssert([xml isKindOfClass:[NSData class]], @"why u no data?");
    
    NSDictionary *fullSchedule = [TBXML xmlToDictionary:xml];
    
    return fullSchedule;
}

@end
