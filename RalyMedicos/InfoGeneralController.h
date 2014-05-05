//
//  InicioController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/13/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager+MedicosDB.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Promocion.h"
#import "PromocionCell.h"
#import "UIColor+HexString.h"
#import "PromocionDetalleViewController.h"
#import "ImagenViewController.h"

@interface InfoGeneralController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property SQLiteManager *medicosdb;
@property NSString *key;
@property (weak, nonatomic) IBOutlet UITableView *promocionesList;
@end
