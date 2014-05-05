//
//  MainController.m
//  RalyMedicos
//
//  Created by Christoval  Barba on 04/28/14.
//  Copyright (c) 2014 Eem Systems. All rights reserved.
//

#import "MainController.h"
#import "Reachability.h"

@interface MainController ()
@property (nonatomic) Reachability *internetReachability;
@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _medicosdb = [[SQLiteManager alloc] createDB:@"medicodb.db"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _internetReachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    //_internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability connectionRequired];
	[_internetReachability startNotifier];
	[self updateInterfaceWithReachability: _internetReachability];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([_medicosdb haveMedico]){
        [self performSegueWithIdentifier:@"PacientesView" sender:self];
    }else
        [self performSegueWithIdentifier:@"LoginView" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    [self configureReachability: reachability];
}

- (void)configureReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            [_medicosdb setParametro:@"internet" withValue: @"NO"];
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            [self testConectionWithCon:@"wwan"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            [self testConectionWithCon:@"wifi"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    NSLog(@"%@", statusString);
}

-(void)testConectionWithCon: (NSString *) con
{
    dispatch_queue_t CON = dispatch_queue_create("Conection", NULL);
    dispatch_async(CON, ^{
        NSData *jsonSource = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://laboratorioraly.com/raly/hacerloginmed"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(jsonSource){
                [_medicosdb setParametro:con withValue: @"YES"];
                [_medicosdb setParametro:@"internet" withValue: @"YES"];
            }else{
                [_medicosdb setParametro:@"internet" withValue: @"NO"];
            }
        });
    });
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginView"]){
        LoginController *login = [segue destinationViewController];
        login.medicodb = _medicosdb;
    }
    else if ([[segue identifier] isEqualToString:@"PacientesView"]){
        PacientesController *pacientes = [segue destinationViewController];
        pacientes.medicosdb = _medicosdb;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
