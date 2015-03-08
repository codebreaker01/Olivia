//
//  OLVSpeechResponse2.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/8/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLVSpeechResponse2 : NSObject

@property (strong, nonatomic, readonly) NSString *intent;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
