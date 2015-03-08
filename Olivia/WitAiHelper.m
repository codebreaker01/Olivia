//  WitAiHelper.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/8/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "WitAIHelper.h"
#import <Wit/Wit.h>

@interface WitAIHelper () <WitDelegate>
@property (strong, nonatomic) Wit *wit;
@property (nonatomic, copy) parseSuccessBlock succesBlock;
@end

@implementation WitAIHelper

+ (instancetype)sharedInstance {
    static WitAIHelper *currentInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        currentInstance = [[self alloc] init];
        currentInstance.wit = [Wit sharedInstance];
        currentInstance.wit.delegate = currentInstance;
    });
    return currentInstance;
}

- (void)parseText:(NSString *)text withResultBlock:(parseSuccessBlock)succesBlock {
    self.succesBlock = succesBlock;
    [self.wit interpretString:text customData:nil];
}

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id) customData error:(NSError*)e {
    if (e) {
        NSLog(@"-----------------------Wit error----------------------------\n%@",e.localizedDescription);
    }
    if (outcomes) {
        NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
        NSLog(@"--------------------------- Result -----------------------------\n%@",firstOutcome);
        if (self.succesBlock) {
            self.succesBlock(firstOutcome);
        }
        [self.wit stop];
    }
}

- (void)witActivityDetectorStarted {
    NSLog(@"-----------------------------Started recording--------------------------");
}

- (void)witDidStartRecording {
    [self.delegate witDidStartListening];
}

- (void)witDidStopRecording {
    [self.delegate witDidStopListening];
}

- (void)start {
    [self.wit start];
}

- (void)stop {
    [self.wit stop];
}

- (void)toggle {
    [self.wit toggleCaptureVoiceIntent];
}

- (BOOL)isListening {
    return [self.wit isRecording];
}

@end
