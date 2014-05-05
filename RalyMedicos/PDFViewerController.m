//
//  PDFViewerController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/21/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PDFViewerController.h"

@interface PDFViewerController ()

@end

@implementation PDFViewerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webview.scalesPageToFit = YES;
    NSURLRequest *url = [NSURLRequest requestWithURL: [NSURL fileURLWithPath:_ruta]];
    [_webview loadRequest:url];
    
    _lbltitulo.text = _titulo;
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backPressed:)];
    swiper.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiper];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
