//
//  NSString+Olivia.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "NSString+Olivia.h"

@implementation NSString (Olivia)

+ (NSString *)priceStringFrom:(double)price
{
    price = [[NSString stringWithFormat:@"%.2f",price]floatValue];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    return [NSString stringWithFormat:@"$%@",formatted];
}

@end
