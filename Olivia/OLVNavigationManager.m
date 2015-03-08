//
//  OLVNavigationManager.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVPastViewController.h"
#import "OLVOliviaViewController.h"
#import "OLVPresentViewController.h"
#import "OLVEstimateViewController.h"

#import "OLVNavigationManager.h"

@implementation OLVNavigationManager

+ (instancetype)sharedManager {
    
    static OLVNavigationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (SWRevealViewController *)setUpViewControllersLayout {
    
    OLVPresentViewController *presentViewController = [[OLVPresentViewController alloc] init];
    OLVPastViewController *pastViewController = [[OLVPastViewController alloc] init];
    OLVEstimateViewController *estimateViewController = [[OLVEstimateViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:presentViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:pastViewController];
    UINavigationController *rightNavigationController = [[UINavigationController alloc] initWithRootViewController:estimateViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    revealController.rearViewRevealWidth  = [UIScreen mainScreen].bounds.size.width * 0.85;
    revealController.rightViewRevealWidth = [UIScreen mainScreen].bounds.size.width * 0.85;
    revealController.frontViewShadowOpacity = 0.25;
    
    revealController.rightViewController = rightNavigationController;
    
    return revealController;
}

#pragma mark - SWRevealViewControllerDelegate

- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{

}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{

}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{

}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
{
    
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
{
    
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress
{

}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{

}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress
{

}

- (void)revealController:(SWRevealViewController *)revealController willAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{

}

- (void)revealController:(SWRevealViewController *)revealController didAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated
{

}

@end
