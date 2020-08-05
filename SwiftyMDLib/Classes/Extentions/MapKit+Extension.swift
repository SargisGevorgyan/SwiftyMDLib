//
//  MapKit+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 8/5/20.
//

import Foundation
import MapKit
import AddressBookUI

public extension MKMapView {
    
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> CLLocationDistance {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
}

public extension CLLocationCoordinate2D {
    func distance(from topCenterCoordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let centerLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
}

public extension CLLocationDistance {
    func getMiles() -> CLLocationDistance {
        return self*0.000621371192
    }
    func getMeters() -> CLLocationDistance {
        return self*1609.344
    }
}
