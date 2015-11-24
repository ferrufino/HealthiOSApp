//
//  ThirdViewController.m
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "ExerciseViewcontroller.h"
#import "FoodViewController.h"
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
@property UILabel *labelSuggestion;
@end

@implementation ExerciseViewcontroller
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setQuestionView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatNavyBlueColor];
    
    [self loadGraphData];
    /*****Vertical Scroll***/
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    
    
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * 0.1, self.scrollView.frame.size.height*1.5, self.scrollView.frame.size.width * 0.8, 185)];
    
    _animationView.backgroundColor = [UIColor flatWatermelonColor];
    
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
    
    
    self.suggestions = [[NSMutableArray alloc] initWithObjects:@"Es bueno que reconozcas la necesidad de realizar un cambio. Tu puedes", @"Un paso a la vez, grandes cosas pueden ser logradas si lo intentas!", @"Enfocate en la figura que deseas conseguir", @" El flujo de oxígeno al cerebro aumenta, por lo que la capacidad de aprendizaje, concentración, memoria y estado de alerta pueden mejorar de manera considerable.",@"Manten la rutina, excelente trabajo!", @"Bienvenido! Ingresa datos para poder ver sugerencias de ejericio.",nil];
    
    self.labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [_labelSuggestion
     
     setText:[self.suggestions objectAtIndex: [self loadSuggestion]]];
    [_labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [_labelSuggestion setNumberOfLines:0];
    
    CGRect frame;
    
    frame =_labelSuggestion.frame;
    frame.size.width +=70;
    _labelSuggestion.frame=frame;

    [_animationView addSubview:_labelSuggestion];

    [self.scrollView addSubview:_animationView];
    
    
    //Graph
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = { 0.0, 1.0 };
    
    UIColor *top = [UIColor flatWatermelonColor];
    UIColor *bottom = [top colorWithAlphaComponent:0];
    NSArray *colors = [NSArray arrayWithObjects:(id)top.CGColor, (id)bottom.CGColor, nil];
    
    UILabel *labelAerobico = [[UILabel alloc]initWithFrame:CGRectMake(150,-30, 100, 100)];
    [labelAerobico setText:@"Aerobico"];
    [labelAerobico setFont:[UIFont fontWithName:@"Avenir Black" size:15]];
    [self.scrollView addSubview:labelAerobico];
    labelAerobico.textColor = [UIColor flatWatermelonColor];
    
    
    UILabel *labelAnaerobico = [[UILabel alloc]initWithFrame:CGRectMake(150,300, 100, 100)];
    [labelAnaerobico setText:@"Anaerobico"];
    [labelAnaerobico setFont:[UIFont fontWithName:@"Avenir Black" size:15]];
    [self.scrollView addSubview:labelAnaerobico];
    labelAnaerobico.textColor = [UIColor flatWatermelonColor];
    
    // Apply the gradient to the bottom portion of the graph
    self.exerciseGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays
    self.exerciseGraph.colorTop = [UIColor flatNavyBlueColor];
    self.exerciseGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.exerciseGraph.colorLine = [UIColor flatWatermelonColor];
    self.exerciseGraph.enableTouchReport = YES;
    self.exerciseGraph.enablePopUpReport = YES;
    self.exerciseGraph.enableYAxisLabel = NO;
    self.exerciseGraph.autoScaleYAxis = YES;
    self.exerciseGraph.alwaysDisplayDots = NO;
    self.exerciseGraph.enableReferenceXAxisLines = NO;
    self.exerciseGraph.enableReferenceYAxisLines = YES;
    self.exerciseGraph.enableReferenceAxisFrame = YES;
    self.exerciseGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.exerciseGraph.averageLine.enableAverageLine = YES;
    self.exerciseGraph.averageLine.alpha = 0.3;
    self.exerciseGraph.averageLine.color = [UIColor whiteColor];
    self.exerciseGraph.averageLine.width = 2.5;
    self.exerciseGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.exerciseGraph.colorXaxisLabel = [UIColor flatWatermelonColor];
    self.exerciseGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.exerciseGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.exerciseGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.exerciseGraph.formatStringForValues = @"%.1f";
    
    ////Anaerobic Graph
    // Apply the gradient to the bottom portion of the graph
    self.exerciseGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays
    self.exerciseGraph.colorTop = [UIColor flatNavyBlueColor];
    self.exerciseGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.exerciseGraph.colorLine = [UIColor flatWatermelonColor];
    self.exerciseGraph.enableTouchReport = YES;
    self.exerciseGraph.enablePopUpReport = YES;
    self.exerciseGraph.enableYAxisLabel = NO;
    self.exerciseGraph.autoScaleYAxis = YES;
    self.exerciseGraph.alwaysDisplayDots = NO;
    self.exerciseGraph.enableReferenceXAxisLines = NO;
    self.exerciseGraph.enableReferenceYAxisLines = YES;
    self.exerciseGraph.enableReferenceAxisFrame = YES;
    self.exerciseGraph.enableBezierCurve = YES;
    
    //////
    //////
    //////
    // Apply the gradient to the bottom portion of the graph
    // Apply the gradient to the bottom portion of the graph
    self.exerciseAnaerobicGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays
    self.exerciseAnaerobicGraph.colorTop = [UIColor flatNavyBlueColor];
    self.exerciseAnaerobicGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.exerciseAnaerobicGraph.colorLine = [UIColor flatWatermelonColor];
    self.exerciseAnaerobicGraph.enableTouchReport = YES;
    self.exerciseAnaerobicGraph.enablePopUpReport = YES;
    self.exerciseAnaerobicGraph.enableYAxisLabel = NO;
    self.exerciseAnaerobicGraph.autoScaleYAxis = YES;
    self.exerciseAnaerobicGraph.alwaysDisplayDots = NO;
    self.exerciseAnaerobicGraph.enableReferenceXAxisLines = NO;
    self.exerciseAnaerobicGraph.enableReferenceYAxisLines = YES;
    self.exerciseAnaerobicGraph.enableReferenceAxisFrame = YES;
    self.exerciseAnaerobicGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.exerciseAnaerobicGraph.averageLine.enableAverageLine = YES;
    self.exerciseAnaerobicGraph.averageLine.alpha = 0.3;
    self.exerciseAnaerobicGraph.averageLine.color = [UIColor whiteColor];
    self.exerciseAnaerobicGraph.averageLine.width = 2.5;
    self.exerciseAnaerobicGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.exerciseAnaerobicGraph.colorXaxisLabel = [UIColor flatWatermelonColor];
    self.exerciseAnaerobicGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.exerciseAnaerobicGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.exerciseAnaerobicGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.exerciseAnaerobicGraph.formatStringForValues = @"%.1f";
    
    ////Anaerobic Graph
    // Apply the gradient to the bottom portion of the graph
    self.exerciseAnaerobicGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays
    self.exerciseAnaerobicGraph.colorTop = [UIColor flatNavyBlueColor];
    self.exerciseAnaerobicGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.exerciseAnaerobicGraph.colorLine = [UIColor flatWatermelonColor];
    self.exerciseAnaerobicGraph.enableTouchReport = YES;
    self.exerciseAnaerobicGraph.enablePopUpReport = YES;
    self.exerciseAnaerobicGraph.enableYAxisLabel = NO;
    self.exerciseAnaerobicGraph.autoScaleYAxis = YES;
    self.exerciseAnaerobicGraph.alwaysDisplayDots = NO;
    self.exerciseAnaerobicGraph.enableReferenceXAxisLines = NO;
    self.exerciseAnaerobicGraph.enableReferenceYAxisLines = YES;
    self.exerciseAnaerobicGraph.enableReferenceAxisFrame = YES;
    self.exerciseAnaerobicGraph.enableBezierCurve = YES;
    
    self.aerobicStepper.maximumValue = 1000;
    self.aerobicStepper.stepValue = 5.0;
    
    self.anaerobicStepper.maximumValue = 1000;
    self.anaerobicStepper.stepValue = 5.0;
    
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
        
        self.lastRecord = [self.fetchResults objectAtIndex:0];
        NSInteger aerobicDuration = [[self.lastRecord valueForKey:@"aerobicDuration"] integerValue];
        NSInteger anaerobicDuration = [[self.lastRecord valueForKey:@"anaerobicDuration"] integerValue];
        
        [self.aerobicMinutesLabel setText:[NSString stringWithFormat:@"%ld", (long)aerobicDuration]];
        [self.anaerobicMinutesLabel setText:[NSString stringWithFormat:@"%ld", (long)anaerobicDuration]];
        
        self.aerobicStepper.value = aerobicDuration;
        self.anaerobicStepper.value = anaerobicDuration;
        
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
     [self loadGraphData];
    self.labelSuggestion.text = [self.suggestions objectAtIndex:[self loadSuggestion]];
    
    NSLog(@"Click");
}

