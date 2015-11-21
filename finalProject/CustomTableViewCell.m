//
//  CustomTableViewCell.m
//  finalProject
//
//  Created by alumno on 05/11/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.ViewCell.layer setCornerRadius:5.0f];
    [self.ViewCell.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
