//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CircularSpinner

class BusinessesViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var listMapSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    internal var businesses: [Business]!
    internal var searchedBusinesses: [Business]!
    internal var coordinate: Coordinate = Coordinate.sanFrancisco()
    internal var categories: [String]?
    internal var dealOffer: Bool?
    internal var sortBy: YelpSortMode? = YelpSortMode.bestMatched
    internal var distance: YelpDistanceMode?
    internal var loading: Bool! = false
    internal var hasMoreBusinesses: Bool! = true
    private var locationManager : CLLocationManager!
    private var searchBar: UISearchBar!
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.tintColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = UIColor(red:0.17, green:0.06, blue:0.68, alpha:1.0)
        navigationItem.titleView = searchBar
        
        listMapSegmentControl.tintColor = UIColor(red:0.27, green:0.11, blue:0.72, alpha:1.0)
        listMapSegmentControl.addTarget(self, action: #selector(listMapValueChanged), for: .valueChanged)
        mapView.delegate = self
        
        // Handle rotation for mapview
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessesViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        setUpMapView()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(searchRestaurants), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    internal func rotated() {
        mapView.frame = tableView.frame
    }
    
    internal func filterByDistance(_ yelpDistance: YelpDistanceMode) {
        let distanceDescription = yelpDistance.simpleDescription()
        let distance = Double(distanceDescription.components(separatedBy: " ").first!)
        businesses = businesses.filter({ (business:Business) -> Bool in
            let businessDistanceString = business.distance?.components(separatedBy: " ").first
            guard let dist = distance else { return false }
            guard let businessDistString = businessDistanceString else { return false }
            let businessDistance = Double(businessDistString)
            return businessDistance! < dist
        })
        searchedBusinesses = businesses
    }
    
    internal func searchRestaurantsWithOffset(_ offset: Int?) {
        loading = true
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        Business.searchWithTerm(term: "Restaurants", sort: sortBy, categories: categories, deals: dealOffer, coordinate: coordinate, limit: nil, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if offset != nil {
                let newBusinesses = businesses ?? [Business]()
                self.hasMoreBusinesses = !newBusinesses.isEmpty
                self.businesses = self.businesses + newBusinesses
                self.searchedBusinesses = self.searchedBusinesses + newBusinesses
            } else {
                self.businesses = businesses
                self.searchedBusinesses = businesses
            }
            
            if let distance = self.distance {
                self.filterByDistance(distance)
            }
            CircularSpinner.hide()
            self.tableView.reloadData()
            self.setupMapAnnotations()
            self.refreshControl.endRefreshing()
            self.loading = false
        })
    }
    
    @objc internal func searchRestaurants() {
        searchRestaurantsWithOffset(nil)
    }
    
    internal func setupMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        guard let searchResults = searchedBusinesses else { return }
        for business in searchResults {
            let businessCoordinate = business.coordinate?.toCLLocationCoordinate2D()
            if businessCoordinate != nil {
                let annotation = YelpAnnotation(business: business, coordinate: businessCoordinate!)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @objc private func listMapValueChanged() {
        let index = listMapSegmentControl.selectedSegmentIndex
        if index == 0 {
            // Set up List
            mapView.isHidden = true
            tableView.isHidden = false
        } else {
            // Set up Map View
            mapView.frame = tableView.frame
            mapView.isHidden = false
            tableView.isHidden = true
            setupMapAnnotations()
        }
    }
    
    private func setUpMapView() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let businessDetailController = segue.destination as? BusinessDetailViewController
        let navigationController = segue.destination as? UINavigationController
        if let navController = navigationController {
            let filtersViewController = navController.topViewController as! FiltersViewController
            
            filtersViewController.delegate = self
        }
        if let businessDetailVC = businessDetailController {
            let businessCell = sender as! BusinessCell
            businessDetailVC.business = businessCell.business
        }
     }
    
}

// MARK - TableViewDelegate
extension BusinessesViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK - TableViewDataSource
extension BusinessesViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedBusinesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = searchedBusinesses[indexPath.row]
        
        let totalCellCount = searchedBusinesses?.count ?? 0
        // HasMoreBusiness to prevent continuously searching restaurants if the 
        // filter or whatever doesn't have more businesses to add
        if indexPath.row == totalCellCount - 1 && !loading && hasMoreBusinesses && tableView.isDragging {
            searchRestaurantsWithOffset(totalCellCount)
        }
        
        return cell
    }
    
}

// MARK - FiltersViewControllerDelegate
extension BusinessesViewController:FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        categories = filters["categories"] as? [String]
        dealOffer = filters["dealOffer"] as? Bool
        sortBy = filters["sortBy"] as? YelpSortMode ?? YelpSortMode.bestMatched
        distance = filters["distance"] as? YelpDistanceMode
        hasMoreBusinesses = true // Reset because of potentially new filter
        searchRestaurants()
    }
    
}

// MARK - SearchBarDelegate
extension BusinessesViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchedBusinesses = businesses.filter({($0.name?.contains(searchText))!})
        } else {
            searchedBusinesses = businesses
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        setupMapAnnotations()
        searchBar.endEditing(true)
    }
    
}

// MARK - CLLocationManagerDelegate
extension BusinessesViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinate = Coordinate(location: location.coordinate)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: false)
            searchRestaurants()
        }
    }
}

// MARK - MKMapViewDelegate
extension BusinessesViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let yelpAnnotation = view.annotation as! YelpAnnotation
        let business = yelpAnnotation.business
        let businessDetailVC = storyboard?.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        businessDetailVC.business = business
        navigationController?.pushViewController(businessDetailVC, animated: true)
    }
    
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
        
        let annotationButton = UIButton(type: .detailDisclosure)
        annotationView!.rightCalloutAccessoryView = annotationButton
        annotationView!.image = UIImage(named: "map_pin")
        
        return annotationView
    }
    
}
