//
//  ThirdViewController.m
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "ThirdViewController.h"
#import "SecondViewController.h"
#import "UIColor+FSPalette.h"
#import "QuartzCore/QuartzCore.h"
#import "Canvas.h"

#define TAG_First 1
#define TAG_Second 2

@interface ThirdViewController ()
@property  UIAlertView *alert2;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CSAnimationView *animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
    
    animationView.backgroundColor = [UIColor whiteColor];
    
    animationView.duration = 0.5;
    animationView.delay    = 0;
    animationView.type     = CSAnimationTypeMorph;
    
    [self.view addSubview:animationView];
    
    
    
    cardView  = [[UIView alloc]initWithFrame:CGRectMake(50, 280, 280, 185)];
    cardView.backgroundColor = [UIColor redColor];
    cardView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    cardView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    cardView.layer.borderWidth = 1.0; // set borderWidth as you want.
    
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:@"Sugerencia"];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [cardView addSubview:labelSuggestion];
    [self.view addSubview:cardView];
    
    
    
    
    //Adds suggestion card view to animation.
    // [animationView addSubview:<#(UIView *)#>]
    
    [animationView startCanvasAnimation];
    
    
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
