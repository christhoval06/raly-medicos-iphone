//
//  InicioController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/13/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "InfoGeneralController.h"

@interface InfoGeneralController ()
@property NSMutableArray *promociones;
@end

@implementation InfoGeneralController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _key = [_medicosdb getkey];
    _promociones = [[NSMutableArray alloc] init];
    if([_medicosdb haveMedico]){
        if([_medicosdb havePromociones]) [self cargarPromocionesLocales];
        else [self LoadPromociones];
    }
}


-(NSDictionary *) promocionFromDictionary:(NSDictionary *) data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
    [data objectForKey:@"titulo"], @"titulo",
    [data objectForKey:@"precio"], @"precio",
    [data objectForKey:@"imagen"], @"imagen",
    [data objectForKey:@"url"], @"url",
    [data objectForKey:@"html"], @"html", nil];
}

-(void)cargarPromocionesLocales
{
    for(NSDictionary *data in [_medicosdb getPromociones]){
        [_promociones addObject:[[Promocion alloc] initWithPromocion:[self promocionFromDictionary:data]]];
    }
}

-(void)LoadPromociones
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    __block UIActivityIndicatorView *activityIndicator;
    if (!activityIndicator)
    {
        [_promocionesList addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        activityIndicator.center = _promocionesList.center;
        activityIndicator.color= [UIColor colorWithHexString:@"#03b5e5"];
        activityIndicator.transform = CGAffineTransformMakeScale(2.75, 2.75);
        [activityIndicator startAnimating];
    }
    dispatch_queue_t cargarPromociones = dispatch_queue_create("Promociones", NULL);
    dispatch_async(cargarPromociones, ^{
        NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/pacientem?fnt=promociones&skey=%@", _key]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(jsonSource){
                NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
                if ([[jsonObjects objectForKey:@"success"] boolValue] ) {
                    [self  guardarPromociones:[jsonObjects objectForKey:@"promociones"]];
                    [_promocionesList reloadData];
                
                } else
                [self alert:@"" msg:NSLocalizedString(@"ERROR_LOADING_PROMOTIONS", @"Error Cargando Promociones")];
            }else
                [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") message: NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        });
    });
}

-(void)guardarPromociones: (NSDictionary *)json
{
    NSDictionary *promocion;
    for(NSDictionary *data in json){
        promocion = [self promocionFromDictionary:data];
        [_promociones addObject:[[Promocion alloc] initWithPromocion: promocion]];
        [_medicosdb savePromocion:promocion];
    }
    [_promocionesList reloadData];
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return [_promociones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PromocionCell";
    
    PromocionCell *cell = (PromocionCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =  [[PromocionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Promocion *promo = [_promociones objectAtIndex:indexPath.row];
    
    cell.titulo.text = promo.titulo;
    cell.precio.text = promo.precio;
    cell.imagen.frame = CGRectMake(0,0,80,70);
    cell.imagen.userInteractionEnabled = YES;
    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = cell.imagen;
    [cell.imagen setImageWithURL:[NSURL URLWithString:promo.imagen] placeholderImage:[UIImage imageNamed:@"noimage.png"] options:SDWebImageProgressiveDownload
                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
         if (!activityIndicator)
         {
             [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
             activityIndicator.center = weakImageView.center;
             [activityIndicator startAnimating];
         }
     }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         if (image) {
             [activityIndicator removeFromSuperview];
             activityIndicator = nil;
         }
     }];
    
    cell.imagen.tag = indexPath.row;
    
    UITapGestureRecognizer *tapper =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImagenTapped:)];
    tapper.numberOfTapsRequired = 1;
    [cell.imagen addGestureRecognizer: tapper];
    
    return cell;
}

-(void)ImagenTapped: (id) sender
{
    [self performSegueWithIdentifier:@"PromocionInfo" sender:sender];
}

-(void)alert: (NSString *) titulo msg: (NSString *) msg
{
    [[[UIAlertView alloc] initWithTitle: titulo message: msg delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self performSegueWithIdentifier:@"PromocionDetails" sender: self];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PromocionInfo"]) {
        UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
        ImagenViewController *imagenView = [segue destinationViewController];
        imagenView.promocion = ((Promocion *)[_promociones  objectAtIndex:gesture.view.tag]);
    }
    else if ([[segue identifier] isEqualToString:@"PromocionDetails"]){
        PromocionDetalleViewController *informacion = [segue destinationViewController];
        informacion.promocion = [_promociones  objectAtIndex:[_promocionesList indexPathForSelectedRow].row];
    }
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
