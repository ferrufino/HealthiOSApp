//
//  ThirdViewController.h
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController{
UIView *cardView;
}
- (IBAction)buttonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btPlusAreobico;
@property (weak, nonatomic) IBOutlet UIButton *btMinusAreobico;


@property (weak, nonatomic) IBOutlet UIButton *btPlusAnareobico;
@property (weak, nonatomic) IBOutlet UIButton *btMinusAnareobico;
@property (weak, nonatomic) IBOutlet UITextField *tfAreobico;
@property (weak, nonatomic) IBOutlet UITextField *tfAnareobico;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
- (IBAction)submit:(id)sender;

@end
