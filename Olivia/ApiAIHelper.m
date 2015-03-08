//
//  ApiAIHelper.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/6/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "ApiAIHelper.h"
#import <ApiAI/ApiAI.h>
#import <ApiAI/AITextRequest.h>

@interface ApiAIHelper()
@property (strong, nonatomic) AITextRequest *request;
@end

@implementation ApiAIHelper

+ (instancetype)sharedInstance {
    static ApiAIHelper *currentInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        currentInstance = [[self alloc] init];
    });
    return currentInstance;
}

- (void)parseText:(NSString *)text withResultBlock:(parseSuccessBlock)succesBlock {
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    self.request = (AITextRequest *)[apiai requestWithType:AIRequestTypeText];
    self.request.query = @[text];
    
    [self.request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        succesBlock(response);
    } failure:^(AIRequest *request, NSError *error) {
        NSLog(@"-----------------Request errored out!-------------------");
    }];
    
    [apiai enqueue:self.request];
}

@end
