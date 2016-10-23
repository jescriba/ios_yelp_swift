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
    var business: Business?
    let coordinate: CLLocationCoordinate2D
    
    init(business: Business, coordinate: CLLocationCoordinate2D) {
        self.business = business
        self.title = business.name
        self.coordinate = coordinate
        
        super.init()
    }
}
