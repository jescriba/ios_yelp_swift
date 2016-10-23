//
//  YelpAnnotation.swift
//  Yelp
//
//  Created by Joshua Escribano on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class YelpAnnotation:NSObject, MKAnnotation {
    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
