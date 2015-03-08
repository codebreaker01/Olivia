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

@interface OLVPresentViewController () <OLVBubbleMessageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *whatsLeftLabel;

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
    
    self.pieChart.alpha = 0.0;
    self.pieChart.layer.cornerRadius = 100;
    self.pieChart.backgroundColor = PNGreen;
    self.whatsLeftLabel.alpha = 0.0;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
//    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIColor whiteColor],NSForegroundColorAttributeName,
//                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
//                                    [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0f],NSFontAttributeName,
//                                    nil];
//    
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIImage* logoImage = [UIImage imageNamed:@"white-app-icon-small"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = UIColorFromRGB(0x2498D6);
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
    int amountPercentage = floor(amountSpent/[OLVUserInfo sharedInfo].spendableAmount * 100);
    
    PNPieChart *pieChart;
    if (amountPercentage < 100 && amountPercentage > 0) {
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:amountPercentage color:PNGreen],
                           [PNPieChartDataItem dataItemWithValue:100 - amountPercentage color:[UIColor clearColor] description:@""],
                           ];
        
        pieChart = [[PNPieChart alloc] initWithFrame:CGRectInset(self.pieChart.frame, 10, 10) items:items];
        [pieChart strokeChart];
        [self.view addSubview:pieChart];
    }
    
    [self.view bringSubviewToFront:self.whatsLeftLabel];
    
    self.whatsLeftLabel.numberOfLines = 1;
    self.whatsLeftLabel.minimumScaleFactor = 0;
    self.whatsLeftLabel.adjustsFontSizeToFitWidth = YES;
    
    self.whatsLeftLabel.text = [NSString priceStringFrom:[[OLVUserInfo sharedInfo] whatsLeftAmount:toDate]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pieChart.alpha = 0.6;
        pieChart.alpha = 0.75;
        self.whatsLeftLabel.alpha = 1.0;
    }];
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
