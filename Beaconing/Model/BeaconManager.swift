//
//  BeaconManager.swift
//  Beaconing
//
//  Created by Samar Sunkaria on 12/26/18.
//  Copyright © 2018 samar. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import CoreBluetooth

protocol BeaconManagerDelegate: class {
    func didUpdateState(with manager: BeaconManager)
    func didFindBeacon(_ beacon: Beacon, with manager: BeaconManager)
    func didChangeScanningState(with manager: BeaconManager)
}

class BeaconManager: NSObject {
    // TODO: - get queue from an init
    let managerQueue = DispatchQueue(label: "com.beaconing.bluetooth.managerQueue")
    lazy var centralManager = CBCentralManager(delegate: self, queue: managerQueue)

    weak var delegate: BeaconManagerDelegate?

    var state: CBManagerState {
        return centralManager.state
    }

    var isScanning: Bool {
        return centralManager.isScanning
    }

    func startScan() {
        // TODO: - add a way to allow scanning without the allow duplicate key option
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        delegate?.didChangeScanningState(with: self)
    }

    func stopScan() {
        centralManager.stopScan()
        print(isScanning)
        delegate?.didChangeScanningState(with: self)
    }
}

extension BeaconManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didUpdateState(with: self)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let data = advertisementData[CBAdvertisementDataManufacturerDataKey] as? NSData {
            if let beacon = Beacon(withAdvertisementData: data, rssi: RSSI) {
                delegate?.didFindBeacon(beacon, with: self)
                print(beacon)
            }
        }
    }
}
