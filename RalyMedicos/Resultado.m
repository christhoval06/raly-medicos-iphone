//
//  Resultado.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "Resultado.h"

@implementation Resultado

-(id)initWithResultado:(NSDictionary *)r
{
    _pacienteid = [r valueForKey:@"pacienteid"];
    _resultadoid = [r valueForKey:@"resultadoid"];
    _titulo = [r valueForKey:@"titulo"];
    _sfecha = [r valueForKey:@"fecha"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    _fecha   = [formatter dateFromString:[r valueForKey:@"fecha"]];
    _pdf = [r valueForKey:@"pdf"];
    _estado = [[r valueForKey:@"estado"] boolValue];
    return self;
}

-(NSString *)getPDFwithKey: (NSString * )key
{
    return [[_pdf stringByReplacingOccurrencesOfString: @"/raly" withString: @"http://laboratorioraly.com/raly"] stringByAppendingString:[NSString stringWithFormat:@"&skey=%@",key]];
}


@end
