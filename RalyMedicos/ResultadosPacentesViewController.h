//
//  ResultadosPacentesViewController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paciente.h"
#import "SQLiteManager+MedicosDB.h"
#import "Resultado.h"
#import "UIColor+HexString.h"
#import "ResultadoCell.h"
#import "PDFViewerController.h"

@interface ResultadosPacentesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property Paciente *paciente;
@property SQLiteManager *medicosdb;
@property NSString *key;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@end
