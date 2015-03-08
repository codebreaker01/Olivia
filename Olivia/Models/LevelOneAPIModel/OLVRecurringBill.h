//
//  OLVRecurringBill.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLVRecurringBill : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *merchant;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *rawMerchant;

@end
