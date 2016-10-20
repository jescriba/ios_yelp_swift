//
//  Filters.swift
//  Yelp
//
//  Created by Joshua Escribano on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

enum FilterSectionID:Int {
    case DealOffer, Distance, SortBy, Category
}

class Filters {
    var sections: [FilterSectionID:[Any]]!
    
    init() {
        sections = [FilterSectionID:[Any]]()
        sections[.DealOffer] = [false]
        sections[.Distance] = [1]
        sections[.SortBy] = [1]
        sections[.Category] = [String]()
    }

}
