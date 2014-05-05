//
//  ResultadosPacentesViewController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "ResultadosPacentesViewController.h"

@interface ResultadosPacentesViewController ()
@property NSMutableArray *resultados;
@property NSMutableArray *secciones;
@property Resultado *rResultado;
@property ResultadoCell *celdaSelecionada;
@end

@implementation ResultadosPacentesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _resultados = [[NSMutableArray alloc] init];
    _secciones = [[NSMutableArray alloc] init];
    
    _titulo.text = _paciente.nombre;
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backPressed:)];
    swiper.direction = UISwipeGestureRecognizerDirectionRight;  
    [self.view addGestureRecognizer:swiper];
    
    if([_medicosdb haveMedico]){
        if ([_medicosdb haveResultadosForPaciente:_paciente.pacienteid])[self cargarResultadosFromDB];
        else [self cargarResultadosFromWeb];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cargarResultadosFromDB
{
    for(NSDictionary *data in [_medicosdb getResultadosOfPaciente:_paciente.pacienteid])
        [ _resultados addObject:[[Resultado alloc] initWithResultado:[self renderResultadoInDictionary:data]]];
    [self.tableView reloadData];
}

-(void)cargarResultadosFromWeb
{
    if([[_medicosdb getParametro:@"internet" withDefault:@"NO"] boolValue]){
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        __block UIActivityIndicatorView *activityIndicator;
        if (!activityIndicator)
        {
            [self.view addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            activityIndicator.center = self.view.center;
            activityIndicator.color= [UIColor colorWithHexString:@"#03b5e5"];
            activityIndicator.transform = CGAffineTransformMakeScale(2.75, 2.75);
            [activityIndicator startAnimating];
        }
        dispatch_queue_t cargarResultados = dispatch_queue_create("Resultados", NULL);
        dispatch_async(cargarResultados, ^{
            NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/medicom?fnt=resultados&pacienteid=%@&skey=%@", _paciente.pacienteid,_key]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(jsonSource){
                    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
                    if ([[jsonObjects objectForKey:@"success"] boolValue] )
                        [self  guardarResultados:[jsonObjects objectForKey:@"resultados"] saveData:YES];
                    else
                        [[[UIAlertView alloc] initWithTitle: @"" message: NSLocalizedString(@"ERROR_LOADING_RESULTS", @"Error cargando resultados") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
                }else
                    [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") message: NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            });
        });
    }else
        [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") message: NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
}

-(NSDictionary *)renderResultadoInDictionary: (NSDictionary *) data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _paciente.pacienteid, @"pacienteid",
            [data objectForKey:@"resultadoid"], @"resultadoid",
            [data objectForKey:@"titulo"], @"titulo",
            [data objectForKey:@"fecha"], @"fecha",
            [data objectForKey:@"pdf"], @"pdf",
            [data objectForKey:@"estado"], @"estado",nil];
}


-(void)guardarResultados:(NSDictionary *) json saveData:(BOOL) saveData
{
    NSDictionary *resultadoRender;
    for(NSDictionary *data in json){
        resultadoRender = [self renderResultadoInDictionary:data];
        
        [ _resultados addObject:[[Resultado alloc] initWithResultado:resultadoRender]];
        if (saveData) [_medicosdb saveResultado:resultadoRender];
    }
    [self.tableView reloadData];
}

-(void)cargarResultadosLocales
{
    for(NSDictionary *data in [_medicosdb getPacientes])
        [ _resultados addObject:[[Resultado alloc] initWithResultado:[self renderResultadoInDictionary:data]]];
    [self.tableView reloadData];
}


-(NSMutableArray *)sorterResultados
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    return [NSMutableArray arrayWithArray:[_resultados sortedArrayUsingDescriptors:@[sortDescriptor]]];
}


-(NSString *)seccionFromDateInSections: (NSUInteger)section
{
    return [_secciones objectAtIndex:section];
}

#pragma mark tableView dataSource Delegate methods
-(void)sacarSeccionesWithTableView: (UITableView *)tableView
{
    [_secciones removeAllObjects];
    for(_rResultado in [self sorterResultados]){
        if(![_secciones containsObject:_rResultado.sfecha])
            [_secciones addObject:_rResultado.sfecha];
    }
}
-(Resultado *)tableView: (UITableView *)tableView getResultadoWithIndexPath: (NSIndexPath *)indexPath
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.sfecha contains[c] %@", [self seccionFromDateInSections:indexPath.section]];
    return  [[NSMutableArray arrayWithArray: [_resultados filteredArrayUsingPredicate:predicado]] objectAtIndex:indexPath.row];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#70D4F0"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - 100, 3, 95, 18)];
    headerLabel.text = [self seccionFromDateInSections:section];
    headerLabel.textColor= [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    [self sacarSeccionesWithTableView:tableView];
    return [_secciones count];
}
-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.sfecha contains[c] %@", [self seccionFromDateInSections:section]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray: [_resultados filteredArrayUsingPredicate:predicado]];
    return [ arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _celdaSelecionada = (ResultadoCell *)[tableView dequeueReusableCellWithIdentifier:@"resultadoCell"];
    if(_celdaSelecionada == nil){
        _celdaSelecionada =  [[ResultadoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultadoCell"];
    }
    _rResultado = [self tableView:tableView getResultadoWithIndexPath:indexPath];
    _celdaSelecionada.resultado = _rResultado;
    _celdaSelecionada.titulo.text = _rResultado.titulo;
    if ([_medicosdb haveFileFromPaciente:_rResultado.pacienteid andResultadoId:_rResultado.resultadoid]){
        _celdaSelecionada.descargado.hidden = NO;
    }
    else
        _celdaSelecionada.descargado.hidden = YES;
    return _celdaSelecionada;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    _celdaSelecionada= (ResultadoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [self showOpcionesForCell:_celdaSelecionada];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)showOpcionesForCell: (ResultadoCell *)cell
{
    _rResultado = _celdaSelecionada.resultado;
    if (_rResultado.estado) {
        BOOL overide = (BOOL)[[NSUserDefaults standardUserDefaults] valueForKey:@"guardar"];
        NSString *guardar = overide ? NSLocalizedString(@"ACTION_SAVE", @"Ver Antecedentes") : nil;
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL", @"Cancelar") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ACTION_DOWNLOAD", @"Ver Resultado"),NSLocalizedString(@"ACTION_ANTECEDENTES", @"Ver Antecedentes"),guardar, nil];
        [action showInView:self.view];
    }else{
        [[[UIAlertView alloc] initWithTitle: nil message: NSLocalizedString(@"RESULTADO_ESTADO", @"Este resultado no esta listo.") delegate:nil cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            _rResultado = _celdaSelecionada.resultado;
            if ([_medicosdb haveFileFromPaciente:_rResultado.pacienteid andResultadoId:_rResultado.resultadoid])
                [self openPDFFileWhitResultado: _rResultado];
            else
                [self downloadFileWithResultadoInCell: _celdaSelecionada andAntecidentes:nil andSoloDescargar: NO];
            break;
        case 1:
            [self downloadFileWithResultadoInCell: _celdaSelecionada andAntecidentes:@"&bloque=2" andSoloDescargar: NO];
            break;
        case 2:
            [self downloadFileWithResultadoInCell: _celdaSelecionada andAntecidentes:nil andSoloDescargar: YES];
            break;
        default: break;
    }
}


/* DOWNLOAD FILES */
-(void)downloadFileWithResultadoInCell: (ResultadoCell *) cell andAntecidentes:(NSString *) antecedentes andSoloDescargar: (BOOL) soloDescargar
{
    _rResultado = cell.resultado;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [cell.descargando startAnimating];
    dispatch_queue_t descargarPDF = dispatch_queue_create("descargarPDF", NULL);
    dispatch_async(descargarPDF, ^{
        NSString *pdfUrl = [_rResultado getPDFwithKey:self.key];
        pdfUrl = antecedentes != nil ? [ pdfUrl stringByAppendingString:antecedentes] : pdfUrl;
        NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pdfUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(pdfData){
                NSString *pdfFilePath =  [self getPdfURLWhitResultado: _rResultado andAntecidentes: antecedentes!= nil ? YES : NO];
                if ([pdfData writeToFile:pdfFilePath atomically:YES]){
                    if ((soloDescargar || (BOOL)[[NSUserDefaults standardUserDefaults] valueForKey:@"guardar"]) && antecedentes == nil){
                        if ([_rResultado.titulo rangeOfString:@"---"].location == NSNotFound) {
                            [_medicosdb saveResultadoFile:[NSDictionary dictionaryWithObjectsAndKeys: _rResultado.pacienteid, @"pacienteid",
                                                           _paciente.nombre, @"paciente",
                                                           _rResultado.resultadoid, @"resultadoid",
                                                           _rResultado.titulo, @"resultado",
                                                           _rResultado.sfecha, @"fecha",
                                                           pdfFilePath, @"file",nil]];
                            cell.descargado.hidden = NO;
                        }
                    }
                    if (!soloDescargar) [self openPDFFileWhitResultado: _rResultado];
                }else{
                    
                }
                
            }else
                [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"CONNECTION_ERROR", @"Error de Conección") message: NSLocalizedString(@"CONNECTION_ERROR_MSG", @"no hay acceso a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
            [cell.descargando stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        });
    });
}

-(NSString *)getPdfURLWhitResultado: (Resultado *) resultado andAntecidentes:(BOOL) antecedentes
{
    BOOL override = (BOOL)[[NSUserDefaults standardUserDefaults] valueForKey:@"guardar"];
    if ([_rResultado.titulo rangeOfString:@"---"].location != NSNotFound) override = NO;
    NSString *fileName =  override ? [NSString stringWithFormat:@"%@_%@.pdf", resultado.pacienteid,resultado.resultadoid]: @"resultado.pdf";
    NSString *dir =  override ? @"Documents": @"tmp";
    NSString *resPDFPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:dir]];
    return [resPDFPath stringByAppendingPathComponent: fileName];
}

-(void)openPDFFileWhitResultado: (Resultado *) resultado{
    PDFViewerController *pdfviewer = [self.storyboard instantiateViewControllerWithIdentifier:@"PDFViewer"];
    pdfviewer.ruta = [self getPdfURLWhitResultado:resultado andAntecidentes: NO];
    pdfviewer.titulo = resultado.titulo;
    [self presentViewController:pdfviewer animated:true completion:nil];
}

@end
