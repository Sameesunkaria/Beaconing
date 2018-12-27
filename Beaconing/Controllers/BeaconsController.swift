//
//  BeaconsController.swift
//  Beaconing
//
//  Created by Samar Sunkaria on 12/24/18.
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

protocol BeaconsControllerDelegate: class {
    func didChangeScanningState(_ scanning: Bool)
    func didChangeBluetoothState(_ state: CBManagerState)
}

class BeaconsController: NSViewController {

    @IBOutlet var tableView: NSTableView!

    var beaconManager = BeaconManager()
    var beacons = [String : Beacon]()
    var timer: Timer?

    weak var controllerDelegate: BeaconsControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        beaconManager.delegate = self
    }

    func prepareForScan() {
        beacons.removeAll()
        tableView.reloadData()
        startTimerForRemovingStaleDevices()
    }

    func startTimerForRemovingStaleDevices() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.removeBeaconsThatAreNoLongerVisible()
        }
    }

    var selectedBeacon: Beacon? {
        var selectedBeacon: Beacon?

        if tableView.selectedRow != -1 {
            selectedBeacon = Array(beacons.values)[tableView.selectedRow]
        }

        return selectedBeacon
    }

    func removeBeaconsThatAreNoLongerVisible() {
        let staleDuration: TimeInterval = 15

        let selectedBeacon = self.selectedBeacon
        beacons = beacons.filter { Date().timeIntervalSince($0.value.updated) < staleDuration }
        reloadBeacons(with: selectedBeacon)
    }

    func updateBeacon(_ beacon: Beacon) {
        let selectedBeacon = self.selectedBeacon
        beacons[beacon.proximityUUID.uuidString] = beacon
        reloadBeacons(with: selectedBeacon)
    }

    func reloadBeacons(with selectedBeacon: Beacon?) {
        tableView.reloadData()

        guard let selectedBeacon = selectedBeacon else { return }
        if let selectedIndex = Array(beacons.keys).firstIndex(of: selectedBeacon.proximityUUID.uuidString) {
            tableView.selectRowIndexes(IndexSet([selectedIndex]), byExtendingSelection: false)
        }
    }

}

extension BeaconsController: BeaconManagerDelegate {
    func didChangeScanningState(with manager: BeaconManager) {
        DispatchQueue.main.async {
            self.controllerDelegate?.didChangeScanningState(manager.isScanning)

            switch manager.isScanning {
            case false: self.timer?.invalidate()
            case true: self.prepareForScan()
            }
        }
    }

    func didUpdateState(with manager: BeaconManager) {
        DispatchQueue.main.async {
            self.controllerDelegate?.didChangeBluetoothState(manager.state)
        }

        switch manager.state {
        case .poweredOn: break
        default: manager.stopScan()
        }
    }

    func didFindBeacon(_ beacon: Beacon, with manager: BeaconManager) {
        DispatchQueue.main.async {
            self.updateBeacon(beacon)
        }
    }
}

extension BeaconsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return beacons.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard
            let identifier = tableColumn?.identifier.rawValue,
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView
        else {
            return nil
        }

        let values = Array(beacons.values)

        switch identifier {
        case Constant.TableViewIdentifier.proximity:
            cell.textField?.stringValue = String(values[row].proximityUUID.uuidString)
        case Constant.TableViewIdentifier.major:
            cell.textField?.stringValue = String(values[row].major)
        case Constant.TableViewIdentifier.minor:
            cell.textField?.stringValue = String(values[row].minor)
        case Constant.TableViewIdentifier.rssi:
            cell.textField?.stringValue = String(values[row].rssi)
        case Constant.TableViewIdentifier.lastDetected:
            cell.textField?.stringValue = DateFormatter.localizedString(from: values[row].updated, dateStyle: .short, timeStyle: .medium)
        default:
            return nil
        }

        return cell
    }
}

extension BeaconsController: NSTableViewDelegate {

}
