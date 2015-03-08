//
//  AppDelegate.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/5/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "AppDelegate.h"
#import "OLVUserInfo.h"
#import "WebServiceHelper.h"
#import "OLVNavigationManager.h"

#import <ApiAI/ApiAI.h>
#import <APiAI/AIDefaultConfiguration.h>
#import <AVFoundation/AVFoundation.h>
#import <MRProgress/MRProgress.h>
#import "ApiAIHelper.h"


@interface AppDelegate ()
@property(nonatomic, strong) ApiAI *apiAI;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    self.window.rootViewController = [[OLVNavigationManager sharedManager] setUpViewControllersLayout];
    [self.window makeKeyAndVisible];
    
    [MRProgressOverlayView showOverlayAddedTo:self.window animated:YES];
    [[WebServiceHelper sharedInstance] loginWithUsername:@"hackdoc@levelmoney.com"
                                                password:@"hackathon1"
                                                 success:^(id response) {
                                                     
                                                     [MRProgressOverlayView dismissOverlayForView:self.window animated:YES];
                                                     
                                                     [[OLVUserInfo sharedInfo] clearUserInfo];
                                                     
                                                     [[WebServiceHelper sharedInstance] getAllTransactions:^(NSArray *transactions) {
                                                         
                             [OLVUserInfo sharedInfo].allTransactions = transactions;
                             [[WebServiceHelper sharedInstance] getProjectedTransactions:[NSDate date]
                                                                                 success:^(NSArray *transactions) {
                                                                                     [OLVUserInfo sharedInfo].projectedTransactions = transactions;
                                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                                                                                 }
                                                                                 failure:nil];
                                                                                                   }
                                                                                                   failure:nil];
                                                     [[WebServiceHelper sharedInstance] getDayBalances:[NSDate date]
                                                                                               success:^(NSArray *dayBalances) {
                                                                                                             [OLVUserInfo sharedInfo].dayBalances = dayBalances;
                                                                                                         }
                                                                                                         failure:nil];
                                                 }
                                                 failure:^(id response, NSError *error) {
                                                     [MRProgressOverlayView dismissOverlayForView:self.window animated:YES];
                                                 }];
    
//    [[WebServiceHelper sharedInstance] sendSMSToVerifyPhoneNumber:@"15183688100"];
//    [[WebServiceHelper sharedInstance] sendSMS:@"15183688100" text:@"Test nexmo API"];
    
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self setupAPIAI];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupAPIAI {
    // Define API.AI configuration here.
    self.apiAI = [ApiAI sharedApiAI];
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = kAPIClientAccessToken;
    configuration.subscriptionKey = kAPISubscriptionKey;
    self.apiAI.configuration = configuration;
}

@end
