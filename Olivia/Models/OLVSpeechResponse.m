//
//  OLVSpeechResponse.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVSpeechResponse.h"

static NSString * const kStatusSuccess = @"success";
static NSString * const kResolvedQuery = @"resolvedQuery";

@interface OLVSpeechResponse()
@property (strong, nonatomic, readwrite) NSString *resolvedQuery;
@end

@implementation OLVSpeechResponse

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

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
        NSString *status = [self objectOrNilForKey:@"errorType" fromDictionary:(NSDictionary *)dict[@"status"]];
        if ([status isEqualToString:kStatusSuccess]) {
            self.resolvedQuery = [self objectOrNilForKey:kResolvedQuery
                                          fromDictionary:[self objectOrNilForKey:@"result" fromDictionary:dict]];
        }
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.resolvedQuery forKey:kResolvedQuery];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
