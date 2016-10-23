//
//  Coordinates.swift
//  Yelp
//
//  Created by Joshua Escribano on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct Coordinate {
    var latitude: Double?
    var longitude: Double?
    
    init() {
        
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(location: CLLocationCoordinate2D) {
        latitude = Double(location.latitude)
        longitude = Double(location.longitude)
    }
    
    init(dictionary: NSDictionary?) {
        if let dict = dictionary {
            latitude = dict["latitude"] as? Double
            longitude = dict["longitude"] as? Double
        }
    }
    
    internal func toCLLocationCoordinate2D() -> CLLocationCoordinate2D? {
        if latitude == nil || longitude == nil {
            return nil
        } else {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
    }
    
    internal static func sanFrancisco() -> Coordinate {
        return Coordinate(latitude: 37.785771, longitude: -122.406165)
    }
}
