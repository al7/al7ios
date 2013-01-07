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

#import <Foundation/Foundation.h>

typedef enum {
    ALDateTimePeriodAM,
    ALDateTimePeriodPM
} ALDateTimePeriod;

typedef enum {
    ALDateTimeUnitSeconds,
    ALDateTimeUnitMinutes,
    ALDateTimeUnitHours,
    ALDateTimeUnitDays,
    ALDateTimeUnitWeeks,    
    ALDateTimeUnitMonths,
    ALDateTimeUnitTrimesters,
    ALDateTimeUnitSemesters,    
    ALDateTimeUnitYears,
    ALDateTimeUnitDecades
} ALDateTimeUnit;

typedef enum {
    ALDateMonthJanuary,
    ALDateMonthFebruary,
    ALDateMonthMarch,
    ALDateMonthApril,
    ALDateMonthJune,
    ALDateMonthJuly,
    ALDateMonthAugust,
    ALDateMonthSeptember,
    ALDateMonthOctober,
    ALDateMonthNovember,
    ALDateMonthDecember
} ALDateMonth;

@interface ALDateUtilities : NSObject {
    
}

+(NSDate *)getDateFromFormattedDateString:(NSString *)aFormattedDateString withDateFormat:(NSString *)aDateFormat;
+(NSDate *)getDateFromFormattedDateString:(NSString *)aFormattedDateString;
+(NSString *)getFormattedDateStringWithDate:(NSDate *)aDate andDateFormat:(NSString *)aDateFormat;
+(NSString *)getFormattedDateStringWithDate:(NSDate *)aDate;
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hours:(NSInteger)hours minutes:(NSInteger)minutes period:(ALDateTimePeriod)period;
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSInteger)numberOfDaysFromStartingDate:(NSDate *)startingDate toEndDate:(NSDate *)endDate;
+(NSInteger)numberOfWeeksForNumberOfDays:(NSInteger)days;
+(NSInteger)numberOfWeeksInRangeFromDate:(NSDate *)startingDate toDate:(NSDate *)endDate;
+(NSArray *)monthsFromDate:(NSDate *)startingDate toDate:(NSDate *)endDate;
+(NSArray *)daysInWeekOfDate:(NSDate *)date;
+(NSArray *)monthYearPairForDate:(NSDate *)date;
+(NSArray *)datesWithMonth:(ALDateMonth)month andYear:(NSUInteger)year;
+(NSInteger)timeInterval:(NSTimeInterval)timeInterval inTimeUnit:(ALDateTimeUnit)timeUnit;
+(NSString *)durationStringWithTimeInterval:(NSTimeInterval)timeInterval;

@end

#pragma mark - Categories;

@interface NSDate (Utilities)

+(NSDate *)dateWithYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day
                  hours:(NSInteger)hours
                minutes:(NSInteger)minutes
                 period:(ALDateTimePeriod)period;

+(NSDate *)dateWithYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day;

@end