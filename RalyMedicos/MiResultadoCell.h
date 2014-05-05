//
//  MiResultadoCell.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiResultado.h"

@interface MiResultadoCell : UITableViewCell <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@property (strong, nonatomic) IBOutlet UILabel *fecha;

@property MiResultado *resultado;

@end
