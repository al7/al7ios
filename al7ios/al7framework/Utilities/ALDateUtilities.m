//
//  al7ios framework
//  (C) Copyright 2010-11 Alexandre Leite. All rights reserved. 
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ALDateUtilities.h"

@implementation ALDateUtilities

+(NSDate *)getDateFromFormattedDateString:(NSString *)aFormattedDateString withDateFormat:(NSString *)aDateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:aDateFormat];
    NSDate *resultingDate = [dateFormatter dateFromString:aFormattedDateString];
    return resultingDate;
}

+(NSDate *)getDateFromFormattedDateString:(NSString *)aFormattedDateString {
    return [ALDateUtilities getDateFromFormattedDateString:aFormattedDateString withDateFormat:@"yyyy-MM-dd hh:mm a"];
}

+(NSString *)getFormattedDateStringWithDate:(NSDate *)aDate andDateFormat:(NSString *)aDateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:aDateFormat];
    return [dateFormatter stringFromDate:aDate];     
}

+(NSString *)getFormattedDateStringWithDate:(NSDate *)aDate {
    return [ALDateUtilities getFormattedDateStringWithDate:aDate andDateFormat:@"MM-dd-yyyy"];
}

+(NSDate *)dateWithYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day
                  hours:(NSInteger)hours
                minutes:(NSInteger)minutes
                 period:(ALDateTimePeriod)period {
    
    year = (year < 1970) ? 1970 : year;
    month = (month < 1) ? 1 : month;
    month = (month > 12) ? 12 : month;
    day = (day < 1) ? 1: day;
    
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
        if (day > 31) {
            day = 31;
        }
    }
    else if (month == 4 ||
             month == 6 ||
             month == 9 ||
             month == 11) {
        if (day > 30) {
            day = 30;
        }
    }
    else {
        if ((year > 0) && !(year % 4) && ((year %100) || !(year % 400))) {
            if (day > 29) {
                day = 29;
            }
        }
        else {
            if (day > 28) {
                day = 28;
            }
        }
    }
    
    hours = (hours > 12) ? 12 : hours;
    hours = (hours < 1) ? 1 : hours;
    
    minutes = (minutes < 0) ? 0 : minutes;
    minutes = (minutes > 59) ? 59 : minutes;

    switch (period) {
        case ALDateTimePeriodAM:
            hours = (hours == 12) ? 0 : hours;
            break;
        case ALDateTimePeriodPM:
            hours += 12;
            break;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:hours];
    [dateComponents setMinute:minutes];
    [dateComponents setSecond:0];
    [dateComponents setTimeZone:[calendar timeZone]];
    
    return [calendar dateFromComponents:dateComponents];
}

+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [ALDateUtilities dateWithYear:year month:month day:day hours:12 minutes:0 period:ALDateTimePeriodAM];
}

+(NSInteger)numberOfDaysFromStartingDate:(NSDate *)startingDate toEndDate:(NSDate *)endDate {
    NSTimeInterval differenceBetweenDates = [endDate timeIntervalSinceDate:startingDate];
    return [ALDateUtilities timeInterval:differenceBetweenDates inTimeUnit:ALDateTimeUnitDays];
    
}

+(NSInteger)numberOfWeeksForNumberOfDays:(NSInteger)days {
    return days % 7;
}

+(NSArray *)daysInWeekOfDate:(NSDate *)date {
    NSString *dayOfWeek = [ALDateUtilities getFormattedDateStringWithDate:date andDateFormat:@"EEE"];
    NSArray *daysOfWeek = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    NSInteger dowIndex = [daysOfWeek indexOfObject:dayOfWeek];
    NSInteger daysBefore = dowIndex;
    NSInteger daysAfter = ([daysOfWeek count] - dowIndex) - 1;

    NSMutableArray *daysInWeek = [NSMutableArray array];
    
    for (int dbI = 0 ; dbI < daysBefore; dbI++) {
        int dbIoperator = daysBefore - dbI;
        NSTimeInterval timeIntervalSinceNow = -dbIoperator * (60 * 60 * 24);
        NSDate *dayToAdd = [NSDate dateWithTimeIntervalSinceNow:timeIntervalSinceNow];
        [daysInWeek addObject:dayToAdd];
    }
    [daysInWeek addObject:[NSDate date]];

    for (int daI = 0; daI < daysAfter; daI++) {
        int daIoperator = daI + 1;
        NSTimeInterval timeIntervalSinceNow = daIoperator * (60 * 60 * 24);
        NSDate *dayToAdd = [NSDate dateWithTimeIntervalSinceNow:timeIntervalSinceNow];
        [daysInWeek addObject:dayToAdd];
    }
    
    return [NSArray arrayWithArray:daysInWeek];
}

