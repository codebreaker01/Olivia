//
//  OLVDayBalances.h
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OLVDayBalances : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSString *error;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
