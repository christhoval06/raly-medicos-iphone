//
//  Promocion.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/14/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promocion : NSObject 
@property (copy) NSString* titulo;
@property (copy) NSString* precio;
@property (copy) NSString* url;
@property (copy) NSString* imagen;
@property (copy) NSString* html;

-(id)initWithPromocion: (NSDictionary *) dic;
@end
