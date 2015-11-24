//
//  InfoViewController.h
//  
//
//  Created by Gustavo Ferrufino on 11/23/15.
//
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *infoView;
- (IBAction)dismiss:(id)sender;
- (void)showAnimated;
- (void)removeAnimated;
- (void)setTxt:(NSString*) str;

@property (weak, nonatomic) IBOutlet UILabel *txtContent;
@end
