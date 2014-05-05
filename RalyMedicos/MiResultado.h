//
//  MiResultado.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager+MedicosDB.h"

@interface MiResultado : NSObject
@property (copy) NSString* pacienteid;
@property (copy) NSString* paciente;
@property (copy) NSString* resultadoid;
@property (copy) NSString* resultado;
@property (copy) NSString* fecha;
@property (copy) NSString* file;
@property SQLiteManager *medicosdb;

-(id)initWithFile: (NSDictionary *) file;
-(id)initWithFile: (NSDictionary *) file andDB: (SQLiteManager *)db;
-(BOOL)borrarFile;
@end
