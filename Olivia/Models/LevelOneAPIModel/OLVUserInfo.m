//
//  OLVUserInfo.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVUserInfo.h"

@implementation OLVUserInfo

+ (instancetype)sharedInfo {
    
    static OLVUserInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)clearUserInfo {
    self.allTransactions = nil;
    self.accounts = nil;
    self.projectedTransactions = nil;
    self.dayBalances = nil;
}

@end
