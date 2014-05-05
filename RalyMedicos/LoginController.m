//
//  LoginController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/12/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
@property NSDictionary *dictionary; // A dictionary object
@property NSMutableArray *json;
@property BOOL *success;
@property NSString *medico;
@property NSString *skey;
@property UIAlertView *alerta;
@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _skey=nil;
    _medico=nil;
    _textUsuario.delegate = self;
    _textClave.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [self customizarGUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) customizarGUI
{
    _loginForm.backgroundColor = [UIColor colorWithHexString:@"f2fafd"];
    _loginForm.layer.cornerRadius = 5;
    _loginForm.layer.masksToBounds = YES;
    _loginForm.layer.borderColor = [[UIColor colorWithHexString:@"ccecf8"] CGColor];
    _loginForm.layer.borderWidth = 2.0f;
}

- (IBAction)onEnter:(id)sender {
    if (_textUsuario.text.length >0 && _textClave.text.length >0)
        [self hacerLoginAsync];
    else
        [self alert:NSLocalizedString(@"LOGIN_ERROR", @"Error en Acceso") msg: NSLocalizedString(@"USER_PASS", @"Debe introducir su Usuario y Clave")];
}

- (IBAction)onSalir:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    exit(0);
}

-(void)alert: (NSString *) titulo msg: (NSString *) msg
{
    _alerta = [[UIAlertView alloc] initWithTitle: titulo message: msg delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil];
    [_alerta show];
}

-(void)guardarMedico: (id) json
{
    _medico = [json objectForKey:@"medico"];
    _skey = [json objectForKey:@"skey"];
    [_medicodb  saveMedico:[NSDictionary dictionaryWithObjectsAndKeys:_medico,@"medico",_skey,@"skey",[json objectForKey:@"usuario"],@"usuario",[json objectForKey:@"telefono"],@"telefono", nil]];
    [self irInicio];
}

-(void)irInicio
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hacerLoginAsync
{
    if ([[_medicodb getParametro:@"internet" withDefault:@"NO"] boolValue]) {
        [_loader startAnimating];
        dispatch_queue_t Login = dispatch_queue_create("Login", NULL);
        dispatch_async(Login, ^{
            NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/hacerloginmed?usuario=%@&clave=%@", _textUsuario.text, _textClave.text]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(jsonSource){
                    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
                    if ([[jsonObjects objectForKey:@"success"] boolValue] ) {
                        [self guardarMedico:jsonObjects];
                    } else
                        [self alert:NSLocalizedString(@"LOGIN_ERROR", @"Error en Acceso") msg:NSLocalizedString(@"LOGIN_ERROR_USER_PASS", @"Usuario o clave no válidas")];
                }else
                    [self alert:NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") msg:NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet")];
                [_loader stopAnimating];
                
            });
        });
    }else
        [self alert:NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") msg:NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet")];
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1) {
        [textField resignFirstResponder];
        [(UITextField *) [self.view viewWithTag:2] becomeFirstResponder];
        return YES;
    }else if (textField.tag==2){
        [textField resignFirstResponder];
         [self hacerLoginAsync];
        return YES;
    }
    return NO;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


/**** SOCIAL ICONS EVENTS ****/
- (IBAction)goToTwitter:(id)sender {
    NSURL *twt = [NSURL URLWithString:@"twitter://Ralylab"];
    if ([[UIApplication sharedApplication] canOpenURL:twt]) {
        [[UIApplication sharedApplication] openURL:twt];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/Ralylab"]];
    }
}
- (IBAction)goToFacebook:(id)sender {
    NSURL *fb = [NSURL URLWithString:@"fb://profile/616228871803418"];
    if ([[UIApplication sharedApplication] canOpenURL:fb]) {
        [[UIApplication sharedApplication] openURL:fb];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/profile.php?id=616228871803418"]];
    }
}


@end
