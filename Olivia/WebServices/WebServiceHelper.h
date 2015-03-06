//
//  WebServiceHelper.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void SuccessBlock(id);
typedef void FailureBlock(id, NSError *);

@interface WebServiceHelper : NSObject

+ (instancetype)sharedInstance;

@end
