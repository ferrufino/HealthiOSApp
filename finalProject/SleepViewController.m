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
#import "Canvas.h"


@interface SleepViewController () {
    int previousStepperValue;
    int totalNumber;
}
@property NSArray *fetchResults;
@property NSManagedObject *lastRecord;
@property  UIAlertView *alert;
@property BOOL show;
@property BOOL edit;
@property BOOL mustAnswer;
@property CSAnimationView *animationView;
@property NSMutableArray *suggestions;
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
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];


    //Suggestion Card
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(50, 560, 280, 185)];
    
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
    
    
    
    
    
    ///Defining and secondary varibales set
    _show = NO;
    _edit = NO;

    [self.tfTimeSlept setKeyboardType:UIKeyboardTypeNumberPad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(quitaTeclado)];
     [self.view addGestureRecognizer:tap];
    
     self.tfTimeSlept.placeholder = @"Ingresa hrs.";
    
   
}

- (void)viewDidAppear:(BOOL)animated {
   
    if (_mustAnswer) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }else{
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Input" style:nil target:self action:@selector(btnAgrega:)];
        self.tabBarController.navigationItem.rightBarButtonItem = anotherButton;
        [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatYellowColor]];
        [self.tabBarController.tabBar setTintColor:[UIColor flatYellowColor]];
        [self.view setTintColor:[UIColor flatYellowColor]];
        [self.navigationController.navigationBar
         setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                                   NSForegroundColorAttributeName: [UIColor flatYellowColor]}];

    
    }
    
    
    
    _animationView.type = CSAnimationTypeFadeInUp;
    [_animationView startCanvasAnimation];
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
        _mustAnswer = NO;
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@" se oculto 1");
    }else{
        _mustAnswer = YES;
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
    if (acum >9 ) {
        acum = 9;
    }
    if(cont == 0){
        
        return 5;
        
    }else if(cont >= 5){
        acum/=cont;
        acum/=cont;
        
        acum *= 5;
    }else if (cont < 5){
        acum/=cont;
    }
    NSLog(@"Valor regresado en sueño::%d",(NSInteger)roundf( acum));
    return roundf( acum-1);
    
    



}

- (IBAction)submit:(id)sender {
   
    if (![self.tfTimeSlept.text isEqualToString:@""]) {
         _show = false;
        _mustAnswer = NO;
        [self.view endEditing:YES];
        self.questionView.hidden = YES;
        self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            NSLog(@" se oculto 2");
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSDate *date = [NSDate date];
        CGFloat averageScore;
        
        //llama al ultimo dato y comparar su date.
        
        averageScore = [self.tfTimeSlept.text floatValue];
        
        NSManagedObject *record = [NSEntityDescription insertNewObjectForEntityForName:@"SleepRecord"
                                                             inManagedObjectContext:context];
         NSError *error = nil;
        
        ///
        if (_edit) {
            _edit = false;
            NSLog(@"esto edita entrada");
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"SleepRecord" inManagedObjectContext:context]];
            
           
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@",date];
            [request setPredicate:predicate];
            
            
            NSArray *resultDesc = [[[results reverseObjectEnumerator] allObjects] mutableCopy];
            record = [resultDesc lastObject];
            [record setValue:@(averageScore) forKey:@"duration"];
            
        }else{
            
            [record setValue:date forKey:@"date"];
            [record setValue:@(averageScore) forKey:@"duration"];
            NSLog(@"esto es una nueva entrada");
        
        }
        
        
        
        ///
        
        
        
        
        
        
    
        [context save:&error];

    }
    
}
- (IBAction)pressedButton:(UIButton *)sender {
    if (sender == self.btPlus) {
        
        if ([self.tfTimeSlept.text isEqualToString:@""]) {
            
            self.tfTimeSlept.text = [@(1) stringValue];
            
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
