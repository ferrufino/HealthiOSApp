//
//  SecondViewController.m
//  finalProject
//
//  Created by Gustavo Ferrufino on 10/19/15.
//  Copyright (c) 2015 Gustavo Ferrufino. All rights reserved.
//

#import "SecondViewController.h"
@interface SecondViewController ()
@property HMSegmentedControl *segmentedControlQ1;
@property NSMutableArray *answers;
@property NSInteger numOfQuestion;

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.numOfQuestion = 1;
    self.answers = [[NSMutableArray alloc] init];
    
    self.horizontalScrollView.frame = CGRectMake(0, 0, 375, 162);
    //Impide que usuario pueda darle scroll
    self.horizontalScrollView.scrollEnabled = NO;
    
    //SegmentedControl for horizontal scroll view
    _segmentedControlQ1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"1", @"2", @"3", @"4", @"5"]];
    [_segmentedControlQ1 setFrame:CGRectMake(0, 112, self.horizontalScrollView.frame.size.width, 53)];
    [_segmentedControlQ1 setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
        double delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.numOfQuestion == 1) {
                [_answers addObject:@(index+1)];
                [self buttonClicked1];
            }else if (self.numOfQuestion == 2){
                [_answers addObject:@(index+1)];
                [self buttonClicked2];
            }else if(self.numOfQuestion == 3){
                [_answers addObject:@(index+1)];
                [self buttonClicked3];
            }else if(self.numOfQuestion == 4){
                [_answers addObject:@(index+1)];
                [self buttonClicked4];
            }else if(self.numOfQuestion == 5){
                [_answers addObject:@(index+1)];
                [self buttonClicked5];
            }
            
        });
        
    }];
    _segmentedControlQ1.selectionIndicatorHeight = 4.0f;
    _segmentedControlQ1.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    _segmentedControlQ1.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _segmentedControlQ1.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    _segmentedControlQ1.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControlQ1.selectedSegmentIndex = HMSegmentedControlNoSegment;
    _segmentedControlQ1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControlQ1.shouldAnimateUserSelection = NO;
    _segmentedControlQ1.tag = 1;
    [self.horizontalScrollView addSubview:_segmentedControlQ1];
 
    // Create Label 1
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 400, 40)];
    [labelOne setBackgroundColor:[UIColor clearColor]];
    [labelOne setText:@"Incluir gran variedad de frutas y verduras"];
    [labelOne setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelOne];
    
    
    // Create Label 2
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width+70, 10, 400, 40)];
    [labelTwo setBackgroundColor:[UIColor clearColor]];
    [labelTwo setText:@"Comes seguido cereales integrales?"];
    [labelTwo setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelTwo];
    
    // Create Label 3
    UILabel *labelThree = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*2+70, 10, 400, 80)];
    [labelThree setText:@"Consumes bebidas o comidas con \n azucares con moderación?"];
    labelThree.lineBreakMode = UILineBreakModeWordWrap;
    labelThree.numberOfLines = 0;
    [labelThree setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelThree];

    // Create Label 4
    UILabel *labelFour = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*3+70, 10, 400, 80)];
    [labelFour setText:@"Consumes al menos un litro de agua diario?"];
    labelFour.lineBreakMode = UILineBreakModeWordWrap;
    labelFour.numberOfLines = 0;
    [labelFour setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFour];
    
    // Create Label 5
    UILabel *labelFive = [[UILabel alloc]initWithFrame:CGRectMake(self.horizontalScrollView.frame.size.width*4+70, 10, 400, 80)];
    [labelFive setText:@"Respetas tus horarios de comida?"];
    labelFive.lineBreakMode = UILineBreakModeWordWrap;
    labelFive.numberOfLines = 0;
    [labelFive setFont:[UIFont fontWithName:@"Avenir-Heavy" size:15]];
    [self.horizontalScrollView addSubview:labelFive];
    
    
    
    //Oculta sidebar scroll
    [self.horizontalScrollView setShowsHorizontalScrollIndicator:NO];
    //Asigna tamaño a vertical scroll view
    [self.horizontalScrollView setContentSize:CGSizeMake(self.horizontalScrollView.frame.size.width*5, self.horizontalScrollView.frame.size.height)];
    
    
    
    
    /*****Vertical Scroll***/
    [self.verticalScroll setScrollEnabled:YES];
    [self.verticalScroll setContentSize:CGSizeMake(320, 800)];
    
    
    //Animated cards
    testView  = [[UIView alloc]initWithFrame:CGRectMake(50, 280, 280, 185)];
    testView.backgroundColor = [UIColor redColor];
    testView.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    testView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    testView.layer.borderWidth = 1.0; // set borderWidth as you want.
    
    UILabel *labelSuggestion = [[UILabel alloc]initWithFrame:CGRectMake(50,30, 100, 100)];
    [labelSuggestion setText:@"Sugerencia"];
    [labelSuggestion setFont:[UIFont fontWithName:@"Avenir" size:15]];
    [testView addSubview:labelSuggestion];
    [self.verticalScroll addSubview:testView];


}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    [self goAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void) buttonClicked1
{

    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked2
{
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*2;
    _segmentedControlQ1.frame = changePositionInX;
    
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*2, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked3
{
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*3;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*3, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked4
{
    self.numOfQuestion += 1;
    _segmentedControlQ1.selectedSegmentIndex =  UISegmentedControlNoSegment;
    
    CGRect changePositionInX = _segmentedControlQ1.frame;
    changePositionInX.origin.x = self.horizontalScrollView.frame.size.width*4;
    _segmentedControlQ1.frame = changePositionInX;
    
    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*4, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
}
-(void) buttonClicked5
{
    
//    CGRect frame = CGRectMake(self.horizontalScrollView.frame.size.width*5, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height); //wherever you want to scroll
//    [self.horizontalScrollView scrollRectToVisible:frame animated:YES];
    self.horizontalScrollView.hidden = YES;
    self.verticalScroll.frame = CGRectMake(0,0,self.verticalScroll.frame.size.width, self.verticalScroll.frame.size.height);
    for (id obj in self.answers)
        NSLog(@"%@", obj);
    
}

//Animated Card
- (void) goAnimation
{
    
    
    
    [UIView beginAnimations:@"1" context:NULL];
    [UIView setAnimationDuration:0.8f];
    // 设置最终视图路径
    testView.frame = CGRectMake(testView.frame.origin.x-30, testView.frame.origin.y - 200, testView.frame.size.width, testView.frame.size.height);
    // 设置最终视图旋转
    testView.transform = CGAffineTransformMakeRotation(- (10.0f * M_PI) / 180.0f);
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(next)];  //执行完调用返回缩小函数
    [UIView commitAnimations];
    
    // 设置最终视图放大倍数
    CGAffineTransform transform = testView.transform;
    transform = CGAffineTransformScale(transform, 1.2 ,1.2);
    testView.transform = transform;
    
    
}


-(void)next{
    
    [self.view bringSubviewToFront:testView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    
    testView.transform = CGAffineTransformMakeRotation((0.0f) / 180.0f);
    testView.frame = CGRectMake(50, 280, 280, 185);
    
    [UIView setAnimationDelegate:self];
    // 如果不需要执行的弹跳可不执行
    [UIView setAnimationDidStopSelector: @selector(bounceAnimationStopped)];
    
    [UIView commitAnimations];
    
}

#pragma -
#pragma mark  阻尼弹跳

- (void)bounceAnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 20, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce2AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce2AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 20, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce3AnimationStopped)];
    
    [UIView commitAnimations];
    
}



- (void)bounce3AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 10, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce4AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce4AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 10, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce5AnimationStopped)];
    [UIView commitAnimations];
    
}


- (void)bounce5AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y - 5, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(bounce6AnimationStopped)];
    
    [UIView commitAnimations];
    
    
    
}
- (void)bounce6AnimationStopped {
    
    [UIView beginAnimations:@"3" context:NULL];
    [UIView setAnimationDuration:0.1f];
    
    testView.frame = CGRectMake(testView.frame.origin.x, testView.frame.origin.y + 5, testView.frame.size.width, testView.frame.size.height);
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    
}



@end
