//
//  FirstViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DateUtilities.h"
#import "UIColor+FSPalette.h"



@interface FirstViewController () {
    int previousStepperValue;
    int totalNumber;
}
@property NSManagedObject *lastRecord;
@property  UIAlertView *alert;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGraphData];
  
    //Scroll View
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 800)];

    // Pop -up
    _alert = [[UIAlertView alloc] initWithTitle:@"Agrega Sueño" message:@"Ingresa la cantidad de horas dormidas:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    _alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * alertTextField = [_alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"horas";
   
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
    
    
    
    

    //Animated cards
    testView  = [[UIView alloc]initWithFrame:CGRectMake(50, 500, 280, 185)];
    testView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1];
    testView.layer.cornerRadius = 5.0; // set cornerRadius as you want.
    testView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    testView.layer.borderWidth = 1.0; // set borderWidth as you want.
    
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:@"Sugerencia"];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [testView addSubview:labelSuggestion];
    [self.scrollView addSubview:testView];

}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                              action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
     [self goAnimation];
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
     [_alert show];
}

- (IBAction)btnConfirma:(UIButton *)sender {
    self.FormaSue.hidden = true;
    
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


//Card Animation

//Animated Card
- (void) goAnimation
{
    
    
    
    [UIView beginAnimations:@"1" context:NULL];
    [UIView setAnimationDuration:0.8f];
    // 设置最终视图路径
    testView.frame = CGRectMake(testView.frame.origin.x-30, testView.frame.origin.y - 200, testView.frame.size.width, testView.frame.size.height);
    // 设置最终视图旋转
    testView.transform = CGAffineTransformMakeRotation(- (10.0f * M_PI) / 180.0f);
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(next)];  //执行完调用返回缩小函数
    [UIView commitAnimations];
    
    // 设置最终视图放大倍数
    CGAffineTransform transform = testView.transform;
    transform = CGAffineTransformScale(transform, 1.2 ,1.2);
    testView.transform = transform;
    
    
}


-(void)next{
    
    [self.view bringSubviewToFront:testView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    
    testView.transform = CGAffineTransformMakeRotation((0.0f) / 180.0f);
    testView.frame = CGRectMake(50, 500, 280, 185);
    
    [UIView setAnimationDelegate:self];
    // 如果不需要执行的弹跳可不执行
    [UIView setAnimationDidStopSelector: @selector(bounceAnimationStopped)];
    
    [UIView commitAnimations];
    
}

#pragma -
#pragma mark  阻尼弹跳

- (void)bounceAnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 20, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce2AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce2AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 20, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce3AnimationStopped)];
    
    [UIView commitAnimations];
    
}



- (void)bounce3AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 10, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce4AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce4AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 10, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce5AnimationStopped)];
    [UIView commitAnimations];
    
}


- (void)bounce5AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 5, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce6AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce6AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 5, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    
}

@end
