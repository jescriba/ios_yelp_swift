//
//  Filters.swift
//  Yelp
//
//  Created by Joshua Escribano on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

enum FilterSectionID:Int {
    case dealOffer, distance, sortBy, category
    
    func simpleDescription() -> String {
        switch self {
        case .dealOffer:
            return "Deal Offer"
        case .distance:
            return "Distance"
        case .sortBy:
            return "Sort By"
        case .category:
            return "Category"
        }
    }
}

class Filters {
    var sections: [FilterSectionID:[Any]]!
    
    init() {
        sections = [FilterSectionID:[Any]]()
        sections[.dealOffer] = [false]
        sections[.distance] = [YelpDistanceMode.auto]
        sections[.sortBy] = [YelpSortMode.bestMatched]
        sections[.category] = [String]()
    }

}
