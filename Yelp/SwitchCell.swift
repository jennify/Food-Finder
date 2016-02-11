//
//  SwitchCell.swift
//  Yelp
//
//  Created by Jennifer Lee on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onOffSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchValueChanged() {
        print("switch value changed")
        if delegate != nil {
            delegate?.switchCell?(self, didChangeValue: onOffSwitch.on)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
