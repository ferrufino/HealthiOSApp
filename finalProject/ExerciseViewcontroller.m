//
//  ThirdViewController.m
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "ExerciseViewcontroller.h"
#import "FoodViewController.h"
#import "UIColor+FSPalette.h"
#import "QuartzCore/QuartzCore.h"
#import "Canvas.h"
#import <ChameleonFramework/Chameleon.h>

#define TAG_First 1
#define TAG_Second 2

@interface ExerciseViewcontroller ()
@property  UIAlertView *alert2;
@property CSAnimationView *animationView;
@property NSArray *fetchResults;
@property NSManagedObject *lastRecord;
@property BOOL show;
@property BOOL mustAnswer;
@property NSMutableArray *suggestions;
@end

@implementation ExerciseViewcontroller
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setQuestionView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
     [self loadGraphData];
    /*****Vertical Scroll***/
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
    
    
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(50, 560 , 280, 185)];
    
    _animationView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1];
    
    _animationView.layer.cornerRadius = 55.0;
    _animationView.layer.borderWidth = 0.5;
    _animationView.layer.borderColor =(__bridge CGColorRef)([UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:199.0/255.0 alpha:1]);


    _animationView.duration = 0.5;
    _animationView.delay    = 0;
    _animationView.type     = CSAnimationTypeFadeInUp;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(cardPressed)];
    
    [_animationView addGestureRecognizer:singleFingerTap];
    
    
    self.suggestions = [[NSMutableArray alloc] initWithObjects:@"sug 1", @"sug 2", @"sug 3",
                        @"sug 4",@"sug 5", @"Welcome! Please input data to see suggestions",nil];
    
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:[self.suggestions objectAtIndex: [self loadSuggestion]]];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [labelSuggestion setNumberOfLines:0];
    
    CGRect frame;
    
    frame =labelSuggestion.frame;
    frame.size.width +=70;
    labelSuggestion.frame=frame;
    
    [self.tfAnareobico setKeyboardType:UIKeyboardTypeNumberPad];
    [self.tfAreobico setKeyboardType:UIKeyboardTypeNumberPad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(quitaTeclado)];
    [self.view addGestureRecognizer:tap];

    [_animationView addSubview:labelSuggestion];

    [self.scrollView addSubview:_animationView];
    
    
    //Graph
    // Create a gradient to apply to the bottom portion of the graph
    //Graph
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.exerciseGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.exerciseGraph.enableTouchReport = YES;
    self.exerciseGraph.enablePopUpReport = YES;
    self.exerciseGraph.enableYAxisLabel = YES;
    self.exerciseGraph.autoScaleYAxis = YES;
    self.exerciseGraph.alwaysDisplayDots = NO;
    self.exerciseGraph.enableReferenceXAxisLines = YES;
    self.exerciseGraph.enableReferenceYAxisLines = YES;
    self.exerciseGraph.enableReferenceAxisFrame = YES;
    self.exerciseGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.exerciseGraph.averageLine.enableAverageLine = YES;
    self.exerciseGraph.averageLine.alpha = 0.6;
    self.exerciseGraph.averageLine.color = [UIColor darkGrayColor];
    self.exerciseGraph.averageLine.width = 2.5;
    self.exerciseGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.exerciseGraph.colorXaxisLabel = [UIColor whiteColor];
    self.exerciseGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.exerciseGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.exerciseGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.exerciseGraph.formatStringForValues = @"%.1f";
    
}

- (void) setQuestionView {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseRecord"
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
        _mustAnswer = NO;
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }else{
        _mustAnswer = YES;
        self.questionView.hidden = NO;
        self.scrollView.frame = CGRectMake(0,325,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
    }
    
}


-(IBAction) cardPressed {
   
        _animationView.type = CSAnimationTypeShake;
         [_animationView startCanvasAnimation];
    
    NSLog(@"Click");

}

