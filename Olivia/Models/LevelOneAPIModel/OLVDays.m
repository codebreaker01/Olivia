//
//  OLVDays.m
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVDays.h"
#import "OLVDay.h"


NSString *const kOLVDaysDay = @"day";
NSString *const kOLVDaysBalance = @"balance";


@interface OLVDays ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVDays

@synthesize day = _day;
@synthesize balance = _balance;


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
            self.day = [OLVDay modelObjectWithDictionary:[dict objectForKey:kOLVDaysDay]];
            self.balance = [[self objectOrNilForKey:kOLVDaysBalance fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.day dictionaryRepresentation] forKey:kOLVDaysDay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.balance] forKey:kOLVDaysBalance];

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

    self.day = [aDecoder decodeObjectForKey:kOLVDaysDay];
    self.balance = [aDecoder decodeDoubleForKey:kOLVDaysBalance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_day forKey:kOLVDaysDay];
    [aCoder encodeDouble:_balance forKey:kOLVDaysBalance];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVDays *copy = [[OLVDays alloc] init];
    
    if (copy) {

        copy.day = [self.day copyWithZone:zone];
        copy.balance = self.balance;
    }
    
    return copy;
}


@end
