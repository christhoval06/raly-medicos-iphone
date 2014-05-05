//
//  PacienteContactController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/19/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paciente.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+HexString.h"

@interface PacienteContactController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nombre;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UIButton *llamar;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIView *botonera;
@property Paciente *pacienteContactSelecionado;
@property NSString *key;
@end
