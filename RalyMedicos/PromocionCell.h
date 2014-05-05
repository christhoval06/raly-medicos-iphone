//
//  SimpleTableCell.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/17/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HexString.h"

@interface PromocionCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titulo;
@property (nonatomic, strong) IBOutlet UILabel *precio;
@property (nonatomic, strong) IBOutlet UIImageView *imagen;
@end
