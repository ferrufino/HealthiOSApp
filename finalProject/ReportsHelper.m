//
//  ReportsHelper.m
//  
//
//  Created by Lalo on 21/11/15.
//
//

#import "ReportsHelper.h"

@interface ReportsHelper ()

@property NSMutableArray *arrayOfDates;

@end

@implementation ReportsHelper

- (id) init
{
    self = [super init];
    if (self)
    {
        // superclass successfully initialized, further
        // initialization happens here ...
    }
    return self;
}

- (void) generateReport {
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval:-86400.0];
    NSDate *twoDaysAgo = [yesterday dateByAddingTimeInterval:-86400.0];
    NSDate *threeDaysAgo = [twoDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *fourDaysAgo = [threeDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *fiveDaysAgo = [fourDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *sixDaysAgo = [fiveDaysAgo dateByAddingTimeInterval:-86400.0];
    NSDate *sevenDaysAgo = [sixDaysAgo dateByAddingTimeInterval:-86400.0];
    
    self.arrayOfDates = [[NSMutableArray alloc] initWithObjects:today, yesterday, twoDaysAgo,
                         threeDaysAgo, fourDaysAgo, fiveDaysAgo, sixDaysAgo, sevenDaysAgo, nil];
    
    NSMutableArray *sleepRecords = [self fetchSleepRecords];
    NSMutableArray *foodRecords = [self fetchFoodRecords];
    NSMutableArray *exerciseRecords = [self fetchExerciseRecords];
    
    CGFloat sleepScore = [self calculateSleepScore:sleepRecords];
    CGFloat foodScore = [self calculateFoodScore:foodRecords];
    CGFloat exerciseScore = [self calculateExerciseScore:exerciseRecords];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *report = [NSEntityDescription insertNewObjectForEntityForName:@"Report"
                                                            inManagedObjectContext:context];
    
    [report setValue:@(sleepScore) forKey:@"sleepScore"];
    [report setValue:@(foodScore) forKey:@"foodScore"];
    [report setValue:@(exerciseScore) forKey:@"exerciseScore"];
    [report setValue:@(0) forKey:@"alcoholScore"];
    
    NSError *error;
    [context save:&error];
    
}

- (NSMutableArray*) fetchSleepRecords {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SleepRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSManagedObject *record;
    NSPredicate *predicate;
    NSArray *fetchResults;
    NSMutableArray *sleepArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *duration = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            duration = [record valueForKey:@"duration"];
        }
        [sleepArray addObject:duration];
    }
    return sleepArray;
}

- (NSMutableArray*) fetchFoodRecords {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FoodRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSManagedObject *record;
    NSPredicate *predicate;
    NSArray *fetchResults;
    NSMutableArray *foodArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *duration = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            duration = [record valueForKey:@"score"];
        }
        [foodArray addObject:duration];
    }
    return foodArray;
}

- (NSMutableArray*) fetchExerciseRecords {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExerciseRecord"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSManagedObject *record;
    NSPredicate *predicate;
    NSArray *fetchResults;
    NSMutableArray *exerciseArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<=6; i++) {
        predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (date >= %@)",
                     [self.arrayOfDates objectAtIndex:i], [self.arrayOfDates objectAtIndex:i+1]];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        fetchResults = [context executeFetchRequest:request error:&error];
        NSNumber *aerobic = [[NSNumber alloc] initWithFloat:0];
        NSNumber *anaerobic = [[NSNumber alloc] initWithFloat:0];
        if (fetchResults.count != 0) {
            record = [fetchResults objectAtIndex:0];
            aerobic = [record valueForKey:@"aerobicDuration"];
            anaerobic = [record valueForKey:@"anaerobicDuration"];
        }
        NSMutableDictionary *exercise = [[NSMutableDictionary alloc] init];
        [exercise setValue:aerobic forKey:@"aerobicDuration"];
        [exercise setValue:anaerobic forKey:@"anaerobicDuration"];
        [exerciseArray addObject:exercise];
    }
    return exerciseArray;
}

- (CGFloat) calculateSleepScore:(NSMutableArray *)sleepRecords {
    NSPredicate *notZero = [NSPredicate predicateWithBlock:
                            ^BOOL(id evalObject,NSDictionary * options) {
                                return [evalObject boolValue];
                            }];
    NSArray *filteredRecords = [sleepRecords filteredArrayUsingPredicate:notZero];
    
    CGFloat average = 0;
    for (int i = 0; i < [filteredRecords count]; i++) {
        average += [[filteredRecords objectAtIndex:i] doubleValue];
    }
    average /= [filteredRecords count];
    
    if (average > 8) {
        average = 8;
    }
    if (average < 4) {
        average = 4;
    }
    
    CGFloat score = average - 3;
    return score;
}

- (CGFloat) calculateFoodScore:(NSMutableArray *)foodRecords {
    NSPredicate *notZero = [NSPredicate predicateWithBlock:
                            ^BOOL(id evalObject,NSDictionary * options) {
                                return [evalObject boolValue];
                            }];
    NSArray *filteredRecords = [foodRecords filteredArrayUsingPredicate:notZero];
    
    CGFloat average = 0;
    for (int i = 0; i < [filteredRecords count]; i++) {
        average += [[filteredRecords objectAtIndex:i] doubleValue];
    }
    average /= [filteredRecords count];
    
    return average;
}

- (CGFloat) calculateExerciseScore:(NSMutableArray *)exerciseRecords {
    CGFloat aerobicWeekly = 0;
    CGFloat anaerobicWeekly = 0;
    
    for (int i = 0; i < [exerciseRecords count]; i++) {
        NSMutableDictionary *record = [exerciseRecords objectAtIndex:i];
        aerobicWeekly += [[record valueForKey:@"aerobicDuration"] doubleValue];
        anaerobicWeekly += [[record valueForKey:@"anaerobicDuration"] doubleValue];
    }
    
    if (aerobicWeekly > 210) {
        aerobicWeekly = 200;
    }
    if (aerobicWeekly < 90) {
        aerobicWeekly = 90;
    }
    
    if (anaerobicWeekly > 210) {
        anaerobicWeekly = 210;
    }
    if (anaerobicWeekly < 90) {
        anaerobicWeekly = 90;
    }
    
    CGFloat aerobicScore = ((aerobicWeekly - 60) / (210 - 60)) * 5;
    CGFloat anaerobicScore = ((anaerobicWeekly - 60) / (210 - 60)) * 5;
    
    CGFloat score = (aerobicScore + anaerobicScore) / 2;
    
    return score;
}

- (NSString*) getLastReportScore {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Report"
                                              inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Results should be in descending order of timeStamp.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [request setFetchLimit:1];
    
    NSArray *results = [context executeFetchRequest:request error:NULL];
    
    if (results.count == 0) {
        return @"5";
    }
    
    NSManagedObject *report = [results objectAtIndex:0];
    
    NSNumber *foodScore = [report valueForKey:@"foodScore"];
    NSNumber *exerciseScore = [report valueForKey:@"exerciseScore"];
    NSNumber *sleepScore = [report valueForKey:@"sleepScore"];
    NSNumber *score = [[NSNumber alloc] initWithFloat:
                       ([foodScore floatValue] + [exerciseScore floatValue] + [sleepScore floatValue]) / 3];
    
    int scoreRounded = (int)([score floatValue] + 0.5);
    return [NSString stringWithFormat:@"%d", scoreRounded];
}

@end
