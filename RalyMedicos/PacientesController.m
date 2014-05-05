//
//  PacientesController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 03/12/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "PacientesController.h"

@interface PacientesController ()
@property NSMutableArray *localPacientes;
@property NSMutableArray *serverPacientes;
@property NSMutableArray *filteredPacientes;
@property NSMutableArray *pacientes;
@property NSMutableArray *secciones;
@property ModalAnimation *modalAnimationController;
@property Paciente *rPaciente;
@property BOOL filtrado;
@property NSString *searchScope;
@property NSString *localstr;
@property NSString *buscarstr;
@end

@implementation PacientesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self iniciar];
}

-(void)iniciar
{
    _modalAnimationController = [[ModalAnimation alloc] init];
    _key = [_medicosdb getkey];
    _localPacientes = [[NSMutableArray alloc] init];
    _serverPacientes = [[NSMutableArray alloc] init];
    _secciones = [[NSMutableArray alloc] init];
    _pacientes = _localPacientes;
    _filtrado = NO;
    _localstr = NSLocalizedString(@"LOCAL_SRT", @"Local");
    _buscarstr = NSLocalizedString(@"BUSCAR_STR", @"Buscar");
    _searchScope = _localstr;
    if ([_medicosdb havePacientes])[self loadPacinentesFromDB];
    else [self pacientesFromWebWithCallback:^(NSDictionary *d){
        [_medicosdb deletePacientes];
        [self  guardarPacientes:d saveData:YES filtro:@""];
    } andURL:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/medicom?fnt=listamispacientes&skey=%@", _key]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSDictionary *)renderPacienteInDictionary: (NSDictionary *) data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
     [data objectForKey:@"pacienteid"], @"pacienteid",
     [data objectForKey:@"nombre"], @"nombre",
     [data objectForKey:@"cedula"], @"cedula",
     [data objectForKey:@"codigo"], @"codigo",
     [data objectForKey:@"foto"], @"foto",
     [data objectForKey:@"telefono"], @"telefono",nil];
}


-(void)loadPacinentesFromDB
{
    for(NSDictionary *data in [_medicosdb getPacientes])
        [ _pacientes addObject:[[Paciente alloc] initWithPaciente:[self renderPacienteInDictionary:data]]];
    _filteredPacientes = [[NSMutableArray alloc] initWithCapacity: [_pacientes count]];
    [self.tableView reloadData];
}

