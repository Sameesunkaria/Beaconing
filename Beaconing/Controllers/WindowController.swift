//
//  WindowController.swift
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

import Cocoa
import CoreBluetooth

class WindowController: NSWindowController {

    @IBOutlet var toggleScanButton: NSButton!
    @IBOutlet var bluetoothStateButton: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()

        (contentViewController as? BeaconsController)?.controllerDelegate = self

        let beaconManager = (contentViewController as? BeaconsController)!.beaconManager
        updateBluetoothStateButton(beaconManager.state)
        didChangeScanningState(beaconManager.isScanning)
    }

    @IBAction func startScanClicked(_ sender: NSButton) {
        let beaconManager = (contentViewController as? BeaconsController)!.beaconManager

        if beaconManager.isScanning {
            beaconManager.stopScan()
        } else {
            beaconManager.startScan()
        }
    }

    func updateBluetoothStateButton(_ state: CBManagerState) {
        switch state {
        case .poweredOn:
            bluetoothStateButton.title = Constant.String.BluetoothState.poweredOn
            bluetoothStateButton.image = Constant.Image.BluetoothState.available
        case .poweredOff:
            bluetoothStateButton.title = Constant.String.BluetoothState.poweredOff
            bluetoothStateButton.image = Constant.Image.BluetoothState.unavailable
        case .unsupported:
            bluetoothStateButton.title = Constant.String.BluetoothState.unsupported
            bluetoothStateButton.image = Constant.Image.BluetoothState.unavailable
        case .resetting:
            bluetoothStateButton.title = Constant.String.BluetoothState.resetting
            bluetoothStateButton.image = Constant.Image.BluetoothState.partiallyAvailable
        default:
            bluetoothStateButton.title = Constant.String.BluetoothState.unknown
            bluetoothStateButton.image = Constant.Image.BluetoothState.unavailable
        }
    }
}

extension WindowController: BeaconsControllerDelegate {
    func didChangeScanningState(_ scanning: Bool) {
        switch scanning {
        case true: toggleScanButton.title = Constant.String.ScanButton.stopScanning
        case false: toggleScanButton.title = Constant.String.ScanButton.startScanning
        }
    }

    func didChangeBluetoothState(_ state: CBManagerState) {
        updateBluetoothStateButton(state)
    }
}
