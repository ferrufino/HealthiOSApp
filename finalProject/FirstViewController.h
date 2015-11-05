//
//  FirstViewController.h
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FirstViewController : UIViewController

- (IBAction)btnAgrega:(UIButton *)sender;
- (IBAction)btnConfirma:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtCantidadSue;
@property (weak, nonatomic) IBOutlet UIView *FormaSue;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRecord;

@end

