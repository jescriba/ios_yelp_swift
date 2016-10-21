//
//  FiltersViewController.swift
//  Yelp
//
//  Created by joshua on 10/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    internal var categories: [[String:String]]!
    internal var switchStates = [IndexPath:Bool]()
    internal var filters = Filters()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = loadCategories()
        filters.sections[.category] = categories.first(n: 4)
        filters.sections[.category]?.append(["name": "See All", "code": "See All"])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        for (indexPath, isSelected) in switchStates {
            let sectionID = FilterSectionID(rawValue: indexPath.section)!
            switch sectionID {
            case .dealOffer:
                if isSelected {
                    filters["dealOffer"] = true as AnyObject
                }
            case .category:
                if isSelected {
                    selectedCategories.append(categories[indexPath.row]["code"]!)
                }
            case .distance:
                if isSelected {
                    let firstDistance = self.filters.sections[sectionID]?.first as! YelpDistanceMode
                    filters["distance"] = firstDistance as AnyObject
                }
            case .sortBy:
                if isSelected {
                    let firstSort = self.filters.sections[sectionID]?.first as! YelpSortMode
                    filters["sortBy"] = firstSort as AnyObject
                }
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    // Originally just used let categories = and Xcode lost its mind
    func loadCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}

// MARK - TableViewDataSource
extension FiltersViewController:UITableViewDataSource {
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return filters.sections.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionID = FilterSectionID(rawValue: section)!
        return filters.sections[sectionID]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        let filterID = FilterSectionID(rawValue: indexPath.section)!
        cell.filter = (filterID, filters.sections[filterID]?[indexPath.row])
        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath] ?? false
        
        return cell;
    }
}

// MARK - TableViewDelegate
extension FiltersViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = indexPath.section
        let sectionID = FilterSectionID(rawValue: section)!
        let indexSet = IndexSet(integer: section)
        switch sectionID {
        case .sortBy:
            var sortModes = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
            let initialPreference = filters.sections[sectionID]?.first!
            sortModes = bringToTop(array: sortModes, sortMode: initialPreference as? YelpSortMode) as! [YelpSortMode]
            var isExpanded = false
            if filters.sections[sectionID]!.count == 1 {
                // Expand Sort Modes
                isExpanded = true
                filters.sections[sectionID] = sortModes
            } else {
                // Collapse Sort Modes
                filters.sections[sectionID] = [sortModes[indexPath.row]]
                switchStates[indexPath] = true
            }
            tableView.reloadSections(indexSet, with: .fade)
            updateSectionSelectionLabels(section, isExpanded: isExpanded)
        case .distance:
            var distanceModes = [YelpDistanceMode.auto, YelpDistanceMode.closest, YelpDistanceMode.close, YelpDistanceMode.midRange, YelpDistanceMode.far]
            let initialPreference = filters.sections[sectionID]?.first!
            distanceModes = bringToTop(array: distanceModes, distanceMode: initialPreference as? YelpDistanceMode) as! [YelpDistanceMode]
            var isExpanded = false
            if filters.sections[sectionID]!.count == 1 {
                // Expand Distance Modes
                isExpanded = true
                filters.sections[sectionID] = distanceModes
            } else {
                // Collapse Distance Modes
                filters.sections[sectionID] = [distanceModes[indexPath.row]]
                switchStates[indexPath] = true
            }
            tableView.reloadSections(indexSet, with: .fade)
            updateSectionSelectionLabels(section, isExpanded: isExpanded)

        case .category:
            if (filters.sections[sectionID]?.count)! < categories.count {
                filters.sections[sectionID] = categories
                tableView.reloadSections(indexSet, with: .fade)
            }
        default:
            break
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.size.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        headerView.backgroundColor = UIColor(red:1.00, green:0.97, blue:0.96, alpha:1.0)
        
        let sectionID = FilterSectionID(rawValue: section)!
        if sectionID != .dealOffer {
            let sectionID = FilterSectionID(rawValue: section)!
            let label = UILabel(frame: headerView.frame)
            label.textAlignment = .center
            label.text = sectionID.simpleDescription()
            headerView.addSubview(label)
        }
        return headerView
    }
    
    private func updateSectionSelectionLabels(_ section: Int, isExpanded: Bool) {
        for i in 0...(tableView.numberOfRows(inSection: section) - 1) {
            let indexPath = IndexPath(row: i, section: section)
            let cell = tableView.cellForRow(at: indexPath) as! SwitchCell
            if isExpanded {
                if i != 0 {
                    cell.onSelectionLabel.text = "・"
                } else {
                    cell.onSelectionLabel.text = "✔︎"
                }
            } else {
                cell.onSelectionLabel.text = "▾"
            }
        }
    }
    
    private func bringToTop(array: [Any], sortMode: YelpSortMode? = nil, distanceMode: YelpDistanceMode? = nil) -> [Any] {
        if let sortMode = sortMode {
            var sortArray = array as! [YelpSortMode]
            var index: Int!
            for (i, val) in sortArray.enumerated() {
                if val == sortMode {
                    index = i
                    break
                }
            }
            if let index = index {
                sortArray.remove(at: index)
                sortArray.insert(sortMode, at: 0)
                return sortArray
            }
        }
        if let distanceMode = distanceMode {
            var distanceArray = array as! [YelpDistanceMode]
            var index: Int!
            for (i, val) in distanceArray.enumerated() {
                if val == distanceMode {
                    index = i
                    break
                }
            }
            if let index = index {
                distanceArray.remove(at: index)
                distanceArray.insert(distanceMode, at: 0)
                return distanceArray
            }
        }
        return array
    }
    
}

// MARK - SwitchCellDelegate
extension FiltersViewController:SwitchCellDelegate {

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switchStates[indexPath] = value
    }
}

extension Array {
    
    func first(n: Int) -> Array {
        var newArray = Array()
        for (index, el) in self.enumerated() {
            if index < n {
                newArray.append(el)
            }
        }
        return newArray
    }
    
}
