//
//  InfoViewController.m
//  
//
//  Created by Gustavo Ferrufino on 11/23/15.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.infoView.layer setCornerRadius:5.0f];
    [self.infoView.layer setMasksToBounds:YES];
    
    [self.txtContent setNumberOfLines:0];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)dismiss:(id)sender {
 
        self.view.hidden = YES;
}

- (void)showAnimated
{
    self.view.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    self.view.alpha = 0.0f;
    [UIView animateWithDuration:.25f animations:^{
        self.view.alpha = 1.0f;
        self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

- (void)removeAnimated
{
    [UIView animateWithDuration:.25f animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        self.view.alpha = 0.0f;
    } completion:^(BOOL boolIsFinished) {
        if (
            boolIsFinished
            )
        {
            [self.view removeFromSuperview];
        }
    }];
}

-(void)setTxt:(NSString*) str{

    self.txtContent.text = str;


}
@end
