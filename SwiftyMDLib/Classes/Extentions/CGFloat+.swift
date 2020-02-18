//
//  CGFloat+.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation




extension CGFloat {
    
    var scaled: CGFloat {
        return self * UIDevice.scale
    }
}

extension CGRect {
    
    var scaled: CGRect {
        var frame = self
        frame.origin.x *= UIDevice.scale
        frame.origin.y *= UIDevice.scale
        frame.size.width *= UIDevice.scale
        frame.size.height *= UIDevice.scale
        return frame
    }
}


extension Int {
    
    var scaled: CGFloat {
        return CGFloat(self).scaled
    }
    
}

extension Double {
    var scaled: CGFloat {
        return CGFloat(self).scaled
    }
}
