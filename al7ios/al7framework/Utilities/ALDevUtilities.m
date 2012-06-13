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

#import "ALDevUtilities.h"
#import "ALDateUtilities.h"

@implementation ALDevUtilities

+(void)showActionAlertWithMessage:(NSString *)aMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action" message:aMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

+(id)getRandomObjectFromArray:(NSArray *)anArray {
    int rndIndex = arc4random() % [anArray count];
    return [anArray objectAtIndex:rndIndex];
}

+(CGFloat)getRandomFloatFrom:(CGFloat)minValue to:(CGFloat)maxValue {
    CGFloat valueDifference = maxValue - minValue;
    CGFloat randomIncrement = arc4random() * valueDifference;
    return minValue + randomIncrement;
}

+(NSInteger)getRandomIntegerFrom:(NSInteger)minValue to:(NSInteger)maxValue {
    NSInteger valueDifference = maxValue - minValue;
    NSInteger randomIncrement = arc4random() % valueDifference;
    return minValue + randomIncrement;
}

+(NSDictionary *)flightSegmentDictionaryWithOrigin:(NSString *)origin 
                                       destination:(NSString *)destination
                                     departureDate:(NSDate *)departureDate
                                       arrivalDate:(NSDate *)arrivalDate
                                      flightNumber:(NSString *)flightNumber {
    
    NSMutableDictionary *fliSegDict = [NSMutableDictionary dictionary];
    [fliSegDict setObject:origin forKey:@"origin"];
    [fliSegDict setObject:destination forKey:@"destination"]; 
    [fliSegDict setObject:flightNumber forKey:@"flightNumber"];
    [fliSegDict setObject:departureDate forKey:@"departureDate"];
    [fliSegDict setObject:arrivalDate forKey:@"arrivalDate"];
    
    return [NSDictionary dictionaryWithDictionary:fliSegDict];
}

@end
