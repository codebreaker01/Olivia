//
//  OLVPresentViewController.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVPresentViewController.h"
#import "SWRevealViewController.h"
#import "OLVBubbleMessageViewController.h"
#import "PNChart.h"
#import "OLVUserInfo.h"
#import "NSString+Olivia.h"
#import "UIColor+OLVExtensions.h"

@interface OLVPresentViewController () <OLVBubbleMessageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *whatsLeftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraintForSpentView;

@end

@implementation OLVPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"Olivia", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar-graph-icon"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"estimate-icon"]
                                                                              style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"Login" object:nil];

    self.whatsLeftLabel.alpha = 0.0;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIImage* logoImage = [UIImage imageNamed:@"white-app-icon-small"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor healthygreenColor];
    
    self.topContraintForSpentView.constant = self.view.bounds.size.height + 63;
    [self.view layoutIfNeeded];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)login {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *toDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    double amountSpent = [[OLVUserInfo sharedInfo] getExpenseForMonth:toDate];
    float amountPercentage = 1.0 - amountSpent/[OLVUserInfo sharedInfo].spendableAmount;
    
    
    
    [self.view bringSubviewToFront:self.whatsLeftLabel];
    
    self.whatsLeftLabel.numberOfLines = 1;
    self.whatsLeftLabel.minimumScaleFactor = 0;
    self.whatsLeftLabel.adjustsFontSizeToFitWidth = YES;
    
    self.whatsLeftLabel.text = [NSString priceStringFrom:[[OLVUserInfo sharedInfo] whatsLeftAmount:toDate]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.whatsLeftLabel.alpha = 1.0;
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.75 initialSpringVelocity:5
                        options:0 animations:^{
                            if (amountPercentage < 1.0 && amountPercentage > 0) {
                                self.topContraintForSpentView.constant = amountPercentage * (self.view.bounds.size.height + 63);

                            } else if (amountPercentage > 1.0) {
                                self.topContraintForSpentView.constant = 0;
                            } else if (amountPercentage < 0) {
                                self.topContraintForSpentView.constant = amountPercentage * (self.view.bounds.size.height + 63);
                            }
                            [self.view layoutIfNeeded];
                        } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User Actions
- (IBAction)activateOlivia:(id)sender {
    OLVBubbleMessageViewController *bubbleMessageVC = [[OLVBubbleMessageViewController alloc] init];
    bubbleMessageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bubbleMessageVC animated:YES completion:nil];
    bubbleMessageVC.delegateModal = self;
}

- (void)didDismissViewController:(OLVBubbleMessageViewController *)vc {
    [self dismissViewControllerAnimated:vc completion:nil];
}

@end
