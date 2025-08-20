//
//  ViewController.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyDropdown: UIButton!
    @IBOutlet weak var toCurrencyDropdown: UIButton!
    
    @IBOutlet weak var conversionArrow: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var marketButton: UIButton!
    
    @IBOutlet weak var toCurrencyView: UIView!
    @IBOutlet weak var fromCurrencyView: UIView!
    
    @IBOutlet weak var toCurrencyCodeLabel: UILabel!
    @IBOutlet weak var fromCurrencyCodeLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyAmounntTextField: UITextField!
    @IBOutlet weak var toCurrencyAmountTextField: UITextField!
    
    @IBOutlet weak var toCurrencyCodeTextField: UITextField!
    @IBOutlet weak var fromCurrencyCodeTextField: UITextField!
    
    @IBOutlet weak var marketView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var dropdownTableView: UITableView!
    
        var dropdownOptions = ["USD", "EUR", "PLN", "NGN", "GBP", "JPY"]
        var activeDropdownTarget: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.isHidden = true

        fromCurrencyCodeTextField.delegate = self
        toCurrencyCodeTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndDropdown))
        contentView.addGestureRecognizer(tapGesture)
        contentView.bringSubviewToFront(dropdownTableView)

       
    }
    
    // MARK: - Setup
        func setupUI() {
            hamburgerButton.setTitle("", for: .normal)
            fromCurrencyDropdown.setTitle("", for: .normal)
            toCurrencyDropdown.setTitle("", for: .normal)
            conversionArrow.setTitle("", for: .normal)
            infoButton.setTitle("", for: .normal)
            
            setupTitleLabel()
            setupMarketButton()
            setupCurrencyViews()
            setupDropdownTable()
        }
    
    func setupDropdownTable() {
           dropdownTableView.layer.borderWidth = 1
           dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
           dropdownTableView.layer.cornerRadius = 10
           
           dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
//        dropdownTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
       }
       
       func setupDismissKeyboardTap() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndDropdown))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }

       @objc func dismissKeyboardAndDropdown() {
           view.endEditing(true)
           dropdownTableView.isHidden = true
           activeDropdownTarget = nil
       }

    func setupTitleLabel() {
        let line1 = "Currency"
        let line2 = "Converter"
        let dot = "."

        let fullText = "\(line1)\n\(line2)\(dot)"
        let attributedText = NSMutableAttributedString(string: fullText)

        // Style "Currency"
        attributedText.addAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.boldSystemFont(ofSize: 42)
        ], range: NSRange(location: 0, length: line1.count))

        // Style "Converter"
        let converterStart = line1.count + 1 // +1 for \n
        attributedText.addAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.boldSystemFont(ofSize: 42)
        ], range: NSRange(location: converterStart, length: line2.count))

        // Style the dot
        attributedText.addAttributes([
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont.boldSystemFont(ofSize: 42)
        ], range: NSRange(location: fullText.count - 1, length: 1))

        currencyTitleLabel.attributedText = attributedText
    }
    
    func setupMarketButton() {
        let title = "Mid-market exchange rate at 13:38 UTC"
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.systemBlue // set color
            ]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        marketButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setupCurrencyViews() {
            [toCurrencyView, fromCurrencyView].forEach {
                $0?.layer.borderWidth = 1
                $0?.layer.borderColor = UIColor.lightGray.cgColor
                $0?.layer.cornerRadius = 5
            }

            marketView.layer.cornerRadius = 25
            marketView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            marketView.clipsToBounds = true
        }

    // MARK: - Button Actions
       @IBAction func fromCurrencyDropdownTapped(_ sender: UIButton) {
           activeDropdownTarget = fromCurrencyCodeTextField
               dropdownTableView.isHidden = false
               dropdownTableView.reloadData()
       }

       @IBAction func toCurrencyDropdownTapped(_ sender: UIButton) {
           activeDropdownTarget = toCurrencyCodeTextField
               dropdownTableView.isHidden = false
               dropdownTableView.reloadData()
       }

       // MARK: - Dropdown Display
       func showDropdown(below textField: UITextField) {
           dropdownTableView.reloadData()
           dropdownTableView.isHidden = false

       }
    
}

