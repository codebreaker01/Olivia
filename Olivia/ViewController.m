//
//  ViewController.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "ViewController.h"
#import "AIVoiceRequestButton.h"
#import "AIVoiceRequest.h"
#import "ApiAIHelper.h"

@interface ViewController ()
@property (nonatomic, strong) ApiAI *apiAI;
@property (nonatomic, weak) IBOutlet AIVoiceRequestButton *voiceRequestButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.apiAI = [ApiAI sharedApiAI];
    [self setupListenerButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupListenerButton {
    self.apiAI = [ApiAI sharedApiAI];
    
    __weak typeof(self) selfWeak = self;
    
    [_voiceRequestButton setSuccessCallback:^(id response) {
        selfWeak.textView.text = [response description];
    }];
    
    [_voiceRequestButton setFailureCallback:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

}

# pragma mark - Utility
- (void)parseText:(NSString *)text {
    __weak typeof(self) selfWeak = self;
    [[ApiAIHelper sharedInstance] parseText:text withResultBlock:^(id response){
        selfWeak.textView.text = [response description];
    }];
}

@end
