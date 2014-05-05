//
//  Promocion.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/14/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "Promocion.h"

@implementation Promocion

-(id)initWithPromocion: (NSDictionary *) dic
{
    _titulo = [dic valueForKey:@"titulo"];
    _precio = [dic valueForKey:@"precio"];
    _url = [dic valueForKey:@"url"];
    _imagen = [dic valueForKey:@"imagen"];
    _html = [dic valueForKey:@"html"];
    return self;
}

@end
