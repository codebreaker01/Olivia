//
//  OLVDayBalances.m
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVDayBalances.h"
#import "OLVDays.h"


NSString *const kOLVDayBalancesDays = @"days";
NSString *const kOLVDayBalancesError = @"error";


@interface OLVDayBalances ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVDayBalances

@synthesize days = _days;
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
    NSObject *receivedOLVDays = [dict objectForKey:kOLVDayBalancesDays];
    NSMutableArray *parsedOLVDays = [NSMutableArray array];
    if ([receivedOLVDays isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedOLVDays) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedOLVDays addObject:[OLVDays modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedOLVDays isKindOfClass:[NSDictionary class]]) {
       [parsedOLVDays addObject:[OLVDays modelObjectWithDictionary:(NSDictionary *)receivedOLVDays]];
    }

    self.days = [NSArray arrayWithArray:parsedOLVDays];
            self.error = [self objectOrNilForKey:kOLVDayBalancesError fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForDays = [NSMutableArray array];
    for (NSObject *subArrayObject in self.days) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForDays addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForDays addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDays] forKey:kOLVDayBalancesDays];
    [mutableDict setValue:self.error forKey:kOLVDayBalancesError];

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

    self.days = [aDecoder decodeObjectForKey:kOLVDayBalancesDays];
    self.error = [aDecoder decodeObjectForKey:kOLVDayBalancesError];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_days forKey:kOLVDayBalancesDays];
    [aCoder encodeObject:_error forKey:kOLVDayBalancesError];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVDayBalances *copy = [[OLVDayBalances alloc] init];
    
    if (copy) {

        copy.days = [self.days copyWithZone:zone];
        copy.error = [self.error copyWithZone:zone];
    }
    
    return copy;
}


@end
