//
//  SQLiteManager+MedicosDB.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/13/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "SQLiteManager.h"

@interface SQLiteManager (MedicosDB)
-(id)createDB: (NSString *)dbnombre;
-(void)clearCache;

#pragma mark medico
-(BOOL)deleteMedico;
-(BOOL)saveMedico: (NSDictionary *) medico;
-(BOOL)haveMedico;
-(NSString *)getkey;
-(NSDictionary *)getMedico;
-(NSString *)getMedico: (NSString *)key;

#pragma mark promociones
-(BOOL)havePromociones;
-(BOOL)savePromocion: (NSDictionary *) promocion;
-(NSArray *)getPromociones;
-(BOOL)deletePromociones;

#pragma mark pacientes
-(BOOL)havePacientes;
-(BOOL)savePaciente: (NSDictionary *) paciente;
-(NSArray *)getPacientes;
-(NSDictionary *)getPaciente: (NSString *)pacienteId;
-(NSString *)getValueFromPaciente: (NSString *)pacienteId andKey:(NSString *) key;
-(BOOL)deletePacientes;

#pragma mark resultados
-(BOOL)haveResultados;
-(BOOL)haveResultadosForPaciente: (NSString *)pacienteId;
-(BOOL)saveResultado: (NSDictionary *) resultado;
-(NSArray *)getResultadosOfPaciente: (NSString *)pacienteId;
-(BOOL)deleteResultados;

#pragma mark resultadosfiles
-(BOOL)haveResultadosFiles;
-(BOOL)haveFileFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId;
-(NSArray *)getResultadosFacientes;
-(NSString *)getPDFFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId;
-(BOOL)saveResultadoFile: (NSDictionary *) file;
-(BOOL )deleteFileFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId;

#pragma mark parametros
-(NSString *)getParametro: (NSString *) p withDefault: (NSString *) d;
-(BOOL)haveParametroWithNombre: (NSString *)p;
-(BOOL)setParametro: (NSString *) p withValue: (NSString *) v;
@end
