//
//  ReportsTableViewController.m
//  
//
//  Created by Lalo on 4/11/15.
//
//

#import "ReportsTableViewController.h"


@interface ReportsTableViewController ()

@property NSMutableArray *reports;
@property ReportsHelper *helper;

@end

@implementation ReportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor flatNavyBlueColor]];
    self.tableView.allowsSelection = NO;
    self.helper = [[ReportsHelper alloc] init];
    
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                               action:@selector(addReport)];
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
    [self.tabBarController.tabBar setTintColor:[UIColor flatSkyBlueColor]];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor flatSkyBlueColor]];
    [self.view setTintColor:[UIColor flatSkyBlueColor]];
    [self.tabBarController.navigationController.navigationBar
     setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20],
                               NSForegroundColorAttributeName: [UIColor flatSkyBlueColor]}];
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
    NSMutableDictionary *roundedScores = [self formatReport:report];
    
    NSDate *date = [report valueForKey:@"date"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/YYYY";
    cell.lbDate.text = [df stringFromDate:date];
    cell.lbMainScore.text = [[roundedScores valueForKey:@"score"] stringValue];
    cell.lbFoodScore.text = [[roundedScores valueForKey:@"foodScore"] stringValue];
    cell.lbSleepScore.text = [[roundedScores valueForKey:@"sleepScore"] stringValue];
    cell.lbExerciseScore.text = [[roundedScores valueForKey:@"exerciseScore"] stringValue];
    
    return cell;
}


- (NSMutableDictionary *)formatReport:(NSMutableDictionary *)report {
    int roundedFoodScore = (int)([[report valueForKey:@"foodScore"] floatValue] + 0.5);
    int roundedSleepScore = (int)([[report valueForKey:@"sleepScore"] floatValue] + 0.5);
    int roundedExerciseScore = (int)([[report valueForKey:@"exerciseScore"] floatValue] + 0.5);
    int roundedScore = (int)([[report valueForKey:@"score"] floatValue] + 0.5);
    
    NSMutableDictionary *roundedScores = [[NSMutableDictionary alloc] init];
    [roundedScores setValue:@(roundedFoodScore) forKey:@"foodScore"];
    [roundedScores setValue:@(roundedSleepScore) forKey:@"sleepScore"];
    [roundedScores setValue:@(roundedExerciseScore) forKey:@"exerciseScore"];
    [roundedScores setValue:@(roundedScore) forKey:@"score"];
    
    return roundedScores;
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
        CGFloat score = ([foodScore floatValue] + [exerciseScore floatValue] + [sleepScore floatValue]) / 3.0;
        NSDate *date = [record valueForKey:@"date"];
        [report setValue:foodScore forKey:@"foodScore"];
        [report setValue:exerciseScore forKey:@"exerciseScore"];
        [report setValue:sleepScore forKey:@"sleepScore"];
        [report setValue:@(score) forKey:@"score"];
        [report setValue:date forKey:@"date"];
        [self.reports addObject:report];
    }

}

- (void) addReport {
    [self.helper generateReport];
    [self loadReports];
    [self.tableView reloadData];
}

@end
