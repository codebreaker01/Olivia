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
#import <ElastiCode/ElastiCode.h>
#import "NSString+Olivia.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(sessionStarted)
                                                 name: ELASTICODE_SESSION_STARTED
                                               object: nil];
    // Register (listen) to local notification when session restarted
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(sessionStarted)
                                                 name: ELASTICODE_SESSION_RESTARTED
                                               object: nil];

    [self fakeGoals];
    [self fakeIncome];
    [self fakeRecurringBills];
}

- (void)fakeIncome {
    self.monthlyIncome = 7500;
}

- (void)sessionStarted {
    
    NSString *userType = (NSString *)[ElastiCode valueForDynamicObject:@"userType"];
    if ([userType isEqualToString:@"relaxedUser"]) {
        self.monthlyIncome = 15000;
    } else if ([userType isEqualToString:@"comfortableUser"]) {
        self.monthlyIncome = 11000;
    } else if ([userType isEqualToString:@"midUser"]) {
        self.monthlyIncome = 9000;
    } else if ([userType isEqualToString:@"strugglingUser"]) {
        self.monthlyIncome = 7500;
    }
}

- (void)sessionRestartedNotification {
    
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
    goal1.amount = 3000;
    goal1.timePeriod = 6;
    
    OLVGoals *goal2 = [[OLVGoals alloc] init];
    goal2.name = @"Buy Apple Watch";
    goal2.amount = 350;
    goal2.timePeriod = 3;
    
    OLVGoals *goal3 = [[OLVGoals alloc] init];
    goal3.name = @"Go to Haiwaii";
    goal3.amount = 1500;
    goal3.timePeriod = 6;

    self.goals = @[goal1, goal2, goal3];
    
}

- (void)fakeRecurringBills {
    
    OLVRecurringBill *bill1 = [[OLVRecurringBill alloc] init];
    bill1.merchant = @"GIEKO Insurance";
    bill1.amount = 200;
    
    OLVRecurringBill *bill3 = [[OLVRecurringBill alloc] init];
    bill3.merchant = @"PGE";
    bill3.amount = 45;

    OLVRecurringBill *bill4 = [[OLVRecurringBill alloc] init];
    bill4.merchant = @"Comcast";
    bill4.amount = 60;
    
    self.recurringBills = @[bill1, bill3, bill4];
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

- (NSArray *)getExpensesForMerchant:(NSString *)merchant aroundAmount:(NSString *)amount {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (OLVTransaction *transaction in self.allTransactions) {
        if ([transaction.merchant localizedCaseInsensitiveContainsString:merchant]) {
                [array addObject:transaction];
        }
    }
    return array;
}

- (NSArray *)getFakeExpensesForMerchant:(NSString *)merchant aroundAmount:(NSString *)amount {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (OLVTransaction *transaction in self.allTransactions) {
        if ([merchant soundsLikeString:transaction.merchant]) {
            [array addObject:transaction];
        }
    }
    return array;
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
