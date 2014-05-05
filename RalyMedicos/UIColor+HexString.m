//
//  UIColor+HexString.m
//  HolaMundo
//
//  Created by Christoval  Barba on 03/11/14.
//  Copyright (c) 2014 Christhoval Barba. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+(UIColor *)colorWithHexString:(NSString *)hexString {
    hexString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    if ([hexString length] < 3)
        return nil;
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    
    if (match != 0)
        return nil;
    
    float alpha, red, blue, green;
    
    switch ([hexString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self convertir:hexString start:0 end:1];
            green = [self convertir:hexString start:1 end:1];
            blue = [self convertir:hexString start:2 end:1];
            break;
        case 4: // #ARGB
            alpha = [self convertir:hexString start:0 end:1];
            red = [self convertir:hexString start:1 end:1];
            green = [self convertir:hexString start:2 end:1];
            blue = [self convertir:hexString start:3 end:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self convertir:hexString start:0 end:2];
            green = [self convertir:hexString start:2 end:2];
            blue = [self convertir:hexString start:4 end:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self convertir:hexString start:0 end:2];
            red = [self convertir:hexString start:2 end:2];
            green = [self convertir:hexString start:4 end:2];
            blue = [self convertir:hexString start:6 end:2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

+(float) convertir: (NSString *)hexString start:(NSInteger)start end:(NSInteger) end {
    NSRange range = NSMakeRange(start, end);
    NSString *component = [hexString substringWithRange:range];
    NSUInteger val = 0;
    NSScanner *scanner = [NSScanner scannerWithString:component];
    [scanner scanHexInt:&val];
    return (float)val / 254;
}


+(NSString *)hexValuesFromUIColor:(UIColor *)color {
    
    if (!color)
        return nil;
    
    if (color == [UIColor whiteColor])
        return @"ffffff";
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    return returnString;
}

@end
