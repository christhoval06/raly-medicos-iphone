//
//  Paciente.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paciente : NSObject
@property (copy) NSString* pacienteid;
@property (copy) NSString* nombre;
@property (copy) NSString* cedula;
@property (copy) NSString* codigo;
@property (copy) NSString* foto;
@property (copy) NSString* telefono;

-(id)initWithPaciente: (NSDictionary *) paciente;
-(NSString *)getFotoWithKey: (NSString * )key;
@end
