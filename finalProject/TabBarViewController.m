//
//  TabBarViewController.m
//  
//
//  Created by Lalo on 22/10/15.
//
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ReportsHelper *helper = [[ReportsHelper alloc] init];
    NSString *score = [helper getLastReportScore];
    NSString *display = [[NSString alloc] initWithFormat:@"%@/5", score];
    self.navigationController.navigationBar.topItem.title = display;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindProfile:(UIStoryboardSegue *)segue {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
