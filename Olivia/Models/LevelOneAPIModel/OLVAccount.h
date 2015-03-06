//
//  OLVAccount.h
//
//  Created by   on 3/5/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OLVAccount : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double legacyInstitutionId;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *lastDigits;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString *institutionName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
