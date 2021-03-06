//
//  SecondViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "FoodViewController.h"
#import "Canvas.h"
#import <ChameleonFramework/Chameleon.h>
#import "InfoViewController.h"

@interface FoodViewController ()
@property HMSegmentedControl *segmentedControlQ1;
@property NSMutableArray *answers;
@property NSInteger numOfQuestion;
@property NSManagedObject *lastRecord;
@property NSArray *fetchResults;
@property NSMutableArray *suggestions;
@property CSAnimationView *animationView;
@property UIView *infoNutriRank;
@property BOOL mustAnswer;
@property BOOL show;
@property BOOL edit;
@property UILabel *labelSuggestion;
@property InfoViewController *pop;
@property  UIButton *button;

@end

@implementation FoodViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

     [self setQuestionView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatNavyBlueColor];
    
    [self loadGraphData];
    [self loadQuestionView];
    
    /*****Vertical Scroll***/
    [self.verticalScroll setScrollEnabled:YES];
    [self.verticalScroll setContentSize:CGSizeMake(320, 1000)];
    
    
    

    
    //Pop Info
    _pop = [[InfoViewController alloc] init];
    CGRect frameInfo;
    
    frameInfo =_pop.view.frame;
    frameInfo.origin.x = 0;
    _pop.view.frame=frameInfo;
    _pop.view.hidden = YES;
    
    [self.view addSubview:_pop.view];
    
    
    //Suggestion Card
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(self.verticalScroll.frame.size.width * 0.1, self.verticalScroll.frame.size.height*0.9, self.verticalScroll.frame.size.width * 0.8, 185)];
    
    _animationView.backgroundColor = [UIColor flatMintColor];
    
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
    

    self.suggestions = [[NSMutableArray alloc] initWithObjects:@"Es bueno que reconozcas la necesidad de realizar un cambio. Tu puedes", @"Empieza con cosas pequeñas, consume frutas y agua. Dale un intento!", @"Procura controlar tu consumo de azucares y sales. Veras como es bueno para tu salud",@"Procura tener horarios exactos para cada plato del día. Estas dando los primeros pasos, crear un habito toma tiempo!" ,@"Tienes una muy buena dieta, sigue así!",@"Bienvenido, ingresa datos para poder ver las sugerencias",nil];

    
    _labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,20, 100, 150)];
    [_labelSuggestion setText:[self.suggestions objectAtIndex: [self loadSuggestion]]];
    [_labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [_labelSuggestion setNumberOfLines:0];
    
    CGRect frame;
    
    frame =_labelSuggestion.frame;
    frame.size.width +=70;
    _labelSuggestion.frame=frame;
    
    
    [_animationView addSubview:_labelSuggestion];
    
    [self.verticalScroll addSubview:_animationView];
    

    //Graph
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = { 0.0, 1.0 };

    UIColor *mint = [UIColor flatMintColor];
    UIColor *black = [mint colorWithAlphaComponent:0];
    NSArray *colors = [NSArray arrayWithObjects:(id)mint.CGColor, (id)black.CGColor, nil];
    
    // Apply the gradient to the bottom portion of the graph
    self.nutriGraph.gradientBottom = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    // Enable and disable various graph properties and axis displays rgb(52,73,94) rgb(231,76,60)
    self.nutriGraph.colorTop = [UIColor flatNavyBlueColor];
    self.nutriGraph.colorBottom = [UIColor flatNavyBlueColor];
    self.nutriGraph.colorLine = [UIColor flatMintColor];
    self.nutriGraph.widthLine = 2.0;
    self.nutriGraph.alphaTop = 1.0;
    self.nutriGraph.enableTouchReport = YES;
    self.nutriGraph.enablePopUpReport = YES;
    self.nutriGraph.enableYAxisLabel = NO;
    self.nutriGraph.autoScaleYAxis = YES;
    self.nutriGraph.alwaysDisplayDots = NO;
    self.nutriGraph.enableReferenceXAxisLines = NO;
    self.nutriGraph.enableReferenceYAxisLines = YES;
    self.nutriGraph.enableReferenceAxisFrame = YES;
    self.nutriGraph.enableBezierCurve = YES;
    
    // Draw an average line
    self.nutriGraph.averageLine.enableAverageLine = YES;
    self.nutriGraph.averageLine.alpha = 0.3;
    self.nutriGraph.averageLine.color = [UIColor whiteColor];
    self.nutriGraph.averageLine.width = 2.5;
    self.nutriGraph.averageLine.dashPattern = @[@(2),@(2)];
    self.nutriGraph.colorXaxisLabel = [UIColor flatMintColor];
    self.nutriGraph.colorYaxisLabel = [UIColor whiteColor];
    
    // Set the graph's animation style to draw, fade, or none
    self.nutriGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.nutriGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.nutriGraph.formatStringForValues = @"%.1f";
    

    ///Defining and secondary varibales set
    _show = NO;
    _edit = NO;


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
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatMintColor]];
    [self.tabBarController.tabBar setTintColor:[UIColor flatMintColor]];
    [self.view setTintColor:[UIColor flatMintColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatMintColor]}];
    
    _animationView.type = CSAnimationTypeFadeInUp;
    [_animationView startCanvasAnimation];
    
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
        _mustAnswer = NO;
        
        self.lastRecord = [self.fetchResults objectAtIndex:0];
        
        self.horizontalScrollView.hidden = YES;
        self.horizontalView.hidden = YES;
        self.verticalScroll.frame = CGRectMake(0,62,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    }else{
        _mustAnswer = YES;
        self.horizontalScrollView.hidden = NO;
        self.horizontalView.hidden = NO;
        self.verticalScroll.frame = CGRectMake(0,290,
                                               self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
        
    }
    
}


