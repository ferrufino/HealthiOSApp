//
//  ReportsHelper.h
//  
//
//  Created by Lalo on 21/11/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ReportsHelper : NSObject

- (void) generateReport;
- (NSString*) getLastReportScore;
- (int) numberOfReports;
- (NSTimeInterval) timeSinceLastReport;

@end
