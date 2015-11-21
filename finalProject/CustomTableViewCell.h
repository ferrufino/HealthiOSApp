//
//  CustomTableViewCell.h
//  finalProject
//
//  Created by alumno on 05/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ViewCell;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbMainScore;
@property (weak, nonatomic) IBOutlet UILabel *lbFoodScore;
@property (weak, nonatomic) IBOutlet UILabel *lbExerciseScore;
@property (weak, nonatomic) IBOutlet UILabel *lbSleepScore;



@end
