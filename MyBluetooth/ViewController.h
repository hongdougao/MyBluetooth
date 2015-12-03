//
//  ViewController.h
//  MyBluetooth
//
//  Created by s on 14-2-11.
//  Copyright (c) 2014年 sunward. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBCentralManagerDelegate;
@protocol CBPeripheralDelegate;
@class CBCentralManager;

@interface ViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic)IBOutlet UITableView * tableViewPeripheral;
@property (strong,nonatomic)IBOutlet UITextView * tvLog;
@property (strong,nonatomic)IBOutlet UIBarButtonItem * centerMgrState;

@property (strong,nonatomic) CBCentralManager * cbCentralMgr;
@property (strong,nonatomic) NSMutableArray *peripheralArray;
@property (strong,nonatomic) NSMutableArray *PeripheralIdentifiers;


-(void)addLog:(NSString*)log;
-(void)addLogWithService:(CBService*)service;
-(void)addLogWithCharacteristic:(CBCharacteristic*)characteristic;

@end
