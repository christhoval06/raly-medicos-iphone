//
//  ResultadoCell.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HexString.h"
#import "Resultado.h"

@interface ResultadoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@property (strong, nonatomic) IBOutlet UIImageView *descargado;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *descargando;

@property Resultado *resultado;
@end
