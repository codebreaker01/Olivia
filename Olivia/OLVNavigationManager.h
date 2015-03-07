//
//  OLVNavigationManager.h
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRevealViewController.h"

@interface OLVNavigationManager : NSObject <SWRevealViewControllerDelegate>

+ (instancetype)sharedManager;
- (SWRevealViewController *)setUpViewControllersLayout;

@end