-(IBAction) cardPressed {
    
    _animationView.type = CSAnimationTypeShake;
    [_animationView startCanvasAnimation];
    [self loadGraphData];
    self.labelSuggestion.text = [self.suggestions objectAtIndex:[self loadSuggestion]];
    
    NSLog(@"Click: %d",[self loadSuggestion]);
    
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
    if(cont == 0){
        
        return 5;
        
    }else if(cont >= 5){
    acum/=cont;
    acum/=cont;
    
    acum *= 5;
    }else if (cont < 5){
        acum/=cont;
    }
     NSLog(@"Valor regresado en nutri::%d",(NSInteger)roundf( acum));
    return roundf( acum-1);
}

- (IBAction) editInput:(UIButton *)sender {
    if (!_mustAnswer) {
        if (_show) {
            _show = NO;
            self.horizontalScrollView.hidden = YES;
           self.verticalScroll.frame = CGRectMake(0, 62,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
            
        }else{
            self.numOfQuestion = 1;
            
            _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
            
            CGRect changePositionInX = _segmentedControlQ1.frame;
            changePositionInX.origin.x = 0;
            _segmentedControlQ1.frame = changePositionInX;
            
            CGRect frame = CGRectMake(0, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
            [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
            
            _show = YES;
            _edit = YES;
            self.horizontalScrollView.hidden = NO;
            self.verticalScroll.frame = CGRectMake(0, 290,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.horizontalScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 162);
    //Impide que usuario pueda darle scroll
    self.horizontalScrollView.scrollEnabled = NO;
    
    [self.horizontalScrollView setBackgroundColor:[UIColor flatMintColor]];
    [self.horizontalView setBackgroundColor:[UIColor flatMintColor]];

    //SegmentedControl for horizontal scroll view
    _segmentedControlQ1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"1", @"2", @"3", @"4", @"5"]];
    [_segmentedControlQ1 setFrame:CGRectMake(0, 110, self.horizontalScrollView.frame.size.width, 53)];
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
    _segmentedControlQ1.backgroundColor = [UIColor flatMintColorDark];
    
    _segmentedControlQ1.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Heavy" size:18], NSForegroundColorAttributeName : [UIColor flatNavyBlueColorDark]};
    _segmentedControlQ1.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    _segmentedControlQ1.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControlQ1.selectedSegmentIndex = HMSegmentedControlNoSegment;
    _segmentedControlQ1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControlQ1.shouldAnimateUserSelection = NO;
    _segmentedControlQ1.tag = 1;
    
    [self.horizontalScrollView addSubview:_segmentedControlQ1];
    [self setQuestionLabels];
    
    //Oculta sidebar scroll
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:NO];

    [self.horizontalScrollView setContentSize:CGSizeMake(self.horizontalScrollView.frame.size.width*5, self.horizontalScrollView.frame.size.height)];
}

#pragma mark Question Buttons

-(void) buttonClicked1 {

    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width;
    _segmentedControlQ1.frame = changePositionInX;
    
    //Btn Info
    _button.frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height-_segmentedControlQ1.frame.size.height);
    [_pop setTxt:@"hola 1" ];
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
    
   
}

-(void) buttonClicked2 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*2;
    _segmentedControlQ1.frame = changePositionInX;
    
    _button.frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height-_segmentedControlQ1.frame.size.height);
     [_pop setTxt:@"hola 2" ];

    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
    
}