- (void)quitaTeclado {
    [self.view endEditing:YES];
    
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = nil;
    
    if (_mustAnswer) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }else{
    
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Input" style:nil target:self action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = anotherButton;
  
    [self.tabBarController.tabBar setTintColor:[UIColor flatWatermelonColor]];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatWatermelonColor]];
    [self.view setTintColor:[UIColor flatWatermelonColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatWatermelonColor]}];
    }
    
    _animationView.type     = CSAnimationTypeFadeInUp;
    [_animationView startCanvasAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnAgrega:(UIButton *)sender {
   
    
    if (!_mustAnswer) {
        if (_show) {
            _show = NO;
            self.questionView.hidden = YES;
            self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            
        }else{
            
            _show = YES;
            self.questionView.hidden = NO;
            self.scrollView.frame = CGRectMake(0,325,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            
        }
        
    }
}



- (IBAction)buttonPressed:(UIButton *)sender {
    
    if (sender == self.btPlusAreobico) {
        
        if ([self.tfAreobico.text isEqualToString:@""]) {
            
            self.tfAreobico.text = [@(5) stringValue];
            
        }else if ([self.tfAreobico.text integerValue] > 0){
             self.tfAreobico.text = [@([self.tfAreobico.text integerValue] + 5) stringValue];
        }
        
        
        NSLog(@"Plus Areobico");
        
    }else if (sender == self.btMinusAreobico){
        
        if ([self.tfAreobico.text isEqualToString:@""]) {
           NSLog(@"No puede restar un espacio vacio");
            
        }else if ([self.tfAreobico.text integerValue] > 0){
             self.tfAreobico.text = [@([self.tfAreobico.text integerValue] - 5) stringValue];
            
        }else if ([self.tfAreobico.text integerValue] == 0){
            self.tfAreobico.text = @"";
        }
        
        NSLog(@"Minus Areobico");
    }else if (sender == self.btPlusAnareobico){
        
        if ([self.tfAnareobico.text isEqualToString:@""]) {
            
            self.tfAnareobico.text = [@(5) stringValue];
            
        }else if ([self.tfAnareobico.text integerValue] > 0){
            self.tfAnareobico.text = [@([self.tfAnareobico.text integerValue] + 5) stringValue];
        }
        
        NSLog(@"Plus Anareobico");
        
    }else if (sender == self.btMinusAnareobico){
        
        
        if ([self.tfAnareobico.text isEqualToString:@""]) {
             NSLog(@"No puede restar un espacio vacio");
            
        }else if ([self.tfAnareobico.text integerValue] > 0){
            self.tfAnareobico.text = [@([self.tfAnareobico.text integerValue] - 5) stringValue];
            
        }else if ([self.tfAnareobico.text integerValue] == 0){
            self.tfAnareobico.text = @"";
            
        }
         NSLog(@"Minus Anareobico");
    
    }else{
        NSLog(@"Bro something's wrong");
    }
}
-(NSInteger)loadSuggestion{
    /*
    double acum = 0.0;
    double cont = 0.0;
    for (int i=0; i< [self.arrayOfValues count]; i++){
        NSLog(@"[%d]:%@",i,self.arrayOfValues[i]);
        
        if ([self.arrayOfValues objectAtIndex:i] != 0) {
            acum += [[self.arrayOfValues objectAtIndex:i] doubleValue];
            cont++;
        }
        
    }
     
    if([self.arrayOfValues count] == 0){
        
        return 5;
        
    }
    acum/=cont;
    acum/=cont;
    
    acum *= 5;
    
    
    return acum;
    */
    return 5;
    
    
    
}

- (IBAction)submit:(id)sender {
    
    if ((![self.tfAreobico.text isEqualToString:@""] && ![self.tfAnareobico.text isEqualToString:@""]) || [self.tfAnareobico.text isEqualToString:@""] || [self.tfAreobico.text isEqualToString:@""]) {
        _show = NO;
        
        
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        if (!self.lastRecord) {
            self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseRecord"
                                                            inManagedObjectContext:context];
        }
        NSDate *date = [NSDate date];
        CGFloat durationAreobico = [self.tfAreobico.text floatValue];
        
        [self.lastRecord setValue:date forKey:@"date"];
        
        if (![self.tfAreobico.text isEqualToString:@""]) {
            [self.lastRecord setValue:@(durationAreobico) forKey:@"aerobicDuration"];
        }
        
        if (![self.tfAnareobico.text isEqualToString:@""]) {
            [self.lastRecord setValue:@(durationAreobico) forKey:@"anaerobicDuration"];
            
        }
        
        NSError *error;
        [context save:&error];

        
        
        
    }
    
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
    return [[self.arrayOfValuesA objectAtIndex:index] doubleValue];
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSManagedObject *record;
    NSPredicate *predicate;
    NSArray *fetchResults;
    self.arrayOfValuesA = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *duration = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            duration = [record valueForKey:@"anaerobicDuration"];
        }
        [self.arrayOfValuesA addObject:duration];
    }
    
    [self.arrayOfDates removeObjectAtIndex:7];
    self.arrayOfDates = [[[self.arrayOfDates reverseObjectEnumerator] allObjects] mutableCopy];
    self.arrayOfValuesA = [[[self.arrayOfValuesA reverseObjectEnumerator] allObjects] mutableCopy];
    
    
}


@end
