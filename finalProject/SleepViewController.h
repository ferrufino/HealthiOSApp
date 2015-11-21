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
@property (weak, nonatomic) IBOutlet UIButton *btPlus;
@property (weak, nonatomic) IBOutlet UIButton *btMinus;
- (IBAction)pressedButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfTimeSlept;
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
- (IBAction)btnAgrega:(UIButton *)sender;
- (IBAction)btnConfirma:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtCantidadSue;

@property (weak, nonatomic) IBOutlet UIButton *btnAddRecord;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;



@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UILabel *labelValues;
@property (weak, nonatomic) IBOutlet UILabel *labelDates;


@end
