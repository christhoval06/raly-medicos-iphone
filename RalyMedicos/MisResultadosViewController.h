//
//  MisResultadosViewController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager+MedicosDB.h"
#import "MiResultado.h"
#import "UIColor+HexString.h"
#import "MiResultadoCell.h"
#import "PDFViewerController.h"

@interface MisResultadosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property SQLiteManager *medicosdb;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@end
