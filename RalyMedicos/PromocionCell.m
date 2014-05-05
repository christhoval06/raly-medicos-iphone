//
//  SimpleTableCell.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/17/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PromocionCell.h"

@implementation PromocionCell

@synthesize titulo = _titulo;
@synthesize precio = _precio;
@synthesize imagen = _imagen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _imagen = [[UIImageView alloc] initWithFrame:(CGRectMake(5, 4, 92, 72))];
        
        _titulo = [[UILabel alloc] initWithFrame:(CGRectMake(102, 1, 198, 34))];
        _titulo.font = [UIFont fontWithName:@"Helvetica Neue Thin" size:18];
        _titulo.textAlignment = NSTextAlignmentLeft;
        
        _precio = [[UILabel alloc] initWithFrame:(CGRectMake(102, 49, 192, 21))];
        _precio.font = [UIFont fontWithName:@"Helvetica Neue Medium" size:15];
        _precio.textAlignment = NSTextAlignmentLeft;
        _precio.textColor = [UIColor colorWithHexString:@"237823"];
        
        [self.contentView addSubview:_imagen];
        [self.contentView addSubview:_titulo];
        [self.contentView addSubview:_precio];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
