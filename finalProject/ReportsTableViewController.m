//
//  ReportsTableViewController.m
//  
//
//  Created by Lalo on 4/11/15.
//
//

#import "ReportsTableViewController.h"
#import "CustomTableViewCell.h"
#import "QuartzCore/QuartzCore.h"

@interface ReportsTableViewController ()

@property NSMutableArray *reports;
@property NSArray *test;

@end

@implementation ReportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _test =[[NSArray alloc]initWithObjects:@"19/03/2015",@"20/03/2015",nil];
    
    [self loadReports];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reports.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableDictionary *report = [self.reports objectAtIndex:indexPath.row];
    [cell.ViewCell.layer setCornerRadius:20.0f];
    [cell.ViewCell.layer setMasksToBounds:YES];
    
    NSDate *date = [report valueForKey:@"date"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/YYYY";
    cell.lbDate.text = [df stringFromDate:date];
    cell.lbMainScore.text = [[report valueForKey:@"score"] stringValue];
    cell.lbFoodScore.text = [[report valueForKey:@"foodScore"] stringValue];
    cell.lbSleepScore.text = [[report valueForKey:@"sleepScore"] stringValue];
    cell.lbExerciseScore.text = [[report valueForKey:@"exerciseScore"] stringValue];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) loadReports {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Report"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    self.reports = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < fetchResults.count; i++) {
        NSManagedObject *record = [fetchResults objectAtIndex:i];
        NSArray *keys = [[[record entity] attributesByName] allKeys];
        NSMutableDictionary *report = [[record dictionaryWithValuesForKeys:keys] mutableCopy];
        NSNumber *foodScore = [record valueForKey:@"foodScore"];
        NSNumber *exerciseScore = [record valueForKey:@"exerciseScore"];
        NSNumber *sleepScore = [record valueForKey:@"sleepScore"];
        NSNumber *score = [[NSNumber alloc] initWithFloat:
                           ([foodScore floatValue] + [exerciseScore floatValue] + [sleepScore floatValue]) / 3];
        NSDate *date = [record valueForKey:@"date"];
        [report setValue:foodScore forKey:@"foodScore"];
        [report setValue:exerciseScore forKey:@"exerciseScore"];
        [report setValue:sleepScore forKey:@"sleepScore"];
        [report setValue:score forKey:@"score"];
        [report setValue:date forKey:@"date"];
        [self.reports addObject:report];
    }

}

@end