- (void)quitaTeclado {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = nil;
    
    if (_mustAnswer) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    } else {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"ic_mode_edit_18pt"]
                                      style:UIBarButtonItemStylePlain target:self
                                      action:@selector(editInput:)];
        self.tabBarController.navigationItem.rightBarButtonItem = editButton;
    }
    
    [self.tabBarController.tabBar setTintColor:[UIColor flatWatermelonColor]];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatWatermelonColor]];
    [self.view setTintColor:[UIColor flatNavyBlueColorDark]];
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatWatermelonColor]}];
    _animationView.type = CSAnimationTypeFadeInUp;
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


- (IBAction)editInput:(UIButton *)sender {
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

-(NSInteger)loadSuggestion{

    double aerobicWeekly = 0.0;
    double anaerobicWeekly = 0.0;
    BOOL empty = YES;
    for (int i=0; i< [self.arrayOfValuesA count]; i++){
        NSLog(@"[%d]:%@",i,self.arrayOfValuesA[i]);
        
        if ([self.arrayOfValuesA objectAtIndex:i] != 0) {
            empty = NO;
            aerobicWeekly += [[self.arrayOfValuesA objectAtIndex:i] doubleValue];
      
        }
        
    }
    
    for (int i=0; i< [self.arrayOfValuesAna count]; i++){
        NSLog(@"[%d]:%@",i,self.arrayOfValuesAna[i]);
        
        if ([self.arrayOfValuesAna objectAtIndex:i] != 0) {
            empty = NO;
            anaerobicWeekly += [[self.arrayOfValuesAna objectAtIndex:i] doubleValue];
          
        }
        
    }
    if (aerobicWeekly > 210) {
        aerobicWeekly = 200;
    }
    if (aerobicWeekly < 90) {
        aerobicWeekly = 90;
    }
    
    if (anaerobicWeekly > 210) {
        anaerobicWeekly = 210;
    }
    if (anaerobicWeekly < 90) {
        anaerobicWeekly = 90;
    }
    
    CGFloat aerobicScore = ((aerobicWeekly - 60) / (210 - 60)) * 5;
    CGFloat anaerobicScore = ((anaerobicWeekly - 60) / (210 - 60)) * 5;
    
    CGFloat score = (aerobicScore + anaerobicScore) / 2;
    
    
    return empty?5:score-1;
}

- (IBAction)submit:(id)sender {
    _show = NO;
    _mustAnswer = NO;
    self.questionView.hidden = YES;
    self.scrollView.frame = CGRectMake(0,62,self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (!self.lastRecord) {
        self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseRecord"
                                                        inManagedObjectContext:context];
    }
    NSDate *date = [NSDate date];
    CGFloat aerobicDuration = [self.aerobicMinutesLabel.text floatValue];
    CGFloat anaerobicDuration = [self.anaerobicMinutesLabel.text floatValue];
    
    [self.lastRecord setValue:date forKey:@"date"];
    [self.lastRecord setValue:@(aerobicDuration) forKey:@"aerobicDuration"];
    [self.lastRecord setValue:@(anaerobicDuration) forKey:@"anaerobicDuration"];
    
    NSError *error;
    [context save:&error];
    
    [self viewDidAppear:YES];
    [self loadGraphData];
    [self.exerciseGraph reloadGraph];
    [self.exerciseAnaerobicGraph reloadGraph];
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
    
    if (graph == self.exerciseGraph) {
        return [[self.arrayOfValuesA objectAtIndex:index] doubleValue];

    } else {
        return [[self.arrayOfValuesAna objectAtIndex:index] doubleValue];

    }
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
    return @" minutos";
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
    self.arrayOfValuesAna = [[NSMutableArray alloc] init];
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *durationAerobic = [[NSNumber alloc] initWithFloat:0];
        NSNumber *durationAnaerobic = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            durationAerobic = [record valueForKey:@"aerobicDuration"];
            durationAnaerobic = [record valueForKey:@"anaerobicDuration"];
        }
        [self.arrayOfValuesA addObject:durationAerobic];
        [self.arrayOfValuesAna addObject:durationAnaerobic];
    }
    
    [self.arrayOfDates removeObjectAtIndex:7];
    self.arrayOfDates = [[[self.arrayOfDates reverseObjectEnumerator] allObjects] mutableCopy];
    self.arrayOfValuesA = [[[self.arrayOfValuesA reverseObjectEnumerator] allObjects] mutableCopy];
    self.arrayOfValuesAna = [[[self.arrayOfValuesAna reverseObjectEnumerator] allObjects] mutableCopy];
}

- (IBAction)pressedAerobicStepper:(UIStepper *)sender {
    int value = [sender value];
    [self.aerobicMinutesLabel setText:[NSString stringWithFormat:@"%d", value]];
}

- (IBAction)pressedAnaerobicStepper:(UIStepper *)sender {
    int value = [sender value];
    [self.anaerobicMinutesLabel setText:[NSString stringWithFormat:@"%d", value]];
}
@end
