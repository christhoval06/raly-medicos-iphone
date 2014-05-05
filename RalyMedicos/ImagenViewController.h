//
//  ImagenViewController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promocion.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ImagenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UIButton *cerrar;
@property (weak, nonatomic) IBOutlet UITextView *html;
@property Promocion *promocion;
@end
