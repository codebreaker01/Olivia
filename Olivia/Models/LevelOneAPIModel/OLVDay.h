//
//  OLVDay.h
//
//  Created by   on 3/7/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OLVDay : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double year;
@property (nonatomic, assign) double month;
@property (nonatomic, assign) double day;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
