//
//  FirstViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SleepViewController.h"
#import "UIColor+FSPalette.h"
#import <ChameleonFramework/Chameleon.h>



@interface SleepViewController () {
    int previousStepperValue;
    int totalNumber;
}
@property NSArray *fetchResults;
@property NSManagedObject *lastRecord;
@property  UIAlertView *alert;
@property BOOL show;
@end

@implementation SleepViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setQuestionView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGraphData];
    
    //Scroll View
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 800)];

    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    //Graph
    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor darkGrayColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.myGraph.formatStringForValues = @"%.1f";
    
    _show = NO;
    

   
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatYellowColor]];
    [self.tabBarController.tabBar setTintColor:[UIColor flatYellowColor]];
    [self.view setTintColor:[UIColor flatYellowColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatYellowColor]}];
}
- (void) setQuestionView {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SleepRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval:-86400.0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@", yesterday];
    [request setPredicate:predicate];
    [request setFetchLimit:1];
    
    NSError *error;
    _fetchResults = [context executeFetchRequest:request error:&error];
    
    if ((_fetchResults.count != 0) && !_show) {
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,65,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@" se oculto 1");
    }else{
        self.questionView.hidden = NO;
        self.scrollView.frame = CGRectMake(0,210,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
    }
    
}
- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = [self.arrayOfDates objectAtIndex:index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7;
}
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [self labelForDateAtIndex:index];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" horas";
}

// PopAlert - INPUT INGRESADO EN EL TEXTFIELD
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAgrega:(UIButton *)sender {
    _show = YES;
    self.questionView.hidden = NO;
    self.scrollView.frame = CGRectMake(0,210,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}





#pragma mark - Helper functions

- (void)loadGraphData {
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval:-86400.0];
    NSDate *twoDaysAgo = [yesterday dateByAddingTimeInterval:-86400.0];
    NSDate *threeDaysAgo = [twoDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *fourDaysAgo = [threeDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *fiveDaysAgo = [fourDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *sixDaysAgo = [fiveDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *sevenDaysAgo = [sixDaysAgo dateByAddingTimeInterval:-86400.0];
    
    self.arrayOfDates = [[NSMutableArray alloc] initWithObjects:today, yesterday, twoDaysAgo,
                         threeDaysAgo, fourDaysAgo, fiveDaysAgo, sixDaysAgo, sevenDaysAgo, nil];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SleepRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSManagedObject *record;
    NSPredicate *predicate;
    NSArray *fetchResults;
    self.arrayOfValues = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *duration = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            duration = [record valueForKey:@"duration"];
        }
        [self.arrayOfValues addObject:duration];
    }
    
    [self.arrayOfDates removeObjectAtIndex:7];
    self.arrayOfDates = [[[self.arrayOfDates reverseObjectEnumerator] allObjects] mutableCopy];
    self.arrayOfValues = [[[self.arrayOfValues reverseObjectEnumerator] allObjects] mutableCopy];
   
    
}



- (IBAction)submit:(id)sender {
   
    if (![self.tfTimeSlept.text isEqualToString:@""]) {
        _show = false;
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,65,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            NSLog(@" se oculto 2");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        if (!self.lastRecord) {
            self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SleepRecord"
                                                            inManagedObjectContext:context];
        }
        NSDate *date = [NSDate date];
        CGFloat duration = [self.txtCantidadSue.text floatValue];
        
        [self.lastRecord setValue:date forKey:@"date"];
        [self.lastRecord setValue:@(duration) forKey:@"duration"];
        
        NSError *error;
        [context save:&error];
    }
    
}
- (IBAction)pressedButton:(UIButton *)sender {
    if (sender == self.btPlus) {
        
        if ([self.tfTimeSlept.text isEqualToString:@""]) {
            
            self.tfTimeSlept.text = [@(5) stringValue];
            
        }else if ([self.tfTimeSlept.text integerValue] > 0){
            self.tfTimeSlept.text = [@([self.tfTimeSlept.text integerValue] + 1) stringValue];
        }
        
        
        NSLog(@"Plus ");
        
    }else if (sender == self.btMinus){
        
        if ([self.tfTimeSlept.text isEqualToString:@""]) {
            NSLog(@"No puede restar un espacio vacio");
            
        }else if ([self.tfTimeSlept.text integerValue] > 0){
            self.tfTimeSlept.text = [@([self.tfTimeSlept.text integerValue] - 1) stringValue];
            
        }else if ([self.tfTimeSlept.text integerValue] == 0){
            self.tfTimeSlept.text = @"";
        }
        
        NSLog(@"Minus ");
    }
}
@end