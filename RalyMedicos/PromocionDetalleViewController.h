//
//  PromocionDetalleViewViewController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/17/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promocion.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface PromocionDetalleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UIWebView *html;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property Promocion *promocion;
@end
