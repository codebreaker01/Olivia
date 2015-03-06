//
//  OLVSimilarTransactions.m
//
//  Created by   on 3/6/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVSimilarTransactions.h"


NSString *const kOLVSimilarTransactionsTransactionIds = @"transaction-ids";
NSString *const kOLVSimilarTransactionsError = @"error";


@interface OLVSimilarTransactions ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVSimilarTransactions

@synthesize transactionIds = _transactionIds;
@synthesize error = _error;


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
            self.transactionIds = [self objectOrNilForKey:kOLVSimilarTransactionsTransactionIds fromDictionary:dict];
            self.error = [self objectOrNilForKey:kOLVSimilarTransactionsError fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForTransactionIds = [NSMutableArray array];
    for (NSObject *subArrayObject in self.transactionIds) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTransactionIds addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTransactionIds addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTransactionIds] forKey:kOLVSimilarTransactionsTransactionIds];
    [mutableDict setValue:self.error forKey:kOLVSimilarTransactionsError];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
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

    self.transactionIds = [aDecoder decodeObjectForKey:kOLVSimilarTransactionsTransactionIds];
    self.error = [aDecoder decodeObjectForKey:kOLVSimilarTransactionsError];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_transactionIds forKey:kOLVSimilarTransactionsTransactionIds];
    [aCoder encodeObject:_error forKey:kOLVSimilarTransactionsError];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVSimilarTransactions *copy = [[OLVSimilarTransactions alloc] init];
    
    if (copy) {

        copy.transactionIds = [self.transactionIds copyWithZone:zone];
        copy.error = [self.error copyWithZone:zone];
    }
    
    return copy;
}


@end
