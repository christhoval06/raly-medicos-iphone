//
//  PacienteContactController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/19/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PacienteContactController.h"

@interface PacienteContactController ()
@property NSDictionary *datosPaciente;
@property BOOL isiPhone;
@end

@implementation PacienteContactController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isiPhone = [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"];
    _nombre.text = NSLocalizedString(@"LOADING", @"Cargando ...");
    [self LoadDataPacientes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)imagenTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


-(void)LoadDataPacientes
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    __block UIActivityIndicatorView *activityIndicator;
    if (!activityIndicator)
    {
        [_imagen addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        activityIndicator.center = _imagen.center;
        [activityIndicator startAnimating];
    }
    dispatch_queue_t PacientesContact = dispatch_queue_create("PacientesContact", NULL);
    dispatch_async(PacientesContact, ^{
        NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/medicom?fnt=datapaciente&skey=%@&pacienteid=%@", _key, _pacienteContactSelecionado.pacienteid]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(jsonSource){
                NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
                if ([[jsonObjects objectForKey:@"success"] boolValue] )
                    [self  cargarDatosPacientes:[[jsonObjects objectForKey:@"paciente"]objectAtIndex:0] ];
                else
                [[[UIAlertView alloc] initWithTitle: @"" message:NSLocalizedString(@"ERROR_LOADING_PATIENTS", @"Error Cragando Pacientes") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar")otherButtonTitles:nil, nil] show];
            }else
                [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") message: NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        });
    });
}

-(void)cargarDatosPacientes:(NSDictionary *) paciente
{
    
    _datosPaciente = paciente;
    UITapGestureRecognizer *tapper =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagenTap:)];
    tapper.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer: tapper];
    
    [_imagen setImageWithURL:[NSURL URLWithString:[_pacienteContactSelecionado getFotoWithKey:_key]] placeholderImage:[UIImage imageNamed:@"no_image.png"]];
    _nombre.text = _pacienteContactSelecionado.nombre;
    
    NSString *telefono = _isiPhone ? [paciente objectForKey:@"telefono"] : nil;
    //NSString *telefono = [paciente objectForKey:@"telefono"];
    NSString *email = [paciente objectForKey:@"mail"];
    if(![self isEmpty:telefono])
        [self createImageButtonWithRect:CGRectMake(20, 13, [self isEmpty:email]?222:100, 39) label:NSLocalizedString(@"CALL", @"Llamar") selector: @selector(llamarPaciente:) inView:_botonera];
    
    if(![self isEmpty:email])
        [self createImageButtonWithRect:CGRectMake([self isEmpty:telefono]?20:141, 13, [self isEmpty:telefono]?222:100, 39) label:NSLocalizedString(@"EMAIL", @"Correo") selector: @selector(emailPaciente:) inView:_botonera];
    
    if ([self isEmpty:telefono] && [self isEmpty:email] )
        [self createImageButtonWithRect:CGRectMake(20, 13, 222, 39) label:NSLocalizedString(@"CLOSE", @"Cerrar") selector: @selector(salir:) inView:_botonera];
}

-(BOOL)isEmpty:(NSString *) s
{
    if ((NSNull *)s == [NSNull null] || (s == nil)) return  YES;
    if ([[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) return YES;
    return NO;
}


-(void)createImageButtonWithRect: (CGRect) rect label:(NSString *) label selector: (SEL)selector inView:(UIView *) view
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:label forState:UIControlStateNormal];
    [btn setFrame:rect];
    [btn setTintColor:[UIColor colorWithHexString:@"c0ecf7"]];
    [btn setTitleColor:[UIColor colorWithHexString:@"c0ecf7"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"4ECBEC"] forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"21bde8"]];
    [btn.layer setBorderColor:[UIColor colorWithHexString:@"a0e3f5"].CGColor];
    [btn.layer setBorderWidth:3.f];
    [btn.layer setCornerRadius:5.f];
    [view addSubview:btn];
}

-(void)llamarPaciente:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[@"telprompt://" stringByAppendingString: [_datosPaciente objectForKey:@"telefono"]]]];
}

-(void)emailPaciente:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[@"mailto://" stringByAppendingString: [_datosPaciente objectForKey:@"mail"]]]];
}

-(void)salir:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
