//
//  SecondViewController.h
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HMSegmentedControl.h"
@interface SecondViewController : UIViewController
{
    UIView *testView;
}

@property(nonatomic, strong) NSArray        *sliceColors;
@property (weak, nonatomic) IBOutlet UIScrollView *verticalScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *horizontalScrollView;

@end

