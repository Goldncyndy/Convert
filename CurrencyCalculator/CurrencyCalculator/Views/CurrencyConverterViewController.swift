//
//  ViewController.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import UIKit

class CurrencyConverterViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    @IBOutlet weak var fromCodeView: UIView!
    @IBOutlet weak var toCurrencyCodeView: UIView!
    
    @IBOutlet weak var marketView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var dropdownTableView: UITableView!
    
        var dropdownOptions = ["USD", "EUR", "PLN", "NGN", "GBP", "JPY"]
    var activeDropdownTarget: UITextField?
    
    private let rateService = RateService()
    var viewModel: ConversionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUITestAccessibilityIdentifiers()
        // Initialize the viewModel
        viewModel = ConversionViewModel()
        setupBindings()
        setupTapGesture()
        
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.isHidden = true

        fromCurrencyCodeTextField.delegate = self
        toCurrencyCodeTextField.delegate = self
         
        Snackbar.show(message: "Hello there!", in: self.view)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Force scrollView to calculate content size from contentView
        scrollView.layoutIfNeeded()
        scrollView.contentSize = contentView.frame.size
    }
    
    func setUITestAccessibilityIdentifiers() {
        fromCurrencyCodeTextField.accessibilityIdentifier = "fromCurrencyCodeTextField"
            fromCurrencyAmounntTextField.accessibilityIdentifier = "fromCurrencyAmounntTextField"
            toCurrencyAmountTextField.accessibilityIdentifier = "toCurrencyAmountTextField"
            convertButton.accessibilityIdentifier = "convertButton"
            fromCodeView.accessibilityIdentifier = "fromCodeView"
            toCurrencyCodeView.accessibilityIdentifier = "toCurrencyCodeView"
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
    
    func setupTapGesture() {
        // Background tap (to dismiss keyboard/dropdown)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndDropdown))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        contentView.addGestureRecognizer(tapGesture)
        
        // Tap for FromCurrencyCodeView
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(showFromCodeDropdown))
        tapGesture2.cancelsTouchesInView = false
        tapGesture2.delegate = self
        fromCodeView.addGestureRecognizer(tapGesture2)
        fromCodeView.isUserInteractionEnabled = true
        
        // Tap for ToCurrencyCodeView
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(showToCodeDropdown))
        tapGesture3.cancelsTouchesInView = false
        tapGesture3.delegate = self
        toCurrencyCodeView.addGestureRecognizer(tapGesture3)
        toCurrencyCodeView.isUserInteractionEnabled = true
        
        // Dropdown interaction
        dropdownTableView.isUserInteractionEnabled = true
        dropdownTableView.allowsSelection = true
        contentView.bringSubviewToFront(dropdownTableView)
    }

    
    func setupDropdownTable() {
           dropdownTableView.layer.borderWidth = 1
           dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
           dropdownTableView.layer.cornerRadius = 10
           
           dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc func showFromCodeDropdown() {
        activeDropdownTarget = fromCurrencyCodeTextField
            dropdownTableView.isHidden = false
            dropdownTableView.reloadData()
    }
    
    @objc func showToCodeDropdown() {
        activeDropdownTarget = toCurrencyCodeTextField
            dropdownTableView.isHidden = false
            dropdownTableView.reloadData()
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
            .font: UIFont.boldSystemFont(ofSize: 40)
        ], range: NSRange(location: 0, length: line1.count))

        // Style "Converter"
        let converterStart = line1.count + 1 // +1 for \n
        attributedText.addAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.boldSystemFont(ofSize: 40)
        ], range: NSRange(location: converterStart, length: line2.count))

        // Style the dot
        attributedText.addAttributes([
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont.boldSystemFont(ofSize: 40)
        ], range: NSRange(location: fullText.count - 1, length: 1))

        currencyTitleLabel.attributedText = attributedText
    }
    
    func setupMarketButton() {
        
        setMarketAttributedTitle(text: "Mid-market exchange rate at 13:38 UTC")
    }
    
    private func setMarketAttributedTitle(text: String) {
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.systemBlue
            ]
            marketButton.setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)
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
    
    @IBAction func conversionArrowTapped(_ sender: Any) {
        swapCurrencies()
    }
    
    @IBAction func amountEditingChanged(_ sender: UITextField) {
        guard let fromAmount = fromCurrencyAmounntTextField?.text,
                  let fromCode = fromCurrencyCodeTextField?.text,
                  let toCode = toCurrencyCodeTextField?.text else {
            Snackbar.show(message: "⚠️ One of the text fields is nil", isSuccess: false, in: self.view)
                return
            }
        
        // Check if any are empty
            if fromAmount.isEmpty || fromCode.isEmpty || toCode.isEmpty {
                Snackbar.show(message: "⚠️ Please fill in all fields", isSuccess: false, in: self.view)
                return
            }
        
        // Replace comma with dot for normalization
            let normalized = fromAmount.replacingOccurrences(of: ",", with: ".")

            if Double(normalized) == nil && !fromAmount.isEmpty {
                // Invalid number entered -> Show Snackbar
                Snackbar.show(message: "Invalid amount entered. Please use numbers only.", isSuccess: false, in: self.view)
                        return
            }

        viewModel?.convert(
                amountText: fromAmount,
                fromCode: fromCode,
                toCode: toCode
            )
    }
    // MARK: - Bind ViewModel
    private func setupBindings() {
        viewModel?.onConversionSuccess = { [weak self] converted, timeString in
            print("Converted:", converted, "Time:", timeString)

            DispatchQueue.main.async {
                guard let self = self else { return }
                Snackbar.show(message: "Converted!", isSuccess: true, in: self.view)
                self.toCurrencyAmountTextField.text = converted
                self.setMarketAttributedTitle(text: timeString)
            }
        }

        viewModel?.onConversionFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                guard let self = self else { return }
                Snackbar.show(message: errorMessage, isSuccess: false, in: self.view)
                self.toCurrencyAmountTextField.text = ""
                self.setMarketAttributedTitle(text: errorMessage)
            }
        }
    }

        // MARK: - Conversion
    func convertIfPossible() {
        guard
            let fromCode = fromCurrencyCodeTextField.text, !fromCode.isEmpty,
            let toCode = toCurrencyCodeTextField.text, !toCode.isEmpty,
            let raw = fromCurrencyAmounntTextField.text, !raw.isEmpty
        else { return }
        
        // Check if any are empty
            if raw.isEmpty || fromCode.isEmpty || toCode.isEmpty {
                Snackbar.show(message: "⚠️ Please fill in all fields", isSuccess: false, in: self.view)
                return
            }
        
        let normalized = raw.replacingOccurrences(of: ",", with: ".")
        guard Double(normalized) != nil else {
                Snackbar.show(message: "Invalid amount entered. Please enter a valid number.", isSuccess: false, in: self.view)

                return
            }
        
        viewModel?.convert(amountText: raw, fromCode: fromCode, toCode: toCode)
    }

        
        private func swapCurrencies() {
            let from = fromCurrencyCodeTextField.text
            let to = toCurrencyCodeTextField.text
            fromCurrencyCodeTextField.text = to
            fromCurrencyCodeLabel.text = to
            toCurrencyCodeTextField.text = from
            toCurrencyCodeLabel.text = from
            
            // already have a converted value, move it back so the user can continue chaining conversions
            if let toVal = toCurrencyAmountTextField.text, !toVal.isEmpty {
                fromCurrencyAmounntTextField.text = toVal
            }
            toCurrencyAmountTextField.text = ""
            convertIfPossible()
        }
        
        private func format(amount: Double) -> String {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.maximumFractionDigits = 2
            return nf.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
        }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        // Listen for typing to auto-convert
        fromCurrencyAmounntTextField.addTarget(self, action: #selector(amountEditingChanged(_:)), for: .editingChanged)
        
        amountEditingChanged(fromCurrencyAmounntTextField)
        
        convertIfPossible()
       }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // If the touch is inside the dropdown table, let the table handle it
        if !dropdownTableView.isHidden,
           let v = touch.view,
           v.isDescendant(of: dropdownTableView) {
            return false
        }
        return true
    }
    
    }

