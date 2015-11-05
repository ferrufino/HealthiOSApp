//
//  DateUtilities.m
//  
//
//  Created by Lalo on 5/11/15.
//
//

#import <Foundation/Foundation.h>
#import "DateUtilities.h"

@implementation DateUtilities

+(NSDate *)startOfDay {
    //gather current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents = [calendar
                                        components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                        fromDate:[NSDate date]];
    
    //set date components
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    //return date relative from date
    return [calendar dateFromComponents:dateComponents];
}

+(NSDate *)endOfDay {
    //gather current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents = [calendar
                                        components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                        fromDate:[NSDate date]];
    
    //set date components
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    
    //return date relative from date
    return [calendar dateFromComponents:dateComponents];
}

@end