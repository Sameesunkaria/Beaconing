//
//  Beacon.swift
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

struct Beacon: Equatable {
    let proximityUUID: UUID
    let major: Int
    let minor: Int
    let measuredPower: Int
    let rssi: Int

    // TODO: chnage the name from updated to something better
    let updated: Date

    init?(withAdvertisementData advertisementData: Data, rssi: Int) {
        guard advertisementData.count == 25 else { return nil }

        // Company Identifier
        guard Data(bytes: advertisementData[0...1]).uint16 == 0x4C00 else { return nil }

        // Data Type
        guard advertisementData[2].data.int8 == 0x02 else { return nil }

        // Data length
        guard advertisementData[3].data.int8 == 0x15 else { return nil }

        guard let proximityUUID = advertisementData[4...19].uuid else { return nil }

        let major = advertisementData[20...21].uint16
        let minor = advertisementData[22...23].uint16
        let measuredPower = advertisementData[24].data.int8

        self.init(proximityUUID: proximityUUID, major: Int(major), minor: Int(minor), measuredPower: Int(measuredPower), rssi: rssi)
    }

    init?(withAdvertisementData advertisementData: NSData, rssi: NSNumber) {
        self.init(withAdvertisementData: advertisementData as Data, rssi: Int(truncating: rssi))
    }

    init(proximityUUID: UUID, major: Int, minor: Int, measuredPower: Int, rssi: Int) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
        self.measuredPower = measuredPower
        self.updated = Date()
        self.rssi = rssi
    }
}
