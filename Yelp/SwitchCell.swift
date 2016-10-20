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
    weak var delegate: SwitchCellDelegate?
    internal var filter: (FilterSectionID?, Any?) = (nil, nil) {
        didSet {
            guard let filterSection = filter.0 else { return }
            guard let filterValue = filter.1 else { return }
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
                onSwitch.isHidden = false
                onSelection.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSelection.backgroundColor = UIColor(red:1.00, green:0.91, blue:0.96, alpha:1.0)
        onSelection.layer.cornerRadius = 10
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }

}
