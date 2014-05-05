//
//  ImagenViewController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/18/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "ImagenViewController.h"

@interface ImagenViewController ()

@end

@implementation ImagenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imagen setImageWithURL:[NSURL URLWithString:_promocion.imagen] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    _imagen.contentMode = UIViewContentModeScaleAspectFit;
    _imagen.userInteractionEnabled=YES;
    self.view.userInteractionEnabled = YES;
    
    _html.attributedText = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<style>body{color:white;}</style>%@", _promocion.html] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _html.userInteractionEnabled=YES;                                                                                                                                          
    _cerrar.layer.borderColor =[UIColor whiteColor].CGColor;
    _cerrar.layer.borderWidth = 2.f;
    _cerrar.layer.cornerRadius = 5.f;
}

-(void)viewWillAppear:(BOOL)animated
{
    UITapGestureRecognizer *tapper =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapper.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapper];
    tapper =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_html addGestureRecognizer:tapper];
}


-(void)viewTapped: (id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    if (gesture.view == self.view) {
        [_cerrar setHidden:(![_cerrar isHidden])];
        [_html setHidden:(![_html isHidden])];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
