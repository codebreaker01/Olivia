//
//  OLVTransaction.m
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVTransaction.h"


NSString *const kOLVTransactionTransactionTime = @"transaction-time";
NSString *const kOLVTransactionAmount = @"amount";
NSString *const kOLVTransactionIsPending = @"is-pending";
NSString *const kOLVTransactionTransactionId = @"transaction-id";
NSString *const kOLVTransactionMerchant = @"merchant";
NSString *const kOLVTransactionAccountId = @"account-id";
NSString *const kOLVTransactionRawMerchant = @"raw-merchant";


@interface OLVTransaction ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVTransaction

@synthesize transactionTime = _transactionTime;
@synthesize amount = _amount;
@synthesize isPending = _isPending;
@synthesize transactionId = _transactionId;
@synthesize merchant = _merchant;
@synthesize accountId = _accountId;
@synthesize rawMerchant = _rawMerchant;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.transactionTime = [self objectOrNilForKey:kOLVTransactionTransactionTime fromDictionary:dict];
            self.amount = [[self objectOrNilForKey:kOLVTransactionAmount fromDictionary:dict] doubleValue];
            self.isPending = [[self objectOrNilForKey:kOLVTransactionIsPending fromDictionary:dict] boolValue];
            self.transactionId = [self objectOrNilForKey:kOLVTransactionTransactionId fromDictionary:dict];
            self.merchant = [self objectOrNilForKey:kOLVTransactionMerchant fromDictionary:dict];
            self.accountId = [self objectOrNilForKey:kOLVTransactionAccountId fromDictionary:dict];
            self.rawMerchant = [self objectOrNilForKey:kOLVTransactionRawMerchant fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.transactionTime forKey:kOLVTransactionTransactionTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amount] forKey:kOLVTransactionAmount];
    [mutableDict setValue:[NSNumber numberWithBool:self.isPending] forKey:kOLVTransactionIsPending];
    [mutableDict setValue:self.transactionId forKey:kOLVTransactionTransactionId];
    [mutableDict setValue:self.merchant forKey:kOLVTransactionMerchant];
    [mutableDict setValue:self.accountId forKey:kOLVTransactionAccountId];
    [mutableDict setValue:self.rawMerchant forKey:kOLVTransactionRawMerchant];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

- (NSDate *)transactionDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [dateFormatter dateFromString:self.transactionTime];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.transactionTime = [aDecoder decodeObjectForKey:kOLVTransactionTransactionTime];
    self.amount = [aDecoder decodeDoubleForKey:kOLVTransactionAmount];
    self.isPending = [aDecoder decodeBoolForKey:kOLVTransactionIsPending];
    self.transactionId = [aDecoder decodeObjectForKey:kOLVTransactionTransactionId];
    self.merchant = [aDecoder decodeObjectForKey:kOLVTransactionMerchant];
    self.accountId = [aDecoder decodeObjectForKey:kOLVTransactionAccountId];
    self.rawMerchant = [aDecoder decodeObjectForKey:kOLVTransactionRawMerchant];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_transactionTime forKey:kOLVTransactionTransactionTime];
    [aCoder encodeDouble:_amount forKey:kOLVTransactionAmount];
    [aCoder encodeBool:_isPending forKey:kOLVTransactionIsPending];
    [aCoder encodeObject:_transactionId forKey:kOLVTransactionTransactionId];
    [aCoder encodeObject:_merchant forKey:kOLVTransactionMerchant];
    [aCoder encodeObject:_accountId forKey:kOLVTransactionAccountId];
    [aCoder encodeObject:_rawMerchant forKey:kOLVTransactionRawMerchant];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVTransaction *copy = [[OLVTransaction alloc] init];
    
    if (copy) {

        copy.transactionTime = [self.transactionTime copyWithZone:zone];
        copy.amount = self.amount;
        copy.isPending = self.isPending;
        copy.transactionId = [self.transactionId copyWithZone:zone];
        copy.merchant = [self.merchant copyWithZone:zone];
        copy.accountId = [self.accountId copyWithZone:zone];
        copy.rawMerchant = [self.rawMerchant copyWithZone:zone];
    }
    
    return copy;
}


@end
