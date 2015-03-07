//
//  OLVDays.h
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLVDay;

@interface OLVDays : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) OLVDay *day;
@property (nonatomic, assign) double balance;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
