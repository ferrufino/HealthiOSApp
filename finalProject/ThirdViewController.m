//
//  ThirdViewController.m
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "ThirdViewController.h"
#import "SecondViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"

#define TAG_First 1
#define TAG_Second 2

@interface ThirdViewController ()
@property  UIAlertView *alert2;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self chart3]];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = nil;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                              action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = anotherButton;
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
    [self firstAlert];
}

- (IBAction)btnConfirma:(UIButton *)sender {

}
-(FSLineChart*)chart3 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i=0;i<7;i++) {
        chartData[i] = [NSNumber numberWithFloat: (float)i / 30.0f + (float)(rand() % 100) / 500.0f];
    }
    
    NSArray* months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July"];
    
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 400, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 4;
    lineChart.horizontalGridStep = 3; // 151,187,205,0.2
    lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f hrs", value];
    };
    
    [lineChart setChartData:chartData];
    
    return lineChart;
}


- (IBAction)firstAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"titleGoesHere"
                          message:@"messageGoesHere"
                          delegate:self
                          cancelButtonTitle:@"Areobico"
                          otherButtonTitles:@"Anareobico", nil];
    alert.tag = TAG_First;
    [alert show];
    
}

- (IBAction)secAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Agrega Ejercicio realizado"
                                                    message:@"Ingresa la cantidad de horas ejecitadas:"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"horas";
    alert.tag = TAG_Second;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_First) { // handle the altdev
        [self secAlert];
    } else if (alertView.tag == TAG_Second){ // handle the donate
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
 
    }
}



@end
