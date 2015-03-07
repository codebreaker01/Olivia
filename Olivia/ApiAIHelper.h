//
//  ApiAIHelper.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiAIHelper : NSObject

+ (instancetype)sharedInstance;

- (void)parseText:(NSString *)text withResultBlock:(parseSuccessBlock)succesBlock;

@end
