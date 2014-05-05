//
//  ResultadoCell.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "ResultadoCell.h"

@implementation ResultadoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _descargado = [[UIImageView alloc] initWithFrame:(CGRectMake(250, 2, 16, 16))];
        _descargado.image = [UIImage imageNamed:@"down.png"];
        _descargado.hidden=YES;
        
        _titulo = [[UILabel alloc] initWithFrame:(CGRectMake(11, 2, 261, 61))];
        _titulo.font = [UIFont fontWithName:@"System" size:17];
        _titulo.textAlignment = NSTextAlignmentLeft;
        
        
        _descargando = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _descargando.color =[UIColor colorWithHexString:@"#33B5E5"];
        _descargando.center = CGPointMake(250, 25);
        
        [self.contentView addSubview:_descargado];
        [self.contentView addSubview:_titulo];
        [self.contentView addSubview:_descargando];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
