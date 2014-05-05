//
//  MiResultado.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "MiResultado.h"

@implementation MiResultado

-(id)initWithFile: (NSDictionary *) f
{
    _pacienteid = [f valueForKey:@"pacienteid"];
    _paciente = [f valueForKey:@"paciente"];
    _resultadoid = [f valueForKey:@"resultadoid"];
    _resultado = [f valueForKey:@"resultado"];
    _fecha = [f valueForKey:@"fecha"];
    _file = [f valueForKey:@"file"];
   return self; 
}

-(id)initWithFile: (NSDictionary *) f andDB: (SQLiteManager *)db
{
    _medicosdb = db;
    _pacienteid = [f valueForKey:@"pacienteid"];
    _paciente = [f valueForKey:@"paciente"];
    _resultadoid = [f valueForKey:@"resultadoid"];
    _resultado = [f valueForKey:@"resultado"];
    _fecha = [f valueForKey:@"fecha"];
    _file = [f valueForKey:@"file"];
    return self;
}

-(BOOL)borrarFile
{
    return [[NSFileManager defaultManager] removeItemAtPath:_file error:NULL];
}
@end
