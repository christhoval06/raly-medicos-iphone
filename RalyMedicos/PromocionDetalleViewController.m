//
//  PromocionDetalleViewViewController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/17/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PromocionDetalleViewController.h"

@interface PromocionDetalleViewController ()

@end

@implementation PromocionDetalleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titulo.text = _promocion.titulo;
    [_imagen setImageWithURL:[NSURL URLWithString:_promocion .imagen] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    [_html loadHTMLString:_promocion.html baseURL:nil];
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(volver:)];
    swiper.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiper];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)volver:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
