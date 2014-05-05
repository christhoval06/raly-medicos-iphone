//
//  SQLiteManager+MedicosDB.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/13/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "SQLiteManager+MedicosDB.h"
@implementation SQLiteManager (MedicosDB)

-(id)createDB: (NSString *) nombre
{
    [self initWithDatabaseNamed:nombre];
    [self createTablas];
    return self;
}



#pragma funciones para la tabla medicos
-(BOOL)haveMedico
{
    return [self have:@"medicos"];
}
-(BOOL)deleteMedico
{
    return [self vaciarTabla:@"medicos"];
}
-(BOOL)saveMedico: (NSDictionary *) medico
{
    return [self guardar:@"medicos" datos:medico];
}
-(NSString *)getkey
{
    return [self getMedico:@"skey"];
}
-(NSDictionary *)getMedico
{
    return nil;
}
-(NSString *)getMedico: (NSString *)key
{
    return [[[self getRowsForQuery:[NSString stringWithFormat:@"select %@ from medicos limit 1;", key]] objectAtIndex:0] objectForKey:key];
}


#pragma funciones para la tabla promociones
-(BOOL)havePromociones
{
    return [self have:@"promociones"];
}
-(BOOL)savePromocion: (NSDictionary *) promocion
{
    return [self guardar:@"promociones" datos:promocion];
}
-(NSArray *)getPromociones
{
    return [self getRowsForQuery:@"select * from promociones;"];
}
-(BOOL)deletePromociones
{
    return [self vaciarTabla:@"promociones"];
}


#pragma mark pacientes
-(BOOL)havePacientes
{
    return [self have:@"pacientes"];
}
-(BOOL)savePaciente: (NSDictionary *) paciente
{
    return [self guardar:@"pacientes" datos:paciente];
}
-(NSArray *)getPacientes
{
    return [self getRowsForQuery:@"select * from pacientes;"];
}
-(NSDictionary *)getPaciente: (NSString *)pacienteId
{
    return [[self getRowsForQuery:[NSString stringWithFormat:@"select * from pacientes where pacienteid=%@;", pacienteId]] objectAtIndex:0];
}
-(NSString *)getValueFromPaciente: (NSString *)pacienteId andKey:(NSString *) key
{
    return [[[self getRowsForQuery:[NSString stringWithFormat:@"select %@ from pacientes where pacienteid=%@;", key, pacienteId]] objectAtIndex:0] objectForKey:key];
}
-(BOOL)deletePacientes{
    return [self vaciarTabla:@"pacientes"];
}

#pragma mark resultados
-(BOOL)haveResultados
{
    return [self have:@"resultados"];
}
-(BOOL)haveResultadosForPaciente: (NSString *)pacienteId
{
    return [[self getRowsForQuery:[NSString stringWithFormat:@"select * from resultados where pacienteid=%@;", pacienteId]] count] > 0;
}
-(BOOL)saveResultado: (NSDictionary *) resultado
{
    return [self guardar:@"resultados" datos:resultado];
}
-(NSArray *)getResultadosOfPaciente: (NSString *)pacienteId
{
    return [self getRowsForQuery:[NSString stringWithFormat:@"select * from resultados where pacienteid=%@;", pacienteId]];
}
-(BOOL)deleteResultados
{
    return [self vaciarTabla:@"resultados"];
}

#pragma mark resultadosfiles
-(BOOL)haveResultadosFiles
{
    return [self have:@"resultadosfiles"];
}
-(BOOL)haveFileFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId
{
    return [[self getRowsForQuery:[NSString stringWithFormat:@"select file from resultadosfiles where pacienteid=%@ and resultadoid=%@ limit 1;", pacienteId, resultadoId]] count] > 0;
}
-(NSArray *)getResultadosFacientes
{
    return [self getRowsForQuery:@"select * from resultadosfiles order by paciente,fecha asc,resultado;"];
}
-(NSString *)getPDFFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId
{
    return [[[self getRowsForQuery:[NSString stringWithFormat:@"select file from resultadosfiles where pacienteid=%@ and resultadoid=%@ limit 1;", pacienteId, resultadoId]] objectAtIndex:0] objectForKey:@"file"];
}
-(BOOL)saveResultadoFile: (NSDictionary *) file{
    return [self guardar:@"resultadosfiles" datos:file];
}
-(BOOL )deleteFileFromPaciente: (NSString *)pacienteId andResultadoId: (NSString *)resultadoId{
    NSError *error = [self doQuery: [NSString stringWithFormat:@"delete from resultadosfiles where pacienteid=%@ and resultadoid=%@;", pacienteId, resultadoId]];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
	}
    return YES;
}

