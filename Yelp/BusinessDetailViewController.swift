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
        snippetImageView.layer.masksToBounds = true
        restaurantImageView.layer.masksToBounds = true
        snippetImageView.layer.cornerRadius = 25
        restaurantImageView.layer.cornerRadius = 32
        if let totalReviews = business.reviewCount {
            reviewsNameLabel.text = "\(totalReviews) Reviews"
        }
        if let ratingURL = business.ratingImageURL {
            ratingImageView.setImageWith(ratingURL)
        }
        if let businessURL = business.imageURL {
            restaurantImageView.setImageWith(businessURL)
        }
        if let snippetURL = business.snippetImageURL {
            snippetImageView.setImageWith(snippetURL)
        }
        if let coordinate = business.coordinate {
            setupMapView(coordinate: coordinate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle rotation for mapview
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        mapView.delegate = self
        setBusinessDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.setNeedsLayout()
        mapView.layoutIfNeeded()
    }
    
    @objc private func rotated() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight  {
            mapView.isHidden = true
        } else {
            mapView.isHidden = false
        }
    }
    
    private func setupMapView(coordinate: Coordinate) {
        let clCoordinate = coordinate.toCLLocationCoordinate2D()
        let annotation = YelpAnnotation(business: business!, coordinate: clCoordinate!)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: clCoordinate!, span: span)
        mapView.setRegion(region, animated: false)
    }

}

// MARK - MKMapViewDelegate
extension BusinessDetailViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "customAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
    
        annotationView!.image = UIImage(named: "map_pin")
        
        return annotationView
    }
    
}
