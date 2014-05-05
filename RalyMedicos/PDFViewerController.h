//
//  PDFViewerController.h
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/21/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewerController : UIViewController
@property NSString *titulo;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UILabel *lbltitulo;
@property NSString *ruta;
@end
