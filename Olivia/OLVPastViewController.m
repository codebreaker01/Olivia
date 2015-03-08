//
//  OLVPastViewController.m
//  Olivia
//
//  Created by Jaikumar Bhambhwani on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVDays.h"
#import "OLVUserInfo.h"
#import "OLVPastViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "SWRevealViewController.h"
#import "OLVDayBalances.h"

#import "NSString+Olivia.h"

@interface OLVPastViewController () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UIView *lineGraphContainerView;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineExpenseGraph;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineIncomeGraph;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenselabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginContainerConstraint;
@property (weak, nonatomic) IBOutlet UILabel *netWorthValue;

@property (nonatomic) NSArray *months;
@property (nonatomic) NSArray *income;
@property (nonatomic) NSArray *expense;

@end

@implementation OLVPastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customization of the graph
    self.lineExpenseGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.lineExpenseGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.lineExpenseGraph.colorLine = [UIColor whiteColor];
    self.lineExpenseGraph.colorXaxisLabel = [UIColor whiteColor];
    self.lineExpenseGraph.widthLine = 1.0;
    self.lineExpenseGraph.enableTouchReport = YES;
    self.lineExpenseGraph.enableBezierCurve = NO;
    
    // Customization of the graph
    self.lineIncomeGraph.colorTop = [UIColor clearColor];
    self.lineIncomeGraph.colorBottom = [UIColor clearColor];
    self.lineIncomeGraph.colorLine = [UIColor whiteColor];
    self.lineIncomeGraph.colorXaxisLabel = [UIColor whiteColor];
    self.lineIncomeGraph.widthLine = 1.0;
    self.lineIncomeGraph.enableTouchReport = YES;
    self.lineIncomeGraph.enableBezierCurve = NO;
    
    self.lineIncomeGraph.lowerGraph = self.lineExpenseGraph;
    self.lineIncomeGraph.lowerGraphShouldRecognizeTouches = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.months  = [self createPastDateArray];
    self.income  = [self getIncomeForMonths:self.months];
    self.expense = [self getExpenseForMonths:self.months];
    
    [self.lineIncomeGraph reloadGraph];
    [self.lineExpenseGraph reloadGraph];
    
    self.navigationController.navigationBar.hidden = YES;
    
    OLVDays *day = (OLVDays *)[[[OLVUserInfo sharedInfo] dayBalances] lastObject];
    self.netWorthValue.text = [NSString priceStringFrom:day.balance/10000];
}

- (void)viewDidLayoutSubviews {
    self.rightMarginContainerConstraint.constant = 0.85 * [UIScreen mainScreen].scale + 25;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)createPastDateArray {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                                                            NSCalendarUnitMonth |
                                                                            NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    components.day = 1;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    
    [array addObject:firstDayOfMonthDate];
    
    for (int i = 0; i < 6; i++) {
        --components.month;
        [array addObject:[[NSCalendar currentCalendar] dateFromComponents:components]];
    }
    return array;
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
    if ([graph isEqual:self.lineExpenseGraph]) {
        return [[self.expense objectAtIndex:index] doubleValue];
    }else if ([graph isEqual:self.lineIncomeGraph]) {
        return [[self.income objectAtIndex:index] doubleValue];
    }
    return 0;
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSDate *date = [self.months objectAtIndex:index];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                                                            NSCalendarUnitMonth |
                                                                            NSCalendarUnitYear
                                                                   fromDate:date];
    if (components.month == 1) {
        return @"Jan";
    } else if (components.month == 2) {
        return @"Feb";
    } else if (components.month == 3) {
        return @"Mar";
    } else if (components.month == 4) {
        return @"Apr";
    } else if (components.month == 5) {
        return @"May";
    } else if (components.month == 6) {
        return @"Jun";
    } else if (components.month == 7) {
        return @"Jul";
    } else if (components.month == 8) {
        return @"Aug";
    } else if (components.month == 9) {
        return @"Sep";
    } else if (components.month == 10) {
        return @"Oct";
    } else if (components.month == 11) {
        return @"Nov";
    } else {
        return @"Dec";
    }
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    
    if ([graph isEqual:self.lineExpenseGraph]) {
        self.expenselabel.text = [NSString priceStringFrom:[[self.expense objectAtIndex:index]doubleValue]];
    }else if ([graph isEqual:self.lineIncomeGraph]) {
       self.incomeLabel.text = [NSString priceStringFrom:[[self.income objectAtIndex:index] doubleValue]];
    }
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.expenselabel.alpha = 0.0;
        self.incomeLabel.alpha = 0.0;
    } completion:^(BOOL finished){
        
        self.expenselabel.text = [NSString priceStringFrom:[[self.lineExpenseGraph calculatePointValueSum] doubleValue]];
        self.incomeLabel.text = [NSString priceStringFrom:[[self.lineIncomeGraph calculatePointValueSum] doubleValue]];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.expenselabel.alpha = 1.0;
            self.incomeLabel.alpha = 1.0;
        } completion:nil];
    }];
    
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    if ([graph isEqual:self.lineExpenseGraph]) {
        self.expenselabel.text = [NSString priceStringFrom:[[self.lineExpenseGraph calculatePointValueSum] doubleValue]];
    }else if ([graph isEqual:self.lineIncomeGraph]) {
        self.incomeLabel.text = [NSString priceStringFrom:[[self.lineIncomeGraph calculatePointValueSum] doubleValue]];
    }
}

@end
