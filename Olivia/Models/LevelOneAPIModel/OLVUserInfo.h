//
//  OLVUserInfo.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLVUserInfo : NSObject

+ (instancetype)sharedInfo;
- (void)clearUserInfo;

@property (nonatomic) NSArray *allTransactions;
@property (nonatomic) NSArray *accounts;
@property (nonatomic) NSArray *projectedTransactions;
@property (nonatomic) NSArray *dayBalances;

@end
