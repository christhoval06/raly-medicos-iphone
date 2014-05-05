//
//  PacienteCell.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PacienteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imagen;
@property (strong, nonatomic) IBOutlet UILabel *nombre;
@property (strong, nonatomic) IBOutlet UILabel *cedula;
@property (strong, nonatomic) IBOutlet UILabel *codigo;

-(void)cellStyleImage;
@end