#pragma mark parametros
-(NSString *)getParametro: (NSString *) p withDefault: (NSString *) d
{
    if ([self haveParametroWithNombre:p]) {
        return [[[self getRowsForQuery:[NSString stringWithFormat:@"select * from parametros where nombre='%@' limit 1;", p]] objectAtIndex:0] objectForKey:@"valor"];
    }else return d;
}
-(BOOL)haveParametroWithNombre: (NSString *)p{
    return [[self getRowsForQuery:[NSString stringWithFormat:@"select * from parametros where nombre='%@' limit 1;", p]] count] > 0;
}
-(BOOL)setParametro: (NSString *) p withValue: (NSString *) v{
    NSString * sql;
    if (![self haveParametroWithNombre:p])
        sql =[NSString stringWithFormat:@"insert into parametros (nombre,valor) values ('%@','%@');", p, v];
    else
        sql =[NSString stringWithFormat:@"update parametros set valor='%@' where nombre='%@';", v, p];
    NSError *error = [self doQuery: sql];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
	}
    return YES;
}


-(void)clearCache
{
    [self deletePacientes];
    [self deletePromociones];
    [self deleteResultados];
}



#pragma  funciones internas de esta clase
-(NSArray *)getAll: (NSString *)tabla
{
    return [self getRowsForQuery:[NSString stringWithFormat:@"select * from %@;",tabla]];
}

-(BOOL)have: (NSString *) tabla
{
    return [[self getAll:tabla] count] >0;
}

-(BOOL)vaciarTabla: (NSString *) tabla
{
    NSError *error = [self doQuery: [NSString stringWithFormat:@"delete from %@;",tabla]];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
	}
    return YES;
}

-(BOOL)createTablas
{
    NSError *error;
    for (NSString *sql in [self getSQLTablas]) {
        if((error = [self doQuery:sql]) != nil){
            NSLog(@"Error: %@",[error localizedDescription]);
            return NO;
        }
    }
    return YES;
}

-(BOOL)guardar: (NSString *) tabla datos: (NSDictionary *) datos;
{
    id __unsafe_unretained values[[datos count]];
    id __unsafe_unretained keys[[datos count]];
    NSMutableString *v = [NSMutableString stringWithString:@""];
    NSMutableString *k = [NSMutableString stringWithString:@""];
    [datos getObjects:values andKeys:keys];
    for( int i=0; i< [datos count]; i++){
        [v appendString:[NSString stringWithFormat:@"'%@',",values[i]]];
        [k appendString:[NSString stringWithFormat:@"%@,",keys[i]]];
    }
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);",tabla, k, v];
    sql = [sql stringByReplacingOccurrencesOfString: @",)" withString: @")"];
    NSError *error = [self doQuery:sql];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
	}
    return YES;
}


-(NSArray *)getSQLTablas
{
    return @[[self getSQLMedicos], [self getSQLPromociones], [self getSQLPacientes], [self getSQLResultados], [self getSQLResultadosFiles], [self getSQLParametros]];
}
-(NSString *)getSQLMedicos
{
    return @"CREATE TABLE IF NOT EXISTS medicos(id INTEGER primary key autoincrement, medico TEXT not null, telefono TEXT not null, usuario TEXT not null, skey TEXT not null)";
}
-(NSString *)getSQLPromociones
{
    return @"CREATE TABLE IF NOT EXISTS promociones(id INTEGER primary key autoincrement, titulo TEXT not null, precio TEXT not null, url TEXT not null, imagen TEXT not null, html TEXT not null)";
}
-(NSString *)getSQLPacientes
{
    return @"CREATE TABLE IF NOT EXISTS pacientes(id INTEGER primary key autoincrement, pacienteid TEXT not null, nombre TEXT not null, codigo TEXT not null, cedula TEXT not null, foto TEXT not null, telefono TEXT not null)";
}

-(NSString *)getSQLResultados
{
    return @"CREATE TABLE IF NOT EXISTS resultados(id INTEGER primary key autoincrement, titulo TEXT not null, pacienteid TEXT not null, fecha TEXT not null, resultadoid TEXT not null, pdf TEXT, estado INTEGER)";
}

-(NSString *)getSQLResultadosFiles
{
    return @"CREATE TABLE IF NOT EXISTS resultadosfiles(id INTEGER primary key autoincrement,pacienteid TEXT not null, paciente TEXT not null, resultadoid TEXT not null, resultado TEXT not null, fecha TEXT not null, file TEXT not null)";
}

-(NSString *)getSQLParametros
{
    return @"CREATE TABLE IF NOT EXISTS parametros(id INTEGER primary key autoincrement,nombre TEXT not null, valor TEXT not null)";
}



@end
