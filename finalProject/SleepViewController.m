//
//  FirstViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SleepViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "Canvas.h"


@interface SleepViewController () {
    int previousStepperValue;
    int totalNumber;
}
@property NSArray *fetchResults;
@property NSManagedObject *lastRecord;
@property  UIAlertView *alert;
@property CSAnimationView *animationView;
@property NSMutableArray *suggestions;
@property BOOL show;
@property BOOL edit;
@property BOOL mustAnswer;

@end

@implementation SleepViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setQuestionView];
    self.view.backgroundColor = [UIColor flatNavyBlueColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGraphData];
    
    //Scroll View
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];


    //Suggestion Card
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(50, 560, 280, 185)];
    
    _animationView.backgroundColor = [UIColor flatYellowColor];
    
    _animationView.layer.cornerRadius = 10.0;
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
    
    
    [_animationView addSubview:labelSuggestion];
    
    [self.scrollView addSubview:_animationView];

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
    self.sleepGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    UIColor *start = [UIColor flatYellowColor];
    UIColor *end = [start colorWithAlphaComponent:0];
    NSArray *colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)end.CGColor, nil];
    
    // Apply the gradient to the bottom portion of the graph
    self.sleepGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays rgb(52,73,94) rgb(231,76,60)
    self.sleepGraph.colorTop = [UIColor flatNavyBlueColor];
    self.sleepGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.sleepGraph.colorLine = [UIColor flatYellowColor];
    self.sleepGraph.enableTouchReport = YES;
    self.sleepGraph.enablePopUpReport = YES;
    self.sleepGraph.enableYAxisLabel = NO;
    self.sleepGraph.autoScaleYAxis = YES;
    self.sleepGraph.alwaysDisplayDots = NO;
    self.sleepGraph.enableReferenceXAxisLines = NO;
    self.sleepGraph.enableReferenceYAxisLines = YES;
    self.sleepGraph.enableReferenceAxisFrame = YES;
    self.sleepGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.sleepGraph.averageLine.enableAverageLine = YES;
    self.sleepGraph.averageLine.alpha = 0.3;
    self.sleepGraph.averageLine.color = [UIColor flatWhiteColor];
    self.sleepGraph.averageLine.width = 2.5;
    self.sleepGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.sleepGraph.colorXaxisLabel = [UIColor flatYellowColor];
    self.sleepGraph.colorYaxisLabel = [UIColor flatYellowColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.sleepGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.sleepGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.sleepGraph.formatStringForValues = @"%.1f";
    
    ///Defining and secondary varibales set
    _show = NO;
    _edit = NO;

       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(quitaTeclado)];
     [self.view addGestureRecognizer:tap];
    
    [self loadGraphData];
    [self.sleepGraph reloadGraph];
    
   
}

- (void)viewDidAppear:(BOOL)animated {
    if (_mustAnswer) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }else{
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_mode_edit_18pt"]
                                                               style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(editInput:)];
        self.tabBarController.navigationItem.rightBarButtonItem = editButton;
    }
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatYellowColor]];
    [self.tabBarController.tabBar setTintColor:[UIColor flatYellowColor]];
    [self.view setTintColor:[UIColor flatNavyBlueColorDark]];
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatYellowColor]}];
    
    _animationView.type = CSAnimationTypeFadeInUp;
    [_animationView startCanvasAnimation];
    
    self.sleepStepper.maximumValue = 14.0;
    self.sleepStepper.stepValue = 0.5;
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
    self.fetchResults = [context executeFetchRequest:request error:&error];
    
    if ((self.fetchResults.count != 0) && !_show) {
        _mustAnswer = NO;
        
        self.lastRecord = [self.fetchResults objectAtIndex:0];
        double duration = [[self.lastRecord valueForKey:@"duration"] doubleValue];
        [self.sleepHoursLabel setText:[NSString stringWithFormat:@"%.01f", duration]];
        self.sleepStepper.value = duration;
        
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@" se oculto 1");
    } else {
        _mustAnswer = YES;
        self.questionView.hidden = NO;
        self.scrollView.frame = CGRectMake(0,210,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
    }
    
}
-(IBAction) cardPressed {
    
    _animationView.type = CSAnimationTypeShake;
    [_animationView startCanvasAnimation];
    
    NSLog(@"Click");
    [self loadSuggestion];
    
}
- (void)quitaTeclado {
    [self.view endEditing:YES];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editInput:(UIButton *)sender {
    if (!_mustAnswer) {
        if (_show) {
            _show = NO;
            self.questionView.hidden = YES;
            self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }else{
            _show = YES;
            _edit = YES;
            self.questionView.hidden = NO;
            self.scrollView.frame = CGRectMake(0,210,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
    }
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

-(NSInteger)loadSuggestion{
    
    double acum = 0.0;
    double cont = 0.0;
    for (int i=0; i< [self.arrayOfValues count]; i++){
        
        
        if ([self.arrayOfValues[i] doubleValue] != 0.0) {
            NSLog(@"no debe ser 0 [%d]:%f",i,[self.arrayOfValues[i] doubleValue]);
            acum += [[self.arrayOfValues objectAtIndex:i] doubleValue];
            cont++;
        }
        
    }
    
    if (acum > 8) {
        acum = 8;
    }
    if (acum < 4) {
        acum = 4;
    }
    
   
    
    
    return (cont == 0)? 5 : acum - 3;
    
}

- (IBAction)submit:(id)sender {
    _show = NO;
    _mustAnswer = NO;
    self.questionView.hidden = YES;
    self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@" se oculto 2");
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSDate *date = [NSDate date];
    double duration = [self.sleepHoursLabel.text doubleValue];
    NSError *error;
    
    /// Creates new entry or modifies existing one
    if (_edit) {
        _edit = NO;
        NSLog(@"esto edita entrada");
    } else {
        //Crea el last record
        self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SleepRecord"
                                               inManagedObjectContext:context];
        NSLog(@"esto es una nueva entrada");
    }

    [self.lastRecord setValue:@(duration) forKey:@"duration"];
    [self.lastRecord setValue:date forKey:@"date"];
    [context save:&error];
    [self viewDidAppear:YES];
    
    [self loadGraphData];
    [self.sleepGraph reloadGraph];
}

- (IBAction)pressedStepper:(UIStepper*)sender {
    double value = [sender value];
    [self.sleepHoursLabel setText:[NSString stringWithFormat:@"%.01f", value]];
    
}
@end
