//
//  ProfileViewController.m
//  
//
//  Created by Lalo on 22/10/15.
//
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveProfile:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                                       inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchLimit:1];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    NSManagedObject *user;
    
    if (fetchResults.count != 0) {
        user = [fetchResults objectAtIndex:0];
    } else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                            inManagedObjectContext:context];
    }
    
    [user setValue:self.tfName.text forKey:@"name"];
    
    NSNumberFormatter *height = [[NSNumberFormatter alloc] init];
    height.numberStyle = NSNumberFormatterDecimalStyle;
    [user setValue:[height numberFromString:self.tfHeight.text] forKey:@"height"];
    
    NSNumberFormatter *weight = [[NSNumberFormatter alloc] init];
    weight.numberStyle = NSNumberFormatterDecimalStyle;
    [user setValue:[weight numberFromString:self.tfWeight.text] forKey:@"weight"];
    
    NSNumberFormatter *age = [[NSNumberFormatter alloc] init];
    age.numberStyle = NSNumberFormatterNoStyle;
    [user setValue:[age numberFromString:self.tfAge.text] forKey:@"age"];
    
    [user setValue:@(self.swExercise.isOn) forKey:@"exercise"];
    
    [context save:&error];
}
@end
