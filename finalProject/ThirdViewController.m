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

#define TAG_First 1
#define TAG_Second 2

@interface ThirdViewController ()
@property  UIAlertView *alert2;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    testView  = [[UIView alloc]initWithFrame:CGRectMake(50, 280, 280, 185)];
    testView.backgroundColor = [UIColor redColor];
    testView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    testView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    testView.layer.borderWidth = 1.0; // set borderWidth as you want.
  
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:@"Sugerencia"];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [testView addSubview:labelSuggestion];
    [self.view addSubview:testView];

    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = nil;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                              action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = anotherButton;
    
    [self goAnimation];

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
    testView.frame = CGRectMake(50, 280, 280, 185);
    
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








@end
