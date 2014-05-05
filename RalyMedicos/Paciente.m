//
//  Paciente.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "Paciente.h"

@implementation Paciente

-(id)initWithPaciente:(NSDictionary *)p
{
    _pacienteid = [p valueForKey:@"pacienteid"];
    _nombre = [p valueForKey:@"nombre"];
    _cedula = [p valueForKey:@"cedula"];
    _codigo = [p valueForKey:@"codigo"];
    _foto = [p valueForKey:@"foto"];
    _telefono = [p valueForKey:@"telefono"];
    return self;
}

-(NSString *)getFotoWithKey: (NSString * )key
{
    return [_foto isEqualToString:@"../images/fotonula.jpg"] ? nil : [NSString stringWithFormat:@"%@&skey=%@",_foto,key];
}

@end
