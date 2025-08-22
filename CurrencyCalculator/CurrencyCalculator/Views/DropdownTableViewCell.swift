//
//  DropdownTableViewCell.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import UIKit

protocol DropdownCellDelegate: AnyObject {
    func didSelectCurrency(code: String)
}

class DropdownTableViewCell: UITableViewCell {
//    static let identifier = "DropdownTableViewCell"
    weak var delegate: DropdownCellDelegate?
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with code: String) {
        currencyCodeLabel.text = code
    }

    @IBAction func cellTapped(_ sender: Any) {
        if let code = currencyCodeLabel.text {
            delegate?.didSelectCurrency(code: code)
        }
    }

}

