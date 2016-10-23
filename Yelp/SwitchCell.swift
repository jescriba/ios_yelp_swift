//
//  SwitchCell.swift
//  Yelp
//
//  Created by joshua on 10/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var onSelection: UIView!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSelectionLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    internal var filter: (FilterSectionID?, Any?) = (nil, nil) {
        didSet {
            guard let filterSection = filter.0 else { return }
            guard let filterValue = filter.1 else { return }
            switchLabel.textColor = UIColor.black
            switch filterSection {
            case .dealOffer:
                switchLabel.text = "Offering a Deal"
                onSwitch.isHidden = false
                onSelection.isHidden = true
            case .distance:
                switchLabel.text = (filterValue as! YelpDistanceMode).simpleDescription()
                onSwitch.isHidden = true
                onSelection.isHidden = false
            case .sortBy:
                switchLabel.text = (filterValue as! YelpSortMode).simpleDescription()
                onSwitch.isHidden = true
                onSelection.isHidden = false
            case .category:
                switchLabel.text = (filterValue as! [String: String])["name"]
                if switchLabel.text == "See All" {
                    onSwitch.isHidden = true
                    onSelection.isHidden = false
                    switchLabel.textColor = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.0)
                } else {
                    onSwitch.isHidden = false
                    onSelection.isHidden = true
                    switchLabel.textAlignment = .natural
                    switchLabel.textColor = UIColor.black
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        onSelection.layer.cornerRadius = 15
        onSwitch.layer.cornerRadius = 16
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }

}
