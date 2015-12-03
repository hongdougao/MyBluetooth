//
//  RetrieveKnownViewController.m
//  MyBluetooth
//
//  Created by s on 14-3-4.
//  Copyright (c) 2014年 sunward. All rights reserved.
//

#import "CoreBluetooth/CoreBluetooth.h"
#import "RetrieveKnownViewController.h"

@interface RetrieveKnownViewController ()
@property (strong,nonatomic) NSArray * retrievePeripherals;

@end

@implementation RetrieveKnownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftItemsSupplementBackButton = true;
    self.retrievePeripherals = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.retrievePeripherals.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (self.retrievePeripherals.count > indexPath.row) {
        CBPeripheral *peripheral = [self.retrievePeripherals objectAtIndex:indexPath.row];
        NSString *state;
        switch (peripheral.state) {
            case CBPeripheralStateConnected:
                state = @"Connected";
                break;
            case CBPeripheralStateConnecting:
                state = @"Connecting";
                break;
            case CBPeripheralStateDisconnected:
                state = @"Disconnect";
                break;
                
            default:
                break;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", peripheral.name,state];
        cell.detailTextLabel.text = [peripheral.identifier UUIDString];
        if (peripheral.state   == CBPeripheralStateConnecting) {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral * peripheral = [self.retrievePeripherals objectAtIndex:indexPath.row];
    if (peripheral.state   == CBPeripheralStateConnecting) {
        [self.cbCentralMgr cancelPeripheralConnection:peripheral];
    }else{
        
        [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
    
}

#pragma mark -Handle event

-(IBAction) Retrieve:(id)Sender
{
    [self.tvLog setText:@""];
    NSMutableArray * Identifiers = [NSMutableArray array];
    for (CBPeripheral * peripheral in self.peripheralArray) {
        [Identifiers addObject:peripheral.identifier];
    }

    [self addLog:@"[self.cbCentralMgr retrievePeripheralsWithIdentifiers:self.PeripheralIdentifiers]"];
    self.retrievePeripherals = [self.cbCentralMgr retrievePeripheralsWithIdentifiers:Identifiers];
    for (CBPeripheral* peripheral in self.retrievePeripherals) {
        [self addLog:[NSString stringWithFormat: @"%@ name:%@",peripheral,peripheral.name]];
    }
    [self.tableViewPeripheral reloadData];
}


@end









