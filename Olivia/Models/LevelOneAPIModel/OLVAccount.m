//
//  OLVAccount.m
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVAccount.h"


NSString *const kOLVAccountLegacyInstitutionId = @"legacy-institution-id";
NSString *const kOLVAccountActive = @"active";
NSString *const kOLVAccountAccountName = @"account-name";
NSString *const kOLVAccountAccountType = @"account-type";
NSString *const kOLVAccountLastDigits = @"last-digits";
NSString *const kOLVAccountAccountId = @"account-id";
NSString *const kOLVAccountBalance = @"balance";
NSString *const kOLVAccountInstitutionName = @"institution-name";


@interface OLVAccount ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVAccount

@synthesize legacyInstitutionId = _legacyInstitutionId;
@synthesize active = _active;
@synthesize accountName = _accountName;
@synthesize accountType = _accountType;
@synthesize lastDigits = _lastDigits;
@synthesize accountId = _accountId;
@synthesize balance = _balance;
@synthesize institutionName = _institutionName;


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
            self.legacyInstitutionId = [[self objectOrNilForKey:kOLVAccountLegacyInstitutionId fromDictionary:dict] doubleValue];
            self.active = [[self objectOrNilForKey:kOLVAccountActive fromDictionary:dict] boolValue];
            self.accountName = [self objectOrNilForKey:kOLVAccountAccountName fromDictionary:dict];
            self.accountType = [self objectOrNilForKey:kOLVAccountAccountType fromDictionary:dict];
            self.lastDigits = [self objectOrNilForKey:kOLVAccountLastDigits fromDictionary:dict];
            self.accountId = [self objectOrNilForKey:kOLVAccountAccountId fromDictionary:dict];
            self.balance = [[self objectOrNilForKey:kOLVAccountBalance fromDictionary:dict] doubleValue];
            self.institutionName = [self objectOrNilForKey:kOLVAccountInstitutionName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.legacyInstitutionId] forKey:kOLVAccountLegacyInstitutionId];
    [mutableDict setValue:[NSNumber numberWithBool:self.active] forKey:kOLVAccountActive];
    [mutableDict setValue:self.accountName forKey:kOLVAccountAccountName];
    [mutableDict setValue:self.accountType forKey:kOLVAccountAccountType];
    [mutableDict setValue:self.lastDigits forKey:kOLVAccountLastDigits];
    [mutableDict setValue:self.accountId forKey:kOLVAccountAccountId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.balance] forKey:kOLVAccountBalance];
    [mutableDict setValue:self.institutionName forKey:kOLVAccountInstitutionName];

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

    self.legacyInstitutionId = [aDecoder decodeDoubleForKey:kOLVAccountLegacyInstitutionId];
    self.active = [aDecoder decodeBoolForKey:kOLVAccountActive];
    self.accountName = [aDecoder decodeObjectForKey:kOLVAccountAccountName];
    self.accountType = [aDecoder decodeObjectForKey:kOLVAccountAccountType];
    self.lastDigits = [aDecoder decodeObjectForKey:kOLVAccountLastDigits];
    self.accountId = [aDecoder decodeObjectForKey:kOLVAccountAccountId];
    self.balance = [aDecoder decodeDoubleForKey:kOLVAccountBalance];
    self.institutionName = [aDecoder decodeObjectForKey:kOLVAccountInstitutionName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_legacyInstitutionId forKey:kOLVAccountLegacyInstitutionId];
    [aCoder encodeBool:_active forKey:kOLVAccountActive];
    [aCoder encodeObject:_accountName forKey:kOLVAccountAccountName];
    [aCoder encodeObject:_accountType forKey:kOLVAccountAccountType];
    [aCoder encodeObject:_lastDigits forKey:kOLVAccountLastDigits];
    [aCoder encodeObject:_accountId forKey:kOLVAccountAccountId];
    [aCoder encodeDouble:_balance forKey:kOLVAccountBalance];
    [aCoder encodeObject:_institutionName forKey:kOLVAccountInstitutionName];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVAccount *copy = [[OLVAccount alloc] init];
    
    if (copy) {

        copy.legacyInstitutionId = self.legacyInstitutionId;
        copy.active = self.active;
        copy.accountName = [self.accountName copyWithZone:zone];
        copy.accountType = [self.accountType copyWithZone:zone];
        copy.lastDigits = [self.lastDigits copyWithZone:zone];
        copy.accountId = [self.accountId copyWithZone:zone];
        copy.balance = self.balance;
        copy.institutionName = [self.institutionName copyWithZone:zone];
    }
    
    return copy;
}


@end
