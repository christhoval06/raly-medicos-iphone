//
//  PacienteCell.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PacienteCell.h"

@implementation PacienteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
{
    _imagen = [[UIImageView alloc] initWithFrame:(CGRectMake(8, 6, 77, 66))];
    
    [self cellStyleImage];
    
    _nombre = [[UILabel alloc] initWithFrame:(CGRectMake(93, 12, 207, 21))];
    _nombre.font = [UIFont fontWithName:@"Geeza Pro" size:14];
    _nombre.textAlignment = NSTextAlignmentLeft;
    _nombre.lineBreakMode = NSLineBreakByClipping;
    _nombre.numberOfLines = 0;
    
    
    
    _cedula = [[UILabel alloc] initWithFrame:(CGRectMake(93, 51, 107, 21))];
    _cedula.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    _cedula.textAlignment = NSTextAlignmentLeft;
    
    _codigo = [[UILabel alloc] initWithFrame:(CGRectMake(208, 51, 92, 21))];
    _codigo.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    _codigo.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_imagen];
    [self.contentView addSubview:_nombre];
    [self.contentView addSubview:_cedula];
    [self.contentView addSubview:_codigo];
}
    
    return self;
}

-(void)cellStyleImage
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.editingAccessoryType = UITableViewCellEditingStyleNone;
    
    _imagen.layer.borderWidth = 2;
    _imagen.layer.borderColor = [UIColor whiteColor].CGColor;
    _imagen.layer.cornerRadius = CGRectGetHeight(_imagen.bounds) / 2;
    _imagen.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
