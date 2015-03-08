//
//  OLVUserInfo.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVUserInfo.h"
#import "OLVTransaction.h"

@implementation OLVUserInfo

+ (instancetype)sharedInfo {
    
    static OLVUserInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (double)getIncomeForMonth:(NSDate *)date {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *toDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (OLVTransaction *transaction in self.allTransactions) {
        if ([self date:transaction.transactionDate isBetweenDate:date andDate:toDate]) {
            if (transaction.amount > 0) {
             [array addObject:transaction];
            }
        }
    }
    
    double amount = 0;
    for (OLVTransaction *transaction in array) {
        amount += transaction.amount;
    }
    return amount/10000.0;
}

- (double)getExpenseForMonth:(NSDate *)date {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *toDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (OLVTransaction *transaction in self.allTransactions) {
        if ([self date:transaction.transactionDate isBetweenDate:date andDate:toDate]) {
            if (transaction.amount < 0) {
                [array addObject:transaction];
            }
        }
    }
    
    double amount = 0;
    for (OLVTransaction *transaction in array) {
        amount += transaction.amount;
    }
    return -1 * (amount/10000.0);
}


- (void)clearUserInfo {
    self.allTransactions = nil;
    self.accounts = nil;
    self.projectedTransactions = nil;
    self.dayBalances = nil;
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
