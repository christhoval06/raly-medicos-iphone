//
//  PacientesController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/12/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager+MedicosDB.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Paciente.h"
#import "PacienteCell.h"
#import "UIColor+HexString.h"
#import "ModalAnimation.h"
#import "ImagenViewController.h"
#import "PacienteContactController.h"
#import "RNGridMenu.h"
#import "ResultadosPacentesViewController.h"
#import "MisResultadosViewController.h"
#import "InfoGeneralController.h"

@interface PacientesController: UIViewController <RNGridMenuDelegate,UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property NSString *key;
@property SQLiteManager *medicosdb;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)showOptionMenu;
@end
