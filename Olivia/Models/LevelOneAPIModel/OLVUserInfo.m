//
//  OLVUserInfo.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVGoals.h"
#import "OLVUserInfo.h"
#import "OLVTransaction.h"
#import "OLVRecurringBill.h"

@interface OLVUserInfo ()

- (void)fakeIncome;
- (void)fakeRecurringBills;
- (void)fakeGoals;

@end

@implementation OLVUserInfo

+ (instancetype)sharedInfo {
    
    static OLVUserInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance fakeEverything];
    });
    return instance;
}

- (void)fakeEverything {
    [self fakeGoals];
    [self fakeIncome];
    [self fakeRecurringBills];
}

- (void)fakeIncome {
    self.monthlyIncome = 6500;
}

- (void)addGoal:(OLVGoals *)goal
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.goals];
    [array addObject:goal];
    self.goals = array;
}

- (void)addRecurringBills:(OLVRecurringBill *)bill
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.recurringBills];
    [array addObject:bill];
    self.recurringBills = array;
}

- (void)fakeGoals {
    
    OLVGoals *goal1 = [[OLVGoals alloc] init];
    goal1.name = @"Trip to Spain";
    goal1.amount = 5000;
    goal1.timePeriod = 6;
    
    OLVGoals *goal2 = [[OLVGoals alloc] init];
    goal2.name = @"Buy Apple Watch";
    goal2.amount = 350;
    goal2.timePeriod = 3;
    
    OLVGoals *goal3 = [[OLVGoals alloc] init];
    goal3.name = @"Go to Haiwaii";
    goal3.amount = 2000;
    goal3.timePeriod = 6;

    self.goals = @[goal1, goal2, goal3];
    
}

- (void)fakeRecurringBills {
    
    OLVRecurringBill *bill1 = [[OLVRecurringBill alloc] init];
    bill1.merchant = @"GIEKO Insurance";
    bill1.amount = 200;
    
    OLVRecurringBill *bill2 = [[OLVRecurringBill alloc] init];
    bill1.merchant = @"Mortgage";
    bill1.amount = 2500;
    
    OLVRecurringBill *bill3 = [[OLVRecurringBill alloc] init];
    bill1.merchant = @"PGE";
    bill1.amount = 45;

    OLVRecurringBill *bill4 = [[OLVRecurringBill alloc] init];
    bill1.merchant = @"Comcast";
    bill1.amount = 60;
    
    self.recurringBills = @[bill1, bill2, bill3, bill4];
}

- (double)spendableAmount {
    
    double monthlyIncome = self.monthlyIncome;
    for (OLVGoals *goal in self.goals) {
        monthlyIncome = monthlyIncome - goal.amount/goal.timePeriod;
    }
    
    for (OLVRecurringBill *recurringBill in self.recurringBills) {
        monthlyIncome = monthlyIncome - recurringBill.amount;
    }
    return monthlyIncome;
}

- (double)whatsLeftAmount:(NSDate *)date
{
    double amount = [self getExpenseForMonth:date];
    return [self spendableAmount] - amount;
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
