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

@end
