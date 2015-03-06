//
//  OLVTransactions.m
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVTransactions.h"
#import "OLVTransactions.h"


NSString *const kOLVTransactionsError = @"error";
NSString *const kOLVTransactionsTransactions = @"transactions";


@interface OLVTransactions ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVTransactions

@synthesize error = _error;
@synthesize transactions = _transactions;


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
            self.error = [self objectOrNilForKey:kOLVTransactionsError fromDictionary:dict];
    NSObject *receivedOLVTransactions = [dict objectForKey:kOLVTransactionsTransactions];
    NSMutableArray *parsedOLVTransactions = [NSMutableArray array];
    if ([receivedOLVTransactions isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedOLVTransactions) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedOLVTransactions addObject:[OLVTransactions modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedOLVTransactions isKindOfClass:[NSDictionary class]]) {
       [parsedOLVTransactions addObject:[OLVTransactions modelObjectWithDictionary:(NSDictionary *)receivedOLVTransactions]];
    }

    self.transactions = [NSArray arrayWithArray:parsedOLVTransactions];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.error forKey:kOLVTransactionsError];
    NSMutableArray *tempArrayForTransactions = [NSMutableArray array];
    for (NSObject *subArrayObject in self.transactions) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTransactions addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTransactions addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTransactions] forKey:kOLVTransactionsTransactions];

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

    self.error = [aDecoder decodeObjectForKey:kOLVTransactionsError];
    self.transactions = [aDecoder decodeObjectForKey:kOLVTransactionsTransactions];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_error forKey:kOLVTransactionsError];
    [aCoder encodeObject:_transactions forKey:kOLVTransactionsTransactions];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVTransactions *copy = [[OLVTransactions alloc] init];
    
    if (copy) {

        copy.error = [self.error copyWithZone:zone];
        copy.transactions = [self.transactions copyWithZone:zone];
    }
    
    return copy;
}


@end
