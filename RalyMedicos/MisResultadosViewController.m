//
//  MisResultadosViewController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/24/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "MisResultadosViewController.h"

@interface MisResultadosViewController ()
@property NSMutableArray *resultados;
@property NSMutableArray *secciones;
@property MiResultado *selectedResultado;
@property MiResultadoCell *selectedCell;
@end

@implementation MisResultadosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([_medicosdb haveMedico]){
        _resultados = [[NSMutableArray alloc] init];
        _secciones = [[NSMutableArray alloc] init];
        if ([_medicosdb haveResultadosFiles])[self loadResultadosFromDB];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* mis resultados data table */
-(NSDictionary *)renderFileInDictionary: (NSDictionary *) data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [data objectForKey:@"pacienteid"], @"pacienteid",
            [data objectForKey:@"paciente"], @"paciente",
            [data objectForKey:@"resultadoid"], @"resultadoid",
            [data objectForKey:@"resultado"], @"resultado",
            [data objectForKey:@"fecha"], @"fecha",
            [data objectForKey:@"file"], @"file",nil];
}
-(void)loadResultadosFromDB
{
    for(NSDictionary *data in [_medicosdb getResultadosFacientes])
        [ _resultados addObject:[[MiResultado alloc] initWithFile:[self renderFileInDictionary:data] andDB:_medicosdb]];
    [_tableView reloadData];
}

-(void)sacarSeccionesWithTableView: (UITableView *)tableView
{
    [_secciones removeAllObjects];
    for(MiResultado *r in _resultados){
        if(![_secciones containsObject:r.paciente])
            [_secciones addObject:r.paciente];
    }
}

-(MiResultado *)getResultadoWithIndexPath: (NSIndexPath *)indexPath
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.paciente contains[cd] %@", [_secciones objectAtIndex:indexPath.section]];
    return  [[NSMutableArray arrayWithArray: [_resultados filteredArrayUsingPredicate:predicado]] objectAtIndex:indexPath.row];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    [self sacarSeccionesWithTableView:tableView];
    return [_secciones count];
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.paciente contains[cd] %@", [_secciones objectAtIndex:section]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray: [_resultados filteredArrayUsingPredicate:predicado]];
    return [ arr count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#22BEE8"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, tableView.bounds.size.width - 5, 18)];
    headerLabel.text = [_secciones objectAtIndex:section];
    headerLabel.textColor= [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.adjustsFontSizeToFitWidth=YES;
    headerLabel.minimumScaleFactor =.6f;
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCell = [tableView dequeueReusableCellWithIdentifier:@"MiResultadoCell"];
    if(_selectedCell == nil){
        _selectedCell =  [[MiResultadoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MiResultadoCell"];
    }
    MiResultado *r  = [self getResultadoWithIndexPath:indexPath];
    _selectedCell.resultado =r;
    _selectedCell.titulo.text =[self isEmpty:r.resultado] ? @"" : r.resultado;
    _selectedCell.fecha.text =[self isEmpty:r.fecha] ? @"" : r.fecha;
    return _selectedCell;
}

-(BOOL)isEmpty:(NSString *) s
{
    if ((NSNull *)s == [NSNull null] || (s == nil)) return  YES;
    if ([[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) return YES;
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCell = (MiResultadoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [[[UIAlertView alloc] initWithTitle: @"" message: [NSString stringWithFormat: NSLocalizedString(@"DELETE_FILE_MSG", @"Desea borrar el resultado %@ de %@"), _selectedCell.resultado.resultado, _selectedCell.resultado.paciente] delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL", @"Cancelar") otherButtonTitles:NSLocalizedString(@"BTN_OK", @"Aceptar"), nil] show];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   _selectedResultado = [self getResultadoWithIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self performSegueWithIdentifier:@"pdfView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pdfView"]) {
        PDFViewerController *pdf = [segue destinationViewController];
        pdf.ruta =_selectedResultado.file;
        pdf.titulo = _selectedResultado.resultado;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: break;
        case 1:
            if ([_selectedCell.resultado borrarFile]){
                [_medicosdb deleteFileFromPaciente: _selectedCell.resultado.pacienteid andResultadoId: _selectedCell.resultado.resultadoid];
                [_resultados removeObject:_selectedCell.resultado];
                [_tableView reloadData];
            }
            break;
    }
}
@end
