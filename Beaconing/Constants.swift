//
//  Constants.swift
//  Beaconing
//
//  Created by Samar Sunkaria on 12/27/18.
//  Copyright © 2018 samar. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Cocoa

struct Constant {
    struct TableViewIdentifier {
        static let proximity = "proximityUUID"
        static let major = "major"
        static let minor = "minor"
        static let rssi = "RSSI"
        static let lastDetected = "lastDetected"
    }

    struct String {
        struct ScanButton {
            static let startScanning = "Start Scanning"
            static let stopScanning = "Stop Scanning"
        }

        struct BluetoothState {
            static let poweredOn = "Bluetooth is powered on"
            static let poweredOff = "Bluetooth is powered off"
            static let unsupported = "Bluetooth low energy is not supported on this mac"
            static let unknown = "Bluetooth state is unknown"
            static let resetting = "Bluetooth is resetting"
        }
    }

    struct Image {
        struct BluetoothState {
            static let available = NSImage(named: "NSStatusAvailable")
            static let unavailable = NSImage(named: "NSStatusUnavailable")
            static let none = NSImage(named: "NSStatusNone")
            static let partiallyAvailable = NSImage(named: "NSStatusPartiallyAvailable")
        }
    }
}
