//
//  ViewController+Extension.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/7/25.
//

import UIKit

// MARK: - TableView Delegate & Data Source
extension CurrencyConverterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownTableViewCell
        
        let code = dropdownOptions[indexPath.row]
        cell.configure(with: code)
        cell.selectionStyle = .default
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCode = dropdownOptions[indexPath.row]
            print(" Selected currency: \(selectedCode)")

            if activeDropdownTarget === fromCurrencyCodeTextField {
                fromCurrencyCodeTextField.text = selectedCode
                fromCurrencyCodeLabel.text = selectedCode
            } else if activeDropdownTarget === toCurrencyCodeTextField {
                toCurrencyCodeTextField.text = selectedCode
                toCurrencyCodeLabel.text = selectedCode
            }
        
        // Hide dropdown after selection
        dropdownTableView.isHidden = true
        activeDropdownTarget = nil
        view.endEditing(true)
        
        // Trigger conversion after selecting
        convertIfPossible()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

// MARK: - UITextField Delegate
extension CurrencyConverterViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Save which textField triggered the dropdown
        activeDropdownTarget = textField
        
        // Show dropdown below tapped field
        showDropdown(below: textField)
        
            if textField == fromCurrencyCodeTextField {
                print("From Currency tapped")
                showDropdown(below: fromCurrencyCodeTextField)
                return false
            } else if textField == toCurrencyCodeTextField {
                print("To Currency tapped")
                showDropdown(below: toCurrencyCodeTextField)
                return false
            }
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeDropdownTarget = textField
        showDropdown(below: textField)
        return false
    }
}

