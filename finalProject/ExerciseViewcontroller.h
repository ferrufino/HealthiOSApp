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

- (IBAction)buttonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btPlusAreobico;
@property (weak, nonatomic) IBOutlet UIButton *btMinusAreobico;


@property (weak, nonatomic) IBOutlet UIButton *btPlusAnareobico;
@property (weak, nonatomic) IBOutlet UIButton *btMinusAnareobico;
@property (weak, nonatomic) IBOutlet UITextField *tfAreobico;
@property (weak, nonatomic) IBOutlet UITextField *tfAnareobico;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;

@property (strong, nonatomic) NSMutableArray *arrayOfValuesA;
@property (strong, nonatomic) NSMutableArray *arrayOfValuesAna;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UILabel *labelValues;
@property (weak, nonatomic) IBOutlet UILabel *labelDates;

- (IBAction)submit:(id)sender;

@end
