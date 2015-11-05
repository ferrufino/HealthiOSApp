//
//  ThirdViewController.m
//  finalProject
//
//  Created by alumno on 04/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

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

- (IBAction)btnAgrega:(UIButton *)sender {
    self.FormaEjercicio.hidden = false;
}

- (IBAction)btnConfirma:(UIButton *)sender {
    self.FormaEjercicio.hidden = true;
}
@end
