//
//  OLVSpeechResponse2.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/8/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVSpeechResponse2.h"

static NSString * const kConfidence = @"confidence";
static NSString * const kIntent = @"intent";
#define kConfidenceMin 0.5

@interface OLVSpeechResponse2()
@property (strong, nonatomic, readwrite) NSString *intent;
@property (strong, nonatomic, readwrite) NSString *amount;
@property (strong, nonatomic, readwrite) NSString *service;
@end

@implementation OLVSpeechResponse2

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
        double confidence = [[self objectOrNilForKey:@"confidence" fromDictionary:dict] doubleValue];
        if (confidence >= kConfidenceMin) {
            self.intent = [self objectOrNilForKey:kIntent fromDictionary:dict];
            if ([self.intent isEqualToString:kIntentRecurringExpense]) {
                NSArray *amountArray = dict[@"entities"][@"amount_of_money"];
                if (amountArray) {
                    self.amount = [amountArray objectAtIndex:0][@"value"];
                }
                NSArray *serviceArray = dict[@"entities"][@"merchant"];
                if (serviceArray) {
                    self.service = [serviceArray objectAtIndex:0][@"value"];
                }
            }
            if ([self.intent isEqualToString:kIntentConfirmation]) {
                
            }
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.intent forKey:kIntent];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
