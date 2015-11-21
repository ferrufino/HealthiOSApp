//
//  SecondViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SecondViewController.h"
@interface SecondViewController ()
@property HMSegmentedControl *segmentedControlQ1;
@property NSMutableArray *answers;
@property NSInteger numOfQuestion;
@property NSManagedObject *lastRecord;
@property NSArray *fetchResults;
@end

@implementation SecondViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

     [self setQuestionView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadGraphData];
    [self loadQuestionView];
    
    
    /*****Vertical Scroll***/
    [self.verticalScroll setScrollEnabled:YES];
    [self.verticalScroll setContentSize:CGSizeMake(320, 800)];
    
    
    
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
    self.nutriGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.nutriGraph.enableTouchReport = YES;
    self.nutriGraph.enablePopUpReport = YES;
    self.nutriGraph.enableYAxisLabel = YES;
    self.nutriGraph.autoScaleYAxis = YES;
    self.nutriGraph.alwaysDisplayDots = NO;
    self.nutriGraph.enableReferenceXAxisLines = YES;
    self.nutriGraph.enableReferenceYAxisLines = YES;
    self.nutriGraph.enableReferenceAxisFrame = YES;
    self.nutriGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.nutriGraph.averageLine.enableAverageLine = YES;
    self.nutriGraph.averageLine.alpha = 0.6;
    self.nutriGraph.averageLine.color = [UIColor darkGrayColor];
    self.nutriGraph.averageLine.width = 2.5;
    self.nutriGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.nutriGraph.colorXaxisLabel = [UIColor whiteColor];
    self.nutriGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.nutriGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.nutriGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.nutriGraph.formatStringForValues = @"%.1f";
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setQuestionView {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FoodRecord"
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
    
    if (_fetchResults.count != 0) {
        self.horizontalScrollView.hidden = YES;
        self.horizontalView.hidden = YES;
        self.verticalScroll.frame = CGRectMake(0,65,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    }else{
        self.horizontalScrollView.hidden = NO;
        self.horizontalView.hidden = NO;
         self.verticalScroll.frame = CGRectMake(0,225,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    
    }
    
}


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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FoodRecord"
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
        NSNumber *score = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            score = [record valueForKey:@"score"];
        }
        [self.arrayOfValues addObject:score];
    }
    
    [self.arrayOfDates removeObjectAtIndex:7];
    self.arrayOfDates = [[[self.arrayOfDates reverseObjectEnumerator] allObjects] mutableCopy];
    self.arrayOfValues = [[[self.arrayOfValues reverseObjectEnumerator] allObjects] mutableCopy];
    
    
}

- (void)loadQuestionView {
    self.numOfQuestion = 1;
    self.answers = [[NSMutableArray alloc] init];
    


    
    self.horizontalScrollView.frame = CGRectMake(0, 0, 375, 162);
    //Impide que usuario pueda darle scroll
    self.horizontalScrollView.scrollEnabled = NO;
    
    
    
    //SegmentedControl for horizontal scroll view
    _segmentedControlQ1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"1", @"2", @"3", @"4", @"5"]];
    [_segmentedControlQ1 setFrame:CGRectMake(0, 107, self.horizontalScrollView.frame.size.width, 53)];
    [_segmentedControlQ1 setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
        double delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.numOfQuestion == 1) {
                [_answers addObject:@(index+1)];
                [self buttonClicked1];
            }else if (self.numOfQuestion == 2){
                [_answers addObject:@(index+1)];
                [self buttonClicked2];
            }else if(self.numOfQuestion == 3){
                [_answers addObject:@(index+1)];
                [self buttonClicked3];
            }else if(self.numOfQuestion == 4){
                [_answers addObject:@(index+1)];
                [self buttonClicked4];
            }else if(self.numOfQuestion == 5){
                [_answers addObject:@(index+1)];
                [self buttonClicked5];
            }
            
        });
        
    }];
    _segmentedControlQ1.selectionIndicatorHeight = 4.0f;
    _segmentedControlQ1.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    _segmentedControlQ1.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _segmentedControlQ1.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    _segmentedControlQ1.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControlQ1.selectedSegmentIndex = HMSegmentedControlNoSegment;
    _segmentedControlQ1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControlQ1.shouldAnimateUserSelection = NO;
    _segmentedControlQ1.tag = 1;
    [self.horizontalScrollView addSubview:_segmentedControlQ1];
    
    // Create Label 1
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 400, 40)];
    [labelOne setBackgroundColor:[UIColor clearColor]];
    [labelOne setText:@"Incluir gran variedad de frutas y verduras"];
    [labelOne setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelOne];
    
    // Create Label 2
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width+70, 10, 400, 40)];
    [labelTwo setBackgroundColor:[UIColor clearColor]];
    [labelTwo setText:@"Comes seguido cereales integrales?"];
    [labelTwo setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelTwo];
    
    // Create Label 3
    UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*2+70, 10, 400, 80)];
    [labelThree setText:@"Consumes bebidas o comidas con \n azucares con moderación?"];
    labelThree.lineBreakMode = UILineBreakModeWordWrap;
    labelThree.numberOfLines = 0;
    [labelThree setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelThree];
    
    // Create Label 4
    UILabel *labelFour = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*3+70, 10, 400, 80)];
    [labelFour setText:@"Consumes al menos un litro de agua diario?"];
    labelFour.lineBreakMode = UILineBreakModeWordWrap;
    labelFour.numberOfLines = 0;
    [labelFour setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFour];
    
    // Create Label 5
    UILabel *labelFive = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*4+70, 10, 400, 80)];
    [labelFive setText:@"Respetas tus horarios de comida?"];
    labelFive.lineBreakMode = UILineBreakModeWordWrap;
    labelFive.numberOfLines = 0;
    [labelFive setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFive];
    
    //Oculta sidebar scroll
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:NO];

    [self.horizontalScrollView setContentSize:CGSizeMake(self.horizontalScrollView.frame.size.width*5, self.horizontalScrollView.frame.size.height)];
    

    

}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;


}



#pragma mark Question Buttons

-(void) buttonClicked1 {

    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}

-(void) buttonClicked2 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*2;
    _segmentedControlQ1.frame = changePositionInX;
    
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}

-(void) buttonClicked3 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*3;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}

-(void) buttonClicked4 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*4;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*4, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}

-(void) buttonClicked5
{
    
    self.horizontalScrollView.hidden = YES;
    self.verticalScroll.frame = CGRectMake(0,65,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    for (id obj in self.answers) {

        NSLog(@"%@", obj);
    }
    [self saveFoodRecord];
}

#pragma mark Core Data

- (void) saveFoodRecord {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSDate *date = [NSDate date];
    CGFloat averageScore;
    
    for (int i = 0; i < 5; i++) {
        averageScore += [[self.answers objectAtIndex:i] doubleValue];
    }
    
    averageScore /= 5;
    
    NSManagedObject *record = [NSEntityDescription insertNewObjectForEntityForName:@"FoodRecord"
                                                            inManagedObjectContext:context];
    
    [record setValue:date forKey:@"date"];
    [record setValue:@(averageScore) forKey:@"score"];
    
    NSError *error;
    [context save:&error];
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

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" horas";
}



@end
