//
//  OLVUserInfo.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLVAccount.h"

@interface OLVUserInfo : NSObject

+ (instancetype)sharedInfo;
- (void)clearUserInfo;

@property (nonatomic) double monthlyIncome;
@property (nonatomic) OLVAccount *account;
@property (nonatomic) NSArray *allTransactions;
@property (nonatomic) NSArray *accounts;
@property (nonatomic) NSArray *projectedTransactions;
@property (nonatomic) NSArray *dayBalances;
@property (nonatomic) NSArray *recurringBills;
@property (nonatomic) NSArray *goals;

- (double)getIncomeForMonth:(NSDate *)date;
- (double)getExpenseForMonth:(NSDate *)date;

- (double)spendableAmount;
- (double)whatsLeftAmount:(NSDate *)date;

- (NSArray *)getExpensesForMerchant:(NSString *)merchant aroundAmount:(NSString *)amount;

@end
