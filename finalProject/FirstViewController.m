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

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.view addSubview:[self chart1]];
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(FSLineChart*)chart1 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:10];
    
    for(int i=0;i<10;i++) {
        int r = (rand() + rand()) % 1000;
        chartData[i] = [NSNumber numberWithInt:r + 200];
    }
    
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 400, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 5;
    lineChart.horizontalGridStep = 9;
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:chartData];
    return lineChart;
}

- (IBAction)btnAgrega:(UIButton *)sender {
    self.FormaSue.hidden = false;
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
