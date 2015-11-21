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
@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGraphData];
    
    
    
    
    
    
    
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
    
    
    
    
    /*****Vertical Scroll***/
    [self.verticalScroll setScrollEnabled:YES];
    [self.verticalScroll setContentSize:CGSizeMake(320, 800)];
    
    
    //Animated cards
    testView  = [[UIView alloc]initWithFrame:CGRectMake(65, 580, 280, 185)];
    testView.backgroundColor = [UIColor redColor];
    testView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    testView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    testView.layer.borderWidth = 1.0; // set borderWidth as you want.
    
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:@"Sugerencia"];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [testView addSubview:labelSuggestion];
    [self.verticalScroll addSubview:testView];
    
    
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
    

    [self goAnimation];

}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    if ([self.answers count] == 5){
       // self.horizontalScrollView.hidden = YES;
       // self.horizontalView.hidden = YES;
        self.verticalScroll.frame = CGRectMake(0, 65, 375, 578);

        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void) buttonClicked1
{

    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked2
{
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*2;
    _segmentedControlQ1.frame = changePositionInX;
    
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked3
{
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*3;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked4
{
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
    
//    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*5, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
//    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
    self.horizontalScrollView.hidden = YES;
    self.verticalScroll.frame = CGRectMake(0,65,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    for (id obj in self.answers)
        NSLog(@"%@", obj);
    
}

//Animated Card
- (void) goAnimation
{
    
    
    
    [UIView beginAnimations:@"1" context:NULL];
    [UIView setAnimationDuration:0.8f];

    testView.frame = CGRectMake(testView.frame.origin.x-30, testView.frame.origin.y - 200, testView.frame.size.width, testView.frame.size.height);
 
    testView.transform = CGAffineTransformMakeRotation(- (10.0f * M_PI) / 180.0f);
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(next)];
    [UIView commitAnimations];
    

    CGAffineTransform transform = testView.transform;
    transform = CGAffineTransformScale(transform, 1.2 ,1.2);
    testView.transform = transform;
    
    
}


-(void)next{
    
    [self.view bringSubviewToFront:testView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    
    testView.transform = CGAffineTransformMakeRotation((0.0f) / 180.0f);
    testView.frame = CGRectMake(50, 580, 280, 185);
    
    [UIView setAnimationDelegate:self];

    [UIView setAnimationDidStopSelector: @selector(bounceAnimationStopped)];
    
    [UIView commitAnimations];
    
}



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

@end