-(void) buttonClicked3 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*3;
    _segmentedControlQ1.frame = changePositionInX;
    
    _button.frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height-_segmentedControlQ1.frame.size.height);
     [_pop setTxt:@"hola 3" ];

    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
 
}

-(void) buttonClicked4 {
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*4;
    _segmentedControlQ1.frame = changePositionInX;
    
    _button.frame = CGRectMake(self.horizontalScrollView.frame.size.width*4, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height-_segmentedControlQ1.frame.size.height);
     [_pop setTxt:@"hola 4" ];
    
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
    NSError *error;
    
    /// Creates new entry or modifies existing one
    if (_edit) {
        _edit = NO;
        NSLog(@"esto edita entrada");
        
    }else{
        //Crea el last record
        self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"FoodRecord"
                                                        inManagedObjectContext:context];
        NSLog(@"esto es una nueva entrada");
    }
    
    double averageScore = 0;
    for (int i = 0; i < 5; i++) {
        averageScore += [[self.answers objectAtIndex:i] doubleValue];
    }
    averageScore /= 5;
    [self.answers removeAllObjects];
    
    [self.lastRecord setValue:@(averageScore) forKey:@"score"];
    [self.lastRecord setValue:date forKey:@"date"];
    [context save:&error];
    
    [self viewDidAppear:YES];
    [self loadGraphData];
    [self.nutriGraph reloadGraph];
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
    return @" habito";
}

-(void)infoView{
    
    if (_infoNutriRank.hidden == YES) {
         _infoNutriRank.hidden = NO;
    }else{
        _infoNutriRank.hidden = YES;
    }
    
    
    
    NSLog(@"btn info pressed");
    
    
    
}
#pragma mark - Question Labels

