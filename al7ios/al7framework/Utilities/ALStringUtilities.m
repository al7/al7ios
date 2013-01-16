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

#import "ALStringUtilities.h"
#import "ALDevUtilities.h"

@implementation ALStringUtilities

+(NSString *)getSpecialCharacterOfType:(ALStringSpecialCharacterType)type {
    NSString *result;
    switch (type) {
        case ALStringSpecialCharacterTypeCopyright:
            result = @"©";
            break;
        case ALStringSpecialCharacterTypeRegisteredMark:
            result = @"®";
            break;
        case ALStringSpecialCharacterTypeTrademark:
            result = @"™";
            break;
        case ALStringSpecialCharacterTypePi:
            result = @"π";
            break;
        default:
            result = [NSString string];
            break;
    }
    return result;
}

+(NSString *)generateGUIDwithNumberOfCharacters:(NSUInteger)numberOfCharacters {
    NSArray *possibleCharacters = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSString *result = @"";
    for (int i = 0; i < numberOfCharacters; i++) {
        NSString *newCharacter = [ALDevUtilities getRandomObjectFromArray:possibleCharacters];
        result = [NSString stringWithFormat:@"%@%@", result, newCharacter];
    }
    return result;
}

+(NSString *)generateGUID {
    return [ALStringUtilities generateGUIDwithNumberOfCharacters:12];
}

+(NSString *)stringForIntegerSeparatedByCommas:(NSInteger)integer {
    NSString *result = @"0";
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSize:3];
    [nf setGroupingSeparator:@","];
    [nf setUsesGroupingSeparator:YES];
    result = [nf stringFromNumber:[NSNumber numberWithInt:integer]];
    return result;
}

@end

@implementation NSString (StringUtilities)

+(NSString *)specialCharacterOfType:(ALStringSpecialCharacterType)type {
    return [ALStringUtilities getSpecialCharacterOfType:type];
}

+(NSString *)registeredMark {
    return [ALStringUtilities getSpecialCharacterOfType:ALStringSpecialCharacterTypeRegisteredMark];
}

+(NSString *)trademark {
    return [ALStringUtilities getSpecialCharacterOfType:ALStringSpecialCharacterTypeTrademark];
}

+(NSString *)copyright {
    return [ALStringUtilities getSpecialCharacterOfType:ALStringSpecialCharacterTypeCopyright];
}

+(NSString *)pi {
    return [ALStringUtilities getSpecialCharacterOfType:ALStringSpecialCharacterTypePi];
}

@end