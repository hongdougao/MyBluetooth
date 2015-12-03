//
//  ScanForViewController.m
//  MyBluetooth
//
//  Created by s on 14-3-4.
//  Copyright (c) 2014年 sunward. All rights reserved.
//

#import "CoreBluetooth/CoreBluetooth.h"
#import "ScanForViewController.h"

@interface ScanForViewController ()

@end

@implementation ScanForViewController

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
    return self.peripheralArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (self.peripheralArray.count > indexPath.row) {
        CBPeripheral *peripheral = [self.peripheralArray objectAtIndex:indexPath.row];
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
    CBPeripheral * peripheral = [self.peripheralArray objectAtIndex:indexPath.row];
    if (peripheral.state   == CBPeripheralStateConnecting) {
        [self.cbCentralMgr cancelPeripheralConnection:peripheral];
    }else{
        
        [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
    
}

#pragma mark -Handle event

-(IBAction) reScan:(id)Sender
{
    [self.cbCentralMgr stopScan];
    [self.tvLog setText:@""];
    [self.peripheralArray removeAllObjects];
    [self.PeripheralIdentifiers removeAllObjects];

    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];


}

@end
