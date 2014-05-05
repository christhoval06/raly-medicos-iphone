//
//  Resultado.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resultado : NSObject
@property NSString *pacienteid;
@property NSString *resultadoid;
@property NSString *titulo;
@property NSDate *fecha;
@property NSString *sfecha;
@property NSString *pdf;
@property BOOL estado;

-(id)initWithResultado:(NSDictionary *)r;
-(NSString *)getPDFwithKey:(NSString *) key;
@end
