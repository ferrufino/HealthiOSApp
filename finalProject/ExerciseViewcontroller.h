//
//  ThirdViewController.h
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
@interface ExerciseViewcontroller : UIViewController<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>


@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *exerciseGraph;

@property (weak, nonatomic) IBOutlet UIStepper *aerobicStepper;
@property (weak, nonatomic) IBOutlet UIStepper *anaerobicStepper;
@property (weak, nonatomic) IBOutlet UILabel *aerobicMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *anaerobicMinutesLabel;
- (IBAction)pressedAerobicStepper:(UIStepper *)sender;
- (IBAction)pressedAnaerobicStepper:(UIStepper *)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;

@property (strong, nonatomic) NSMutableArray *arrayOfValuesA;
@property (strong, nonatomic) NSMutableArray *arrayOfValuesAna;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

- (IBAction)submit:(id)sender;

@end
