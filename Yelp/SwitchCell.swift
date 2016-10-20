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

    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    weak var delegate: SwitchCellDelegate?
    internal var filter: (FilterSectionID?, Any?) = (nil, nil) {
        didSet {
            guard let filterSection = filter.0 else { return }
            guard let filterValue = filter.1 else { return }
            switch filterSection {
            case .DealOffer:
                switchLabel.text = "Offering a Deal"
            case .Distance:
                switchLabel.text = "Auto"
            case .SortBy:
                switchLabel.text = "Best Match"
            case .Category:
                switchLabel.text = (filterValue as! [String: String])["name"]
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
