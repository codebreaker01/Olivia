//
//  OLVTransaction.h
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OLVTransaction : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *transactionTime;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) BOOL isPending;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *merchant;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *rawMerchant;
@property (nonatomic, strong) NSDate *transactionDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
