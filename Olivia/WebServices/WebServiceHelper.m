//
//  WebServiceHelper.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVAccounts.h"
#import "OLVUserInfo.h"
#import "OLVDayBalances.h"
#import "OLVTransaction.h"
#import "OLVTransactions.h"
#import "OLVSimilarTransactions.h"

#import "WebServiceHelper.h"
#import <AFNetworking/AFNetworking.h>


static NSString * const kLevelOneBaseURL = @"https://api.levelmoney.com/api/v2/hackathon";
static NSString * const kNexmosBaseURL = @"";
static NSString * const kApiAiBaseURL = @"";

static NSString const * levelOneAPIToken = @"HackathonApiToken";

@interface WebServiceHelper ()

@property (nonatomic) AFURLSessionManager *levelOneSessionManager;
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSString *token;


@end

@implementation WebServiceHelper

+ (instancetype)sharedInstance {
    
    static WebServiceHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance setUpNetworkManagers];
    });
    return instance;
}

- (void)setUpNetworkManagers {

    // Initialize Level One Session Configuration
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.levelOneSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    [self.levelOneSessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
}

- (void)clearLoginTokens {
    self.uid = NSNotFound;
    self.token = nil;
}

- (NSDictionary *)tokenDictionary {
    return @{ @"args" : @{
                            @"uid"       : [NSNumber numberWithInteger:self.uid],
                            @"token"     : self.token,
                            @"api-token" : levelOneAPIToken
                         }
            };
}

- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return manager;
}

#pragma mark - Level Money API's

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSDictionary *parameters = @{@"email" : username,
                                 @"password" : password
                                 };
    [manager POST:[NSString stringWithFormat:@"%@/login",kLevelOneBaseURL] parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
                        [self clearLoginTokens];
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *loginTokens = (NSDictionary *)responseObject;
                            if ([loginTokens objectForKey:@"uid"]) {
                                self.uid = [loginTokens[@"uid"] integerValue];
                            }
                            if ([loginTokens objectForKey:@"token"]) {
                                self.token = loginTokens[@"token"];
                            }
                        }
                        if (success) {
                              success(responseObject);
                        }
                    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
    }];
}

- (void)getAccounts:(SuccessBlock)success failure:(FailureBlock)failure {
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:[NSString stringWithFormat:@"%@/get-accounts",kLevelOneBaseURL]
       parameters:[self tokenDictionary]
          success:^(NSURLSessionDataTask *task, id responseObject) {
                            OLVAccounts *accounts;
                            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                accounts = [OLVAccounts modelObjectWithDictionary:responseObject];
                            }
              if (success) {
                  success(responseObject);
              }
                        }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
    }];
}

- (void)getAllTransactions:(SuccessBlock)success failure:(FailureBlock)failure {
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:[NSString stringWithFormat:@"%@/get-all-transactions",kLevelOneBaseURL]
       parameters:[self tokenDictionary]
          success:^(NSURLSessionDataTask *task, id responseObject) {
                        OLVTransactions *transactions;
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            transactions = [OLVTransactions modelObjectWithDictionary:responseObject];
                        }
                        if (success) {
                              success(transactions.transactions);
                        }
                    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
    }];
}

- (void)getProjectedTransactions:(NSDate *)date success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    [requestParams setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
    [requestParams setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
    [requestParams addEntriesFromDictionary:[self tokenDictionary]];
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:[NSString stringWithFormat:@"%@/projected-transactions-for-month",kLevelOneBaseURL]
       parameters:requestParams
          success:^(NSURLSessionDataTask *task, id responseObject) {
              OLVTransactions *transactions;
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  transactions = [OLVTransactions modelObjectWithDictionary:responseObject];
              }
              if (success) {
                  success(transactions.transactions);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
          }];
}

- (void)getDayBalances:(NSDate *)date success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    [requestParams setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
    [requestParams setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
    [requestParams addEntriesFromDictionary:[self tokenDictionary]];
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:[NSString stringWithFormat:@"%@/balances",kLevelOneBaseURL]
       parameters:requestParams
          success:^(NSURLSessionDataTask *task, id responseObject) {
              OLVDayBalances *dayBalances;
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  dayBalances = [OLVDayBalances modelObjectWithDictionary:responseObject];
              }
              if (success) {
                  success(dayBalances.days);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
          }];
}

- (void)getSimilarTransactions:(NSArray *)transactions success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    [requestParams setObject:transactions forKey:@"transaction-ids"];
    [requestParams addEntriesFromDictionary:[self tokenDictionary]];
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:[NSString stringWithFormat:@"%@/find-similar-transactions",kLevelOneBaseURL]
       parameters:requestParams
          success:^(NSURLSessionDataTask *task, id responseObject) {
              
              NSArray *transactionIds;
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  transactionIds = responseObject[@"transaction-ids"];
              }
              
              if ([OLVUserInfo sharedInfo].allTransactions.count > 0 && transactionIds.count > 0) {
                  NSMutableArray *array = [NSMutableArray new];
                  for (NSString *transactionId in transactionIds) {
                      for (OLVTransaction *transaction in [OLVUserInfo sharedInfo].allTransactions) {
                          if ([transactionId isEqualToString:transaction.transactionId]) {
                              [array addObject:transaction];
                          }
                      }
                  }
                  if (success) {
                      success(array);
                  }
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(task,error);
              }
          }];
}

@end
