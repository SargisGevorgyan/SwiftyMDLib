//
//  CGFloat+.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation

public extension CGFloat {
    
    var scaled: CGFloat {
        return self * UIDevice.scale
    }
    
    var ipadScaled: CGFloat {
        return self * UIDevice.iPadScale
    }
}

public extension CGRect {
    
    var scaled: CGRect {
        var frame = self
        frame.origin.x *= UIDevice.scale
        frame.origin.y *= UIDevice.scale
        frame.size.width *= UIDevice.scale
        frame.size.height *= UIDevice.scale
        return frame
    }
}


public extension Int {
    
    var scaled: CGFloat {
        return CGFloat(self).scaled
    }
    
    var ipadScaled: CGFloat {
        return CGFloat(self) * UIDevice.iPadScale
    }
}

public extension Double {
    var scaled: CGFloat {
        return CGFloat(self).scaled
    }
    
    var ipadScaled: CGFloat {
        return CGFloat(self) * UIDevice.iPadScale
    }
}