+(NSInteger)timeInterval:(NSTimeInterval)timeInterval inTimeUnit:(ALDateTimeUnit)timeUnit {
    NSInteger result;
    NSInteger timeIntervalInt = floor(timeInterval);
    
    if (timeUnit == ALDateTimeUnitSeconds) {
        result = timeIntervalInt;
    }
    else if (timeUnit == ALDateTimeUnitMinutes) {
        result = floor(timeIntervalInt / 60);
    }
    else if (timeUnit == ALDateTimeUnitHours) {
        result = floor(timeIntervalInt / (60 * 60));
    }
    else if (timeUnit == ALDateTimeUnitDays) {
        result = floor(timeIntervalInt / (60 * 60 * 24));
    }
    else if (timeUnit == ALDateTimeUnitWeeks) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 7));
    }
    else if (timeUnit == ALDateTimeUnitMonths) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 30));
    }
    else if (timeUnit == ALDateTimeUnitTrimesters) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 30 * 3));
    }
    else if (timeUnit == ALDateTimeUnitSemesters) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 30 * 6));
    }
    else if (timeUnit == ALDateTimeUnitYears) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 365));
    }
    else if (timeUnit == ALDateTimeUnitDecades) {
        result = floor(timeIntervalInt / (60 * 60 * 24 * 365 * 10));
    }
    else {
        result = -1;
    }

    return result;
}

+(NSArray *)monthsFromDate:(NSDate *)startingDate toDate:(NSDate *)endDate {
    NSArray *startingDateMonthYearPair = [ALDateUtilities monthYearPairForDate:startingDate];
    NSArray *endDateMonthYearPair = [ALDateUtilities monthYearPairForDate:endDate];
    
    NSInteger startingYear = [[startingDateMonthYearPair objectAtIndex:1] intValue];
    NSInteger endYear = [[endDateMonthYearPair objectAtIndex:1] intValue];    
    
    NSInteger startingMonth = [[startingDateMonthYearPair objectAtIndex:0] intValue];
    NSInteger endMonth = [[endDateMonthYearPair objectAtIndex:0] intValue];
    
    NSInteger totalMonthsInRange = (1 + (endYear - startingYear)) * 12;
    totalMonthsInRange -= startingMonth;
    totalMonthsInRange -= (12 - (endMonth + 1));
    
    NSMutableArray *monthYearPairs = [NSMutableArray array];
    for (int mI = 0; mI < totalMonthsInRange; mI++) {
        NSInteger monthI = (mI + startingMonth) % 12;
        
        NSInteger floorValue = floor(mI / 12);
        NSLog(@"---> FLOOR VALUE: %i", floorValue);
        NSInteger yearI = startingYear + floor(mI / 12);
        NSArray *monthYearPair = [NSArray arrayWithObjects:[NSNumber numberWithInt:monthI], [NSNumber numberWithInt:yearI], nil];
        [monthYearPairs addObject:monthYearPair];
        NSLog(@"Month: %i, Year: %i", monthI, yearI);
    }
    
    return [NSArray arrayWithArray:monthYearPairs];
}

+(NSInteger)numberOfWeeksInRangeFromDate:(NSDate *)startingDate toDate:(NSDate *)endDate {
    return -1;
}

+(NSArray *)monthYearPairForDate:(NSDate *)date {
    NSArray *months = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    NSString *dateMonthString = [ALDateUtilities getFormattedDateStringWithDate:date andDateFormat:@"MMM"];
    NSString *dateYearString = [ALDateUtilities getFormattedDateStringWithDate:date andDateFormat:@"YYYY"];
    
    NSInteger montInt = [months indexOfObject:dateMonthString];
    NSInteger yearInt = [dateYearString intValue];
    
    NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithInt:montInt], [NSNumber numberWithInt:yearInt], nil];
    return result;
}

+(NSArray *)datesWithMonth:(ALDateMonth)month andYear:(NSUInteger)year {
    BOOL stillInMonth = YES;
    NSMutableArray *dates = [NSMutableArray array];
    NSUInteger monthI = month + 1;
    NSDate *nextDate = [ALDateUtilities dateWithYear:year month:monthI day:1];
    while (stillInMonth) {
        [dates addObject:nextDate];
        nextDate = [NSDate dateWithTimeInterval:(60.0 * 60.0 * 24.0) sinceDate:nextDate];
        NSInteger nextDateMonth = (NSInteger)[[[ALDateUtilities monthYearPairForDate:nextDate] objectAtIndex:0] intValue];
        if (nextDateMonth != month) {
            stillInMonth = NO;
        }
    }
    return [NSArray arrayWithArray:dates];
}

+(NSString *)durationStringWithTimeInterval:(NSTimeInterval)timeInterval {
    CGFloat durationTotalMinutes = floor(timeInterval / 60.0);
    CGFloat durationRemainderMinutes = (int)durationTotalMinutes % (int)60.0;
    CGFloat durationHours = floorf(durationTotalMinutes / 60.0);    
    return [NSString stringWithFormat:@"%0.0f h %0.0f min", durationHours, durationRemainderMinutes]; 
}

@end

#pragma mark - Categories

@implementation NSDate (Utilities)

+(NSDate *)dateWithYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day
                  hours:(NSInteger)hours
                minutes:(NSInteger)minutes
                 period:(ALDateTimePeriod)period {
    
    return [ALDateUtilities dateWithYear:year
                                   month:month
                                     day:day
                                   hours:hours
                                 minutes:minutes
                                  period:period];
}

+(NSDate *)dateWithYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day {

    return [ALDateUtilities dateWithYear:year
                                   month:month
                                     day:day];
}

@end