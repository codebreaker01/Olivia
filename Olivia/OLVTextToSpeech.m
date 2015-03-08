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
    utterance.volume = 1.0;
    utterance.pitchMultiplier = 1.5;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    [utterance setRate:0.10];
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:AVAudioSessionCategoryOptionDuckOthers
                                           error:nil];
    
    [self.synthesizer speakUtterance:utterance];
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient withOptions: 0 error: nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions: 0 error:nil];
}

@end
