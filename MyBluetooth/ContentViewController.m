//
//  ContentViewController.m
//  MyBluetooth
//
//  Created by s on 14-3-3.
//  Copyright (c) 2014年 sunward. All rights reserved.
//

#import "ContentViewController.h"

#import "CoreBluetooth/CoreBluetooth.h"

NSString * cScanFor = @"ScanFor";
NSString * cRetrieveConnectedPeripherals = @"RetrieveConnectedPeripherals";
NSString * cRetrieveKnownPeripherals = @"RetrieveKnownPeripherals";

@interface ContentViewController ()

@property (strong,nonatomic) NSMutableArray *Contents;
@property (strong,nonatomic) CBCentralManager * cbCentralMgr;
@property (strong,nonatomic) NSMutableArray *peripheralArray;
@property (strong,nonatomic) NSMutableArray *PeripheralIdentifiers;
@end

@implementation ContentViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.Contents = [NSMutableArray array];
    [self.Contents addObject:cScanFor];
    [self.Contents addObject:cRetrieveKnownPeripherals];
    [self.Contents addObject:cRetrieveConnectedPeripherals];
    
    
    self.cbCentralMgr = [[CBCentralManager alloc] initWithDelegate:nil queue:nil];
    self.peripheralArray = [NSMutableArray array];
    self.PeripheralIdentifiers = [NSMutableArray array];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Talbe view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * item = self.Contents[indexPath.row];
    if ([item isEqualToString:cScanFor]) {
        
        [self performSegueWithIdentifier:cScanFor sender:tableView];
    }else if ([item isEqualToString:cRetrieveKnownPeripherals]){
        [self performSegueWithIdentifier:cRetrieveKnownPeripherals sender:tableView];
    }else if ([item isEqualToString:cRetrieveConnectedPeripherals]){
        [self performSegueWithIdentifier:cRetrieveConnectedPeripherals sender:tableView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.Contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.Contents objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [[segue destinationViewController] setCbCentralMgr:self.cbCentralMgr];
    self.cbCentralMgr.delegate = [segue destinationViewController];
    [[segue destinationViewController] setPeripheralArray:self.peripheralArray];
    [[segue destinationViewController] setPeripheralIdentifiers:self.PeripheralIdentifiers];
    
}



@end
