//
//  ProfileViewController.h
//  
//
//  Created by Lalo on 22/10/15.
//
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfHeight;
@property (weak, nonatomic) IBOutlet UITextField *tfWeight;
@property (weak, nonatomic) IBOutlet UISwitch *swExercise;

- (IBAction)saveProfile:(id)sender;

@end
