//
//  WitAiHelper.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/8/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WitAIHelper;

@protocol WitAIHelperDelegate <NSObject>
@optional
- (void)witDidStartListening;
- (void)witDidStopListening;
@end

@interface WitAIHelper : NSObject

@property (nonatomic,weak) id<WitAIHelperDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)parseText:(NSString *)text withResultBlock:(parseSuccessBlock)succesBlock;
- (void)start;
- (void)stop;
- (void)toggle;
- (BOOL)isListening;

@end
