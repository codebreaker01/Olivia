//
//  OLVSpeechResponse.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLVSpeechResponse : NSObject

@property (strong, nonatomic, readonly) NSString *resolvedQuery;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
