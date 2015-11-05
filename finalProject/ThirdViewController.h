//
//  ThirdViewController.h
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController
- (IBAction)btnAgrega:(UIButton *)sender;
- (IBAction)btnConfirma:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *FormaEjercicio;
@property (weak, nonatomic) IBOutlet UITextField *txtHorasAerobico;
@property (weak, nonatomic) IBOutlet UITextField *txtHorasAnaerobico;

@end
