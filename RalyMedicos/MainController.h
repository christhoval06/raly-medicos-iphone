//
//  MainController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/28/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager+MedicosDB.h"
#import "LoginController.h"
#import "PacientesController.h"

@interface MainController : UIViewController
@property SQLiteManager *medicosdb;
@end
