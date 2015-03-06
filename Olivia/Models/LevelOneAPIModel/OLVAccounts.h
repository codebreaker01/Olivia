//
//  OLVAccounts.h
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OLVAccounts : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) NSString *error;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
