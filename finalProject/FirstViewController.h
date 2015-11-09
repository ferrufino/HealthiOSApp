//
//  FirstViewController.h
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//


#import <JBChart/JBChart.h>
#import "AppDelegate.h"
// Views
@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet JBBarChartView *barChart;
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
- (IBAction)btnAgrega:(UIButton *)sender;
- (IBAction)btnConfirma:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtCantidadSue;
@property (weak, nonatomic) IBOutlet UIView *FormaSue;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRecord;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

