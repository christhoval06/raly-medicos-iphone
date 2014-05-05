//
//  LoginController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/12/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager+MedicosDB.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexString.h"

@interface LoginController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnEntrar;
@property (strong, nonatomic) IBOutlet UIButton *btnSalir;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (strong, nonatomic) IBOutlet UIView *loginForm;
@property SQLiteManager* medicodb;
@property (weak, nonatomic) IBOutlet UITextField *textUsuario;
@property (weak, nonatomic) IBOutlet UITextField *textClave;
@end

