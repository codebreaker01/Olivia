//
//  WebServiceHelper.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "WebServiceHelper.h"
#import <AFNetworking/AFNetworking.h>

static NSString const * kLevelOneBaseURL = @"https://api.levelmoney.com/api/v2/hackathon/";
static NSString const * kNexmosBaseURL = @"";
static NSString const * kApiAiBaseURL = @"";

@implementation WebServiceHelper

+ (instancetype)sharedInstance {
    
    static WebServiceHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


#pragma mark - Level One API's

- (void)loginWithUsername:(NSString *)username password:(NSString *)password :(SuccessBlock)success failure:(FailureBlock)failure {


}

@end
