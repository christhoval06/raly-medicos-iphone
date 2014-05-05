//
//  UIColor+HexString.h
//  HolaMundo
//
//  Created by Christoval  Barba on 03/11/14.
//  Copyright (c) 2014 Christhoval Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+(UIColor *) colorWithHexString: (NSString *) hexString;
+(NSString *)hexValuesFromUIColor:(UIColor *)color;
@end
