//
//  NSString+Olivia.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "NSString+Olivia.h"

@implementation NSString (Olivia)

+ (NSString *)priceStringFrom:(double)price {
    return [NSString stringWithFormat:@"$%0.2f",price];
}

@end
