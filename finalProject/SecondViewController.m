//
//  SecondViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SecondViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.horizontalScrollView.frame = CGRectMake(0, 0, 392, 162);
    //Impide que usuario pueda darle scroll
    self.horizontalScrollView.scrollEnabled = NO;
    
    
    //Button for horizontal Scroll
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but1 addTarget:self action:@selector(buttonClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [but1 setFrame:CGRectMake(0, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
    [but1 setTitle:@"test1" forState:UIControlStateNormal];
    [but1 setExclusiveTouch:YES];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but2 addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
    [but2 setFrame:CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
    [but2 setTitle:@"test2" forState:UIControlStateNormal];
    [but2 setExclusiveTouch:YES];
    
    UIButton *but3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but3 addTarget:self action:@selector(buttonClicked3:) forControlEvents:UIControlEventTouchUpInside];
    [but3 setFrame:CGRectMake(_horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
    [but3 setTitle:@"test3" forState:UIControlStateNormal];
    [but3 setExclusiveTouch:YES];
    
    UIButton *but4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but4 addTarget:self action:@selector(buttonClicked4:) forControlEvents:UIControlEventTouchUpInside];
    [but4 setFrame:CGRectMake(_horizontalScrollView.frame.size.width*3, 0, _horizontalScrollView.frame.size.width, _horizontalScrollView.frame.size.height)];
    [but4 setTitle:@"test4" forState:UIControlStateNormal];
    [but4 setExclusiveTouch:YES];
    
    UIButton *but5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but5 addTarget:self action:@selector(buttonClicked5:) forControlEvents:UIControlEventTouchUpInside];
    [but5 setFrame:CGRectMake(self.horizontalScrollView.frame.size.width*4, 0, _horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
    [but5 setTitle:@"test5" forState:UIControlStateNormal];
    [but5 setExclusiveTouch:YES];
    
    
    [self.horizontalScrollView addSubview:but1];
    [self.horizontalScrollView addSubview:but2];
    [self.horizontalScrollView addSubview:but3];
    [self.horizontalScrollView addSubview:but4];
    [self.horizontalScrollView addSubview:but5];
    
    //Oculta sidebar scroll
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:NO];
    //Asigna tamaño a vertical scroll view
    [self.horizontalScrollView setContentSize:CGSizeMake(self.horizontalScrollView.frame.size.width*5, self.horizontalScrollView.frame.size.height)];
    
    
    
    
    /*****Vertical Scroll***/
    [self.verticalScroll setScrollEnabled:YES];
    [self.verticalScroll setContentSize:CGSizeMake(320, 800)];

}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void) buttonClicked1:(UIButton*)sender
{
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked2:(UIButton*)sender
{
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked3:(UIButton*)sender
{
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked4:(UIButton*)sender
{
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*4, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked5:(UIButton*)sender
{
//    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*5, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
//    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
    self.horizontalScrollView.hidden = YES;
    self.verticalScroll.frame = CGRectMake(0,0,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    
}
@end
