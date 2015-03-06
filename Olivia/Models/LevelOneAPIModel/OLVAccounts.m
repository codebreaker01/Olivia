//
//  OLVAccounts.m
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVAccounts.h"
#import "OLVAccounts.h"


NSString *const kOLVAccountsAccounts = @"accounts";
NSString *const kOLVAccountsError = @"error";


@interface OLVAccounts ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVAccounts

@synthesize accounts = _accounts;
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
    NSObject *receivedOLVAccounts = [dict objectForKey:kOLVAccountsAccounts];
    NSMutableArray *parsedOLVAccounts = [NSMutableArray array];
    if ([receivedOLVAccounts isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedOLVAccounts) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedOLVAccounts addObject:[OLVAccounts modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedOLVAccounts isKindOfClass:[NSDictionary class]]) {
       [parsedOLVAccounts addObject:[OLVAccounts modelObjectWithDictionary:(NSDictionary *)receivedOLVAccounts]];
    }

    self.accounts = [NSArray arrayWithArray:parsedOLVAccounts];
            self.error = [self objectOrNilForKey:kOLVAccountsError fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForAccounts = [NSMutableArray array];
    for (NSObject *subArrayObject in self.accounts) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAccounts addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAccounts addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAccounts] forKey:kOLVAccountsAccounts];
    [mutableDict setValue:self.error forKey:kOLVAccountsError];

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

    self.accounts = [aDecoder decodeObjectForKey:kOLVAccountsAccounts];
    self.error = [aDecoder decodeObjectForKey:kOLVAccountsError];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_accounts forKey:kOLVAccountsAccounts];
    [aCoder encodeObject:_error forKey:kOLVAccountsError];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVAccounts *copy = [[OLVAccounts alloc] init];
    
    if (copy) {

        copy.accounts = [self.accounts copyWithZone:zone];
        copy.error = [self.error copyWithZone:zone];
    }
    
    return copy;
}


@end
