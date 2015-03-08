//
//  NSDictionary+Olivia.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "NSDictionary+Olivia.h"

@implementation NSDictionary (Olivia)

- (id)objectOrNilForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
