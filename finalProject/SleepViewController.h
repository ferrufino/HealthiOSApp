//
//  FirstViewController.h
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//



#import "AppDelegate.h"
#import "BEMSimpleLineGraphView.h"
// Views
@interface SleepViewController : UIViewController<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

- (IBAction)submit:(id)sender;
- (IBAction)pressedStepper:(UIStepper*)sender;
@property (weak, nonatomic) IBOutlet UILabel *sleepHoursLabel;

@property (weak, nonatomic) IBOutlet UITextField *tfTimeSlept;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;



@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *sleepGraph;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@end

