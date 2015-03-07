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
    
    AITextRequest *request = (AITextRequest *)[apiai requestWithType:AIRequestTypeText];
    request.query = @[text];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        succesBlock(response);
    } failure:^(AIRequest *request, NSError *error) {

    }];
    
    [apiai enqueue:request];
}

@end
