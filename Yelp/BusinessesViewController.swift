//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CircularSpinner

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    internal var businesses: [Business]!
    internal var searchedBusinesses: [Business]!
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = UIColor(red:0.17, green:0.06, blue:0.68, alpha:1.0)
        navigationItem.titleView = searchBar
        
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.searchedBusinesses = businesses
            CircularSpinner.hide()
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        })
        
    }
    
    internal func filterByDistance(_ yelpDistance: YelpDistanceMode) {
        let distanceDescription = yelpDistance.simpleDescription()
        let distance = Double(distanceDescription.components(separatedBy: " ").first!)
        businesses = businesses.filter({ (business:Business) -> Bool in
            let businessDistance = Double((business.distance?.components(separatedBy: " ").first!)!)
            return businessDistance! < distance!
        })
        searchedBusinesses = businesses
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
     }
    
}

// MARK - TableViewDelegate
extension BusinessesViewController:UITableViewDelegate {
    
}

// MARK - TableViewDataSource
extension BusinessesViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedBusinesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = searchedBusinesses[indexPath.row]
        
        return cell
    }
    
}

// MARK - FiltersViewControllerDelegate
extension BusinessesViewController:FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let dealOffer = filters["dealOffer"] as? Bool
        let sortBy = filters["sortBy"] as? YelpSortMode ?? YelpSortMode.bestMatched
        Business.searchWithTerm(term: "Restaurants", sort: sortBy, categories: categories, deals: dealOffer, completion: {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.searchedBusinesses = businesses
            if let distance = filters["distance"] {
                self.filterByDistance(distance as! YelpDistanceMode)
            }
            self.tableView.reloadData()
        })
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
        searchBar.endEditing(true)
    }
    
}
