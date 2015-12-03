 [转]
//暂时没时间看 先留着 

现将创建蓝牙工程的要点总结一下，由于工程主要涉及中心模式，所以只总结中心模式的用法
1,引入CoreBluetooth.framework
2,实现蓝牙协议，如：
.h文件如下
@protocol CBCentralManagerDelegate;
@protocol CBPeripheralDelegate;

@interface ViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>

.m文件如下
#import "CoreBluetooth/CoreBluetooth.h"
另外还有代理部分请自行添加

3，下面是使蓝牙动起来的过程
3.1创建CBCentralManager实例
self.cbCentralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
设置代理，比如:
self.cbCentralMgr.delegate = self;

创建数组管理外设
self.peripheralArray = [NSMutableArray array];

3.2扫描周围的蓝牙
实际上周围的蓝牙如果可被发现，则会一直往外发送广告消息，中心设备就是通过接收这些消息来发现周围的蓝牙的
NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumbernumberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
[self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];

3.3发现一个蓝牙设备
也就是收到了一个周围的蓝牙发来的广告信息，这是CBCentralManager会通知代理来处理
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
}
如果周围的蓝牙有多个，则这个方法会被调用多次，你可以通过tableView或其他的控件把这些周围的蓝牙的信息打印出来
3.4连接一个蓝牙
[self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
一个中心设备可以同时连接多个周围的蓝牙设备
当连接上某个蓝牙之后，CBCentralManager会通知代理处理

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
}

因为在后面我们要从外设蓝牙那边再获取一些信息，并与之通讯，这些过程会有一些事件可能要处理，所以要给这个外设设置代理，比如：
peripheral.delegate = self;
3.5查询蓝牙服务
[peripheral discoverServices:nil];
返回的蓝牙服务通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

for (CBService* service in peripheral.services){

}
}
3.6查询服务所带的特征值
[peripheral discoverCharacteristics:nil forService:service];
返回的蓝牙特征值通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError *)error
{

for (CBCharacteristic * characteristic in service.characteristics) {
}
}
3.7给蓝牙发数据
[peripheral writeValue:data forCharacteristic:characteristictype:CBCharacteristicWriteWithResponse];
这时还会触发一个代理事件
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError *)error
{
}
3.8处理蓝牙发过来的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError *)error
{
}

3.9 retrievePeripheralsWithIdentifiers 使用例子
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

3.10 retrieveConnectedPeripheralsWithServices 使用例子

-(IBAction) Retrieve:(id)Sender
{
[self.tvLog setText:@""];
NSMutableArray * services = [NSMutableArray array];
for (CBPeripheral * peripheral in self.peripheralArray) {
if (peripheral.isConnected) {
for (CBService *service in peripheral.services) {
[services addObject:service.UUID];
}
}
}

[self addLog:@"[self.cbCentralMgr retrieveConnectedPeripheralsWithServices:peripheral.services]"];
self.retrievePeripherals = [self.cbCentralMgrretrieveConnectedPeripheralsWithServices:services];
for (CBPeripheral* peripheral in self.retrievePeripherals) {
[self addLog:[NSString stringWithFormat: @"%@ name:%@",peripheral,peripheral.name]];
}
[self.tableViewPeripheral reloadData];
}


