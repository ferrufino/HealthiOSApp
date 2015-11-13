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

#define TAG_First 1
#define TAG_Second 2

@interface ThirdViewController ()
@property  UIAlertView *alert2;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
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
