//
//  CMTime+Extension.swift
//
//  Copyright © 2022 MagicDevs. All rights reserved.
//

import Foundation
import CoreMedia

public extension CMTime {
    var asDouble: Double {
        return Double(self.value) / Double(self.timescale)
    }
    var asFloat: Float {
        return Float(self.value) / Float(self.timescale)
    }
}

extension CMTime: CustomStringConvertible {
    public var description: String {
        let seconds = Int(round(self.asDouble))
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