- (void) setQuestionLabels {
    // Create Label 1
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, 0, 400, 60)];
    [labelOne setTextColor:[UIColor flatNavyBlueColorDark]];
    [labelOne setText:@"¿Consumes una gran variedad de frutas \n y verduras?"];
    [labelOne setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [labelOne setNumberOfLines:0];
   
    [self.horizontalScrollView addSubview:labelOne];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self
               action:@selector(infoView)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.tintColor = [UIColor flatNavyBlueColorDark];
    button.frame = CGRectMake(self.view.frame.size.width*0.6, 40, 160.0, 40.0);
    [self.horizontalScrollView addSubview:button];
    
    //
    _infoNutriRank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    
    _infoNutriRank.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.10];
    
    _infoNutriRank.hidden = YES;
    
    
    UIView *infoRankWindow = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height*0.2, self.view.frame.size.width*0.8,  self.view.frame.size.height/2)];
    infoRankWindow.backgroundColor = [UIColor flatNavyBlueColorDark];
    infoRankWindow.layer.cornerRadius = 10.0;
    infoRankWindow.layer.borderWidth = 0.5;
    
    
    UILabel *infoTxt= [[UILabel alloc]initWithFrame:CGRectMake(infoRankWindow.frame.size.width*0.1,infoRankWindow.frame.size.height*0.05, infoRankWindow.frame.size.width*0.8, infoRankWindow.frame.size.height*0.9)];
    [infoTxt setText:@"El puntaje de la encuesta consiste en: \n 1 - Absolutamente nada \n 2 - Rara vez \n 3 - Por lo menos más de una vez \n 4 - Seguido pero no constante \n 5 - Soy constante"];
    [infoTxt setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [infoTxt setNumberOfLines:0];
    infoTxt.textColor = [UIColor flatMintColor];
    
   
    UIButton *btnDismiss =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnDismiss addTarget:self
               action:@selector(infoView)
     forControlEvents:UIControlEventTouchUpInside];
    [btnDismiss setTitle:@"Aceptar" forState:UIControlStateNormal];
    btnDismiss.titleLabel.font = [UIFont systemFontOfSize:13];
    btnDismiss.titleLabel.tintColor = [UIColor flatMintColor];
    btnDismiss.frame = CGRectMake(infoRankWindow.frame.size.width*0.6, infoRankWindow.frame.size.height*0.85,60.0, 10.0);

    
    
    [infoRankWindow addSubview:btnDismiss];
    
     [infoRankWindow addSubview:infoTxt];
    
    [_infoNutriRank addSubview:infoRankWindow];
    
    [self.view addSubview:_infoNutriRank];
    
    
    //
    
    
    _animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(self.verticalScroll.frame.size.width * 0.1, self.verticalScroll.frame.size.height*0.9, self.verticalScroll.frame.size.width * 0.8, 185)];
    
    _animationView.backgroundColor = [UIColor flatMintColor];
    
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
    
    
    self.suggestions = [[NSMutableArray alloc] initWithObjects:@"Es bueno que reconozcas la necesidad de realizar un cambio. Tu puedes", @"Empieza con cosas pequeñas, consume frutas y agua. Dale un intento!", @"Procura controlar tu consumo de azucares y sales. Veras como es bueno para tu salud",@"Procura tener horarios exactos para cada plato del día. Estas dando los primeros pasos, crear un habito toma tiempo!" ,@"Tienes una muy buena dieta, sigue así!",@"Bienvenido, ingresa datos para poder ver las sugerencias",nil];
    
    
    _labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,20, 100, 150)];
    [_labelSuggestion setText:[self.suggestions objectAtIndex: [self loadSuggestion]]];
    [_labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [_labelSuggestion setNumberOfLines:0];
    
    CGRect frame;
    
    frame =_labelSuggestion.frame;
    frame.size.width +=70;
    _labelSuggestion.frame=frame;
    
    
    [_animationView addSubview:_labelSuggestion];
    
    [self.verticalScroll addSubview:_animationView];
    
    // Create Label 2

    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width+ self.view.frame.size.width*0.05, 0, 400, 60)];
    [labelTwo setTextColor:[UIColor flatNavyBlueColorDark]];
    [labelTwo setText:@"¿Comes seguido cereales integrales?"];
    [labelTwo setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [labelTwo setNumberOfLines:0];
    [self.horizontalScrollView addSubview:labelTwo];
    
    // Create Label 3
    UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2+ self.view.frame.size.width*0.05, 0, 400, 80)];
    [labelThree setText:@"¿Consumes bebidas o comidas con \n azucares con moderación?"];
    [labelThree setTextColor:[UIColor flatNavyBlueColorDark]];
    labelThree.lineBreakMode = UILineBreakModeWordWrap;
    labelThree.numberOfLines = 0;
    [labelThree setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelThree];
    
    // Create Label 4
    UILabel *labelFour = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*3+ self.view.frame.size.width*0.05, 0, 400, 80)];
    [labelFour setText:@"¿Consumes al menos un  litro de agua \n  diario?"];
    [labelFour setTextColor:[UIColor flatNavyBlueColorDark]];
    labelFour.lineBreakMode = UILineBreakModeWordWrap;
    labelFour.numberOfLines = 0;
    [labelFour setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFour];
    
    // Create Label 5
    UILabel *labelFive = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*4+ self.view.frame.size.width*0.05, 0, 400, 80)];
    [labelFive setText:@"¿Respetas tus horarios de comida?"];
    [labelFive setTextColor:[UIColor flatNavyBlueColorDark]];
    labelFive.lineBreakMode = UILineBreakModeWordWrap;
    labelFive.numberOfLines = 0;
    [labelFive setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFive];
    
}

- (IBAction)btnInfoPressed {
    if (_pop.view.hidden) {
        _pop.view.hidden = NO;
    }else{
        _pop.view.hidden = YES;
    }
}
@end
