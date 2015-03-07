//
//  OLVDay.m
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OLVDay.h"


NSString *const kOLVDayYear = @"year";
NSString *const kOLVDayMonth = @"month";
NSString *const kOLVDayDay = @"day";


@interface OLVDay ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OLVDay

@synthesize year = _year;
@synthesize month = _month;
@synthesize day = _day;


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
            self.year = [[self objectOrNilForKey:kOLVDayYear fromDictionary:dict] doubleValue];
            self.month = [[self objectOrNilForKey:kOLVDayMonth fromDictionary:dict] doubleValue];
            self.day = [[self objectOrNilForKey:kOLVDayDay fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.year] forKey:kOLVDayYear];
    [mutableDict setValue:[NSNumber numberWithDouble:self.month] forKey:kOLVDayMonth];
    [mutableDict setValue:[NSNumber numberWithDouble:self.day] forKey:kOLVDayDay];

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

    self.year = [aDecoder decodeDoubleForKey:kOLVDayYear];
    self.month = [aDecoder decodeDoubleForKey:kOLVDayMonth];
    self.day = [aDecoder decodeDoubleForKey:kOLVDayDay];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_year forKey:kOLVDayYear];
    [aCoder encodeDouble:_month forKey:kOLVDayMonth];
    [aCoder encodeDouble:_day forKey:kOLVDayDay];
}

- (id)copyWithZone:(NSZone *)zone
{
    OLVDay *copy = [[OLVDay alloc] init];
    
    if (copy) {

        copy.year = self.year;
        copy.month = self.month;
        copy.day = self.day;
    }
    
    return copy;
}


@end
