//
//  OLVEstimateViewController.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVEstimateViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "OLVUserInfo.h"

#import "NSString+Olivia.h"

@interface OLVEstimateViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraphPrediction;
@property (weak, nonatomic) IBOutlet UILabel *predictedNetWorth;
@property (weak, nonatomic) IBOutlet UILabel *predictedNetWorthTop;
@property (weak, nonatomic) IBOutlet UILabel *networthTitle;

@property (nonatomic) NSArray *months;
@property (nonatomic) NSArray *predictions;

@end

@implementation OLVEstimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.lineGraphPrediction.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.lineGraphPrediction.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.lineGraphPrediction.colorLine = [UIColor whiteColor];
    self.lineGraphPrediction.colorXaxisLabel = [UIColor whiteColor];
    self.lineGraphPrediction.widthLine = 1.0;
    self.lineGraphPrediction.enableTouchReport = YES;
    self.lineGraphPrediction.enableBezierCurve = NO;
    
    self.months = @[@2,@3,@4,@5,@6];
    self.predictions = @[@11427.81, @10356.28, @11318.08, @9009.00, @8064.66];

    self.predictedNetWorth.text =[NSString priceStringFrom:[[self.predictions lastObject] doubleValue]];
    self.predictedNetWorth.alpha = 0.0;
    self.networthTitle.alpha = 0.0;
    self.predictedNetWorthTop.text =[NSString priceStringFrom:[[self.predictions lastObject] doubleValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.lineGraphPrediction reloadGraph];
}

- (void)viewDidLayoutSubviews {
    self.leftMarginConstraint.constant = 0.15 * [UIScreen mainScreen].bounds.size.width;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)getIncomeForMonths:(NSArray *)dates {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDate *date in dates) {
        [array addObject:[NSNumber numberWithDouble:[[OLVUserInfo sharedInfo] getIncomeForMonth:date]]];
    }
    return array;
}

- (NSArray *)getExpenseForMonths:(NSArray *)dates {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDate *date in dates) {
        [array addObject:[NSNumber numberWithDouble:[[OLVUserInfo sharedInfo] getExpenseForMonth:date]]];
    }
    return array;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.months.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.predictions objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSInteger month = [[self.months objectAtIndex:index] integerValue];
    
    if (month == 1) {
        return @"Jan";
    } else if (month == 2) {
        return @"Feb";
    } else if (month == 3) {
        return @"Mar";
    } else if (month == 4) {
        return @"Apr";
    } else if (month == 5) {
        return @"May";
    } else if (month == 6) {
        return @"Jun";
    } else if (month == 7) {
        return @"Jul";
    } else if (month == 8) {
        return @"Aug";
    } else if (month == 9) {
        return @"Sep";
    } else if (month == 10) {
        return @"Oct";
    } else if (month == 11) {
        return @"Nov";
    } else {
        return @"Dec";
    }
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    
    self.predictedNetWorth.text = [NSString priceStringFrom:[[self.predictions objectAtIndex:index]doubleValue]];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.networthTitle.alpha = 1.0;
        self.predictedNetWorth.alpha = 1.0;
    } completion:nil];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.networthTitle.alpha = 0.0;
        self.predictedNetWorth.alpha = 0.0;
    } completion:^(BOOL finished){
        
    }];
    
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.predictedNetWorthTop.text =[NSString priceStringFrom:[[self.predictions lastObject] doubleValue]];
}

@end
