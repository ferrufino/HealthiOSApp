//
//  FirstViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "FirstViewController.h"
#import "DateUtilities.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"

@interface FirstViewController ()

@property NSManagedObject *lastRecord;
@property  UIAlertView *alert;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Scroll View
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 800)];

    // Pop -up
    _alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    _alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [_alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Enter your name";
  

    
    //Core Data
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
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    
    if (fetchResults.count != 0) {
        self.lastRecord = [fetchResults objectAtIndex:0];
        
        NSNumber *duration = [self.lastRecord valueForKey:@"duration"];
        self.txtCantidadSue.text = [duration stringValue];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Sueño"
                                                              style:UIBarButtonSystemItemAdd target:self
                                                              action:@selector(btnAgrega:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = anotherButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAgrega:(UIButton *)sender {
     [_alert show];
}

- (IBAction)btnConfirma:(UIButton *)sender {
    self.FormaSue.hidden = true;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (!self.lastRecord) {
        self.lastRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SleepRecord"
                                               inManagedObjectContext:context];
    }
    NSDate *date = [NSDate date];
    CGFloat duration = [self.txtCantidadSue.text floatValue];
    
    [self.lastRecord setValue:date forKey:@"date"];
    [self.lastRecord setValue:@(duration) forKey:@"duration"];
    
    NSError *error;
    [context save:&error];
}
@end
