//
//  OLVTextToSpeech.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLVTextToSpeech : NSObject

+ (instancetype)sharedInstance;

- (void)speakText:(NSString *)text;

@end
