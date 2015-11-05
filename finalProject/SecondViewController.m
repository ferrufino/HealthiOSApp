//
//  SecondViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SecondViewController.h"
#import "XYPieChart.h"
@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createfirstPiechart];
    [self createSecondPiechart];

   
 
}
-(void) createfirstPiechart {
    float viewWidth = self.pieChart.bounds.size.width / 2;
    float viewHeight = self.pieChart.bounds.size.height / 2;
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.5];
    [self.pieChart setLabelColor:[UIColor whiteColor]];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];
    
    //To make the chart at the center of view
    [self.pieChart setPieCenter:CGPointMake(self.pieChart.bounds.origin.x + viewWidth, self.pieChart.bounds.origin.y + viewHeight)];
    
     [self.pieChart reloadData];
}
-(void) createSecondPiechart{
  
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Specify the number of Sectors in the chart
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 3;
}
//Specify the Value for each sector
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    CGFloat value = 0.0;
    if(index % 3 == 0)
    {
        value = 25;
    }
    else if (index == 1)
    {
        value = 25;
    }else{
        
        value = 50;
    }
    return value;
}

//Specify color for each sector
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    UIColor *color;
    if(index%3 == 0)
    {
        color = [UIColor colorWithRed:14.0/255.0 green:114.0/255.0 blue:20.0/255.0 alpha:1];
    }
    else if(index == 1)
    {
        color = [UIColor colorWithRed:150.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1];
    }else{
    
        color = [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:150.0/255.0 alpha:1];
    
    }
    return color;
}
@end
