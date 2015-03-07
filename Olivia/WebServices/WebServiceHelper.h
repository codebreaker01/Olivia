//
//  WebServiceHelper.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id);
typedef void (^FailureBlock)(id,NSError *);

@interface WebServiceHelper : NSObject

-(instancetype) init __attribute__((unavailable("init not available")));
+ (instancetype)sharedInstance;

// Level Money API's
- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)getAccounts:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)getAllTransactions:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)getProjectedTransactions:(NSDate *)date success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)getSimilarTransactions:(NSArray *)transactions success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
