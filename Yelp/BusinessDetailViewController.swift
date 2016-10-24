//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Joshua Escribano on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking

class BusinessDetailViewController: UIViewController {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsNameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var snippetTextLabel: UILabel!
    @IBOutlet weak var snippetImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    internal var business: Business? {
        didSet {
            guard restaurantNameLabel != nil else { return }
            setBusinessDetails()
        }
    }
    
    private func setBusinessDetails() {
        guard let business = business else { return }
        restaurantNameLabel.text = business.name
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        distanceLabel.text = business.distance
        phoneNumberLabel.text = business.displayPhone
        if let isClosed = business.isClosed {
            if isClosed {
                openStatusLabel.text = "Closed"
            } else {
                openStatusLabel.text = "Open"
            }
        } else {
            openStatusLabel.text = "Maybe"
        }
        snippetTextLabel.text = business.snippetText
        reviewsNameLabel.text = "\(business.reviewCount!) Reviews"
        ratingImageView.setImageWith(business.ratingImageURL!)
        restaurantImageView.setImageWith(business.imageURL!)
        snippetImageView.setImageWith(business.snippetImageURL!)
        snippetImageView.layer.masksToBounds = true
        restaurantImageView.layer.masksToBounds = true
        snippetImageView.layer.cornerRadius = 25
        restaurantImageView.layer.cornerRadius = 32
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle rotation for mapview
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        setBusinessDetails()
    }
    
    @objc private func rotated() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight  {
            mapView.isHidden = true
        } else {
            mapView.isHidden = false
        }
    }

}
