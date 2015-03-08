//
//  OLVTextToSpeech.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVTextToSpeech.h"
@import AVFoundation;

@interface OLVTextToSpeech ()
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@end

@implementation OLVTextToSpeech

+ (instancetype)sharedInstance {
    static OLVTextToSpeech *currentInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentInstance = [[self alloc] init];
        currentInstance.synthesizer = [[AVSpeechSynthesizer alloc] init];
    });
    return currentInstance;
}

- (void)speakText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:1.1f];
    [self.synthesizer speakUtterance:utterance];
}

@end
