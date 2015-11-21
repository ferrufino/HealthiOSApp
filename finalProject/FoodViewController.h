//
//  SecondViewController.h
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HMSegmentedControl.h"
#import "BEMSimpleLineGraphView.h"
@interface FoodViewController : UIViewController<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>



@property(nonatomic, strong) NSArray        *sliceColors;
@property (weak, nonatomic) IBOutlet UIScrollView *verticalScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (weak, nonatomic) IBOutlet UIView *horizontalView;

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *nutriGraph;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UILabel *labelValues;
@property (weak, nonatomic) IBOutlet UILabel *labelDates;


@end