-(void)pacientesFromWebWithCallback:(void(^)(NSDictionary *))callback andURL:(NSString *)url
{
    if ([[_medicosdb getParametro:@"internet" withDefault:@"NO"] boolValue]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        __block UIActivityIndicatorView *activityIndicator;
        if (!activityIndicator)
        {
            [self.tableView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            activityIndicator.center = self.tableView.center;
            activityIndicator.color= [UIColor colorWithHexString:@"#03b5e5"];
            activityIndicator.transform = CGAffineTransformMakeScale(2.75, 2.75);
            [activityIndicator startAnimating];
        }
        dispatch_queue_t cargarPacientes = dispatch_queue_create("Pacientes", NULL);
        dispatch_async(cargarPacientes, ^{
            NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(jsonSource){
                    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
                    if ([[jsonObjects objectForKey:@"success"] boolValue] )
                        callback([jsonObjects objectForKey:@"pacientes"]);
                    else
                        [[[UIAlertView alloc] initWithTitle: @"" message: NSLocalizedString(@"ERROR_LOADING_PATIENTS", @"Error Cragando Pacientes") delegate:self cancelButtonTitle:NSLocalizedString(@"BTN_OK", @"Aceptar") otherButtonTitles:nil, nil] show];
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

-(void)BuscarPacientes:(NSString *)q
{
    [self pacientesFromWebWithCallback:^(NSDictionary *d){
        [_serverPacientes removeAllObjects];
        [self  guardarPacientes:d saveData:NO filtro: q];
    } andURL:[NSString stringWithFormat:@"http://laboratorioraly.com/raly/medicom?fnt=buscarpaciente&skey=%@&buscar=%@", _key, q]];
}

-(BOOL)isEmpty:(NSString *) s
{
    if ((NSNull *)s == [NSNull null] || (s == nil)) return  YES;
    if ([[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) return YES;
    return NO;
}

-(void)guardarPacientes: (NSDictionary *)json saveData:(BOOL) saveData filtro:(NSString *)filtro
{
    NSDictionary *pacienteRender;
    for(NSDictionary *data in json){
        pacienteRender = [self renderPacienteInDictionary:data];
        
        [ (saveData?_localPacientes:_serverPacientes) addObject:[[Paciente alloc] initWithPaciente:pacienteRender]];
        if (saveData) [_medicosdb savePaciente:pacienteRender];
    }
    _filteredPacientes = [[NSMutableArray alloc] initWithCapacity: [(saveData?_localPacientes:_serverPacientes) count]];
    if (![self isEmpty:filtro]){
        [self.searchDisplayController setActive:NO animated:YES];
    }
    [self.tableView reloadData];
}

-(void)pacienteImageTapped: (id) sender
{
    [self performSegueWithIdentifier:@"PacienteInfo" sender:sender];
}


-(Paciente *)getPacienteWithIndexPath: (NSIndexPath *)indexPath
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.nombre beginswith[c] %@", [_secciones objectAtIndex:indexPath.section]];
    return  [[NSMutableArray arrayWithArray: [[self selectDataPacienteWithTableView: self.tableView] filteredArrayUsingPredicate:predicado]] objectAtIndex:indexPath.row];
}


#pragma mark - Table view data source
-(NSMutableArray *)selectDataPacienteWithTableView: (UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) return _filteredPacientes;
    return _pacientes;
}

-(void)sacarSeccionesWithTableView: (UITableView *)tableView
{
    [_secciones removeAllObjects];
    for(_rPaciente in [self selectDataPacienteWithTableView: tableView]){
        if(![_secciones containsObject:[_rPaciente.nombre substringToIndex:1]])
            [_secciones addObject:[_rPaciente.nombre substringWithRange: NSMakeRange(0, 1)]];
    }
}

-(Paciente *)tableView: (UITableView *)tableView getPacienteWithIndexPath: (NSIndexPath *)indexPath
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.nombre beginswith[c] %@", [_secciones objectAtIndex:indexPath.section]];
    return  [[NSMutableArray arrayWithArray: [[self selectDataPacienteWithTableView: tableView] filteredArrayUsingPredicate:predicado]] objectAtIndex:indexPath.row];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _secciones;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#22BEE8"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - 30, 3, 20, 18)];
    headerLabel.text = [_secciones objectAtIndex:section];
    headerLabel.textColor= [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    [self sacarSeccionesWithTableView:tableView];
    return [_secciones count];
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"SELF.nombre beginswith[c] %@", [_secciones objectAtIndex:section]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray: [[self selectDataPacienteWithTableView: tableView] filteredArrayUsingPredicate:predicado]];
    return [ arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PacienteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pacienteCell"];
    if(cell == nil){
        cell =  [[PacienteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pacienteCell"];
    }else [cell cellStyleImage];
    _rPaciente= [self tableView: tableView getPacienteWithIndexPath:indexPath];

    UIColor *color;
    if(indexPath.row%2 ==0) color = [UIColor colorWithHexString:@"cff1fa"];
    else color  = [UIColor colorWithHexString:@"b0e7f6"];
    
    cell.nombre.text = [_rPaciente nombre];
    cell.cedula.text = [_rPaciente cedula];
    cell.codigo.text = [_rPaciente codigo];
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = cell.imagen;
    [cell.imagen setImageWithURL:[NSURL URLWithString:[_rPaciente getFotoWithKey:_key]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageProgressiveDownload
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         if (!activityIndicator)
         {
             [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
             activityIndicator.center = weakImageView.center;
             activityIndicator.color = [UIColor whiteColor];
             [activityIndicator startAnimating];
         }
     }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         if (image) {
             [activityIndicator removeFromSuperview];
             activityIndicator = nil;
         }
         else weakImageView.backgroundColor = color;
     }];
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;
    cell.imagen.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapper =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pacienteImageTapped:)];
    tapper.numberOfTapsRequired = 1;
    [cell.imagen addGestureRecognizer: tapper];
    cell.imagen.restorationIdentifier = [NSString stringWithFormat:@"%ld,%ld", (long)indexPath.section, (long)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultadosView"]) {
        ResultadosPacentesViewController * resultado = segue.destinationViewController;
        resultado.medicosdb = _medicosdb;
        resultado.key = _key;
        resultado.paciente = [self tableView: self.tableView getPacienteWithIndexPath:[self.tableView indexPathForSelectedRow]];
    }
    else if ([[segue identifier] isEqualToString:@"PacienteInfo"]) {
        UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
        PacienteContactController *_pacienteContact = [segue destinationViewController];
        NSArray *nsIndex = [gesture.view.restorationIdentifier componentsSeparatedByString:@","];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[ nsIndex objectAtIndex:1] integerValue] inSection:[[nsIndex objectAtIndex:0] intValue]];
        _rPaciente = [self getPacienteWithIndexPath: indexPath];
        
        _pacienteContact.transitioningDelegate = self;
        _pacienteContact.modalPresentationStyle = UIModalPresentationCustom;
        _pacienteContact.pacienteContactSelecionado = _rPaciente;
        _pacienteContact.key = _key;
    }
    else if ([[segue identifier] isEqualToString:@"MisResultadosView"]) {
        MisResultadosViewController *resultados = [segue destinationViewController];
        resultados.medicosdb = _medicosdb;
    }
    else if ([[segue identifier] isEqualToString:@"InfoGralView"]) {
        InfoGeneralController *inicio = [segue destinationViewController];
        inicio.medicosdb = _medicosdb;
    }
}


-(void)filterContentForSearchText:(NSString *)searchText
{
    [_filteredPacientes removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.nombre contains[cd] %@", searchText];
    _filteredPacientes = [NSMutableArray arrayWithArray:[_pacientes filteredArrayUsingPredicate:predicate]];
    _filtrado = [_filteredPacientes count]>0;
}


-(BOOL)searchDisplayController: (UISearchDisplayController *) controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _filtrado = [searchString length]>0;
    if ([_searchScope caseInsensitiveCompare :_localstr]==0) {
        [self filterContentForSearchText: searchString];
        return  YES;
    }
    if ([_serverPacientes count]>0) {
        [self filterContentForSearchText:searchString];
        return  YES;
    }
    return  NO;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self.tableView reloadData];
    return NO;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    _searchScope = [[ self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    if ([_searchScope caseInsensitiveCompare :_buscarstr]==0) {
        self.searchDisplayController.searchBar.placeholder =NSLocalizedString(@"SEARCH_PATIENTS", @"buscar paciente");
        _pacientes = _serverPacientes;
    }
    if ([_searchScope caseInsensitiveCompare :_localstr]==0) {
        self.searchDisplayController.searchBar.placeholder =NSLocalizedString(@"SEARCH_PATIENTS",@"filtrar mis pacientes");
        _pacientes = _localPacientes;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([_searchScope caseInsensitiveCompare :_buscarstr]==0) {
        [self BuscarPacientes:searchBar.text];
    }
    if ([_searchScope caseInsensitiveCompare :_localstr]==0) {
            [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:1];
            _pacientes = _serverPacientes;
            [self BuscarPacientes:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;
{
    [self.tableView reloadData];
}


#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}


#pragma eventos de botones
- (IBAction)showSearchBar:(id)sender {
    [self.searchDisplayController setActive:YES animated:YES];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (IBAction)showMenu:(id)sender {
    [self showOptionMenu];
}


#pragma mark - RNGridMenuDelegate
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    switch (itemIndex) {
        case 0: [self performSegueWithIdentifier:@"InfoGralView" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"MisResultadosView" sender:self];
            break;
        case 2:
            [_medicosdb clearCache];
            exit(0);
            break;
        case 3:
            [_medicosdb deleteMedico];
            [_medicosdb clearCache];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
    }
}

#pragma mark - Private

-(void)showOptionMenu
{
    NSInteger numberOfOptions = 4;
    NSArray *options = @[
                         NSLocalizedString(@"INFO_GRAL", @"Info General"),
                         NSLocalizedString(@"MIS_RESULTADOS", @"Mis Resultados"),
                         NSLocalizedString(@"SALIR", @"Salir"),
                         NSLocalizedString(@"CERRAR_SESION", @"Cerrar Sesión")
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}


@end
