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

@interface OLVPresentViewController () <OLVBubbleMessageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pieChart;

@end

@implementation OLVPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Olivia", nil);
    
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
    self.pieChart.layer.cornerRadius = 120;
    self.pieChart.backgroundColor = PNGreen;
}

- (void)login {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *toDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    double amountSpent = ([OLVUserInfo sharedInfo].spendableAmount - [[OLVUserInfo sharedInfo] getExpenseForMonth:toDate]);
    int amountPercentage = floor((amountSpent/[OLVUserInfo sharedInfo].spendableAmount) * 100);
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:amountPercentage color:PNGreen],
                       [PNPieChartDataItem dataItemWithValue:100 - amountPercentage color:[UIColor clearColor] description:@""],
                       ];
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectInset(self.pieChart.frame, 15, 15) items:items];
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pieChart.alpha = 0.6;
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
    [self.revealViewController.frontViewController presentViewController:bubbleMessageVC animated:YES completion:nil];
    bubbleMessageVC.delegateModal = self;
}

- (void)didDismissViewController:(OLVBubbleMessageViewController *)vc {
    [self dismissViewControllerAnimated:vc completion:nil];
}

@end
