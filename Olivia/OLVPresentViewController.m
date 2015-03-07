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

@interface OLVPresentViewController ()

@end

@implementation OLVPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Olivia", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-icon"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-icon"]
                                                                              style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    [self presentOliviaVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)presentOliviaVC {
    OLVBubbleMessageViewController *bubbleMessageVC = [[OLVBubbleMessageViewController alloc] init];
    bubbleMessageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bubbleMessageVC animated:YES completion:nil];
}

@end
