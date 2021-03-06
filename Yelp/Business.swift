//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let displayPhone: String?
    let snippetText: String?
    let coordinate: Coordinate?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let snippetImageURL: URL?
    let reviewCount: NSNumber?
    let isClosed: Bool?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        displayPhone = dictionary["display_phone"] as? String
        snippetText = dictionary["snippet_text"] as? String
        isClosed = dictionary["is_closed"] as? Bool
        
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var coordinate = Coordinate()
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            let coordinateDict = location!["coordinate"] as? NSDictionary
            coordinate = Coordinate(dictionary: coordinateDict)
        }
        self.coordinate = coordinate
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        let snippetImageURLString = dictionary["snippet_image_url"] as? String
        if snippetImageURLString != nil {
            snippetImageURL = URL(string: snippetImageURLString!)
        } else {
            snippetImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, coordinate: Coordinate?, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, coordinate: coordinate, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, coordinate: Coordinate?, limit: Int?, offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, coordinate: coordinate, limit: limit, offset: offset, completion: completion)
    }
}
