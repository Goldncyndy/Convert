//
//  ViewController+Extension.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/7/25.
//

import UIKit
import Foundation

// MARK: - TableView Delegate & Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as? DropdownTableViewCell else {
            return UITableViewCell()
        }
        
        let code = dropdownOptions[indexPath.row]
        cell.configure(with: code)
        cell.delegate = self
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCode = dropdownOptions[indexPath.row]
        print("Selected: \(selectedCode)")

        fromCurrencyCodeTextField.text = selectedCode
        
        activeDropdownTarget?.text = selectedCode
        // Update the correct textField and label based on the active target
        if activeDropdownTarget == fromCurrencyCodeTextField {
            fromCurrencyCodeTextField.text = selectedCode
            fromCurrencyCodeLabel.text = selectedCode
        } else if activeDropdownTarget == toCurrencyCodeTextField {
            toCurrencyCodeTextField.text = selectedCode
            toCurrencyCodeLabel.text = selectedCode
        }
        print("Selected: taaaaapppeeeddddddddddddddddddddd")
        dropdownTableView.isHidden = true
        activeDropdownTarget?.resignFirstResponder()
        activeDropdownTarget?.text = nil
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

}

// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeDropdownTarget = textField

        dropdownTableView.reloadData()
        dropdownTableView.isHidden = false
        // Do not show keyboard
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dropdownTableView.isHidden = true
        return true
    }
}

extension ViewController: DropdownCellDelegate {
    
    func didSelectCurrency(code: String) {
        // Handle what happens when a currency is selected
          print("Selected currency: \(code)")
          // Set to a textField
          fromCurrencyCodeTextField.text = code
          dropdownTableView.isHidden = true
    }
    
    
}
