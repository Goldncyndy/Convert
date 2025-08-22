//
//  ConversionViewModel.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import Foundation

final class ConversionViewModel {
    private let rateService = RateService()
    
    var onConversionSuccess: ((String, String) -> Void)?
    var onConversionFailure: ((String) -> Void)?
    
    func convert(amountText: String?, fromCode: String?, toCode: String?) {
        guard
            let raw = amountText, !raw.isEmpty,
            let from = fromCode, !from.isEmpty,
            let to = toCode, !to.isEmpty
        else { return }
        
        let normalized = raw.replacingOccurrences(of: ",", with: ".")
        guard let amount = Double(normalized) else { return }
        
        rateService.convert(amount: amount, from: from, to: to) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let payload):
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    let converted = formatter.string(from: NSNumber(value: payload.converted)) ?? "\(payload.converted)"
                    
                    let timeFmt = DateFormatter()
                    timeFmt.timeZone = TimeZone(secondsFromGMT: 0)
                    timeFmt.dateFormat = "HH:mm 'UTC'"
                    let timeString = "Mid-market exchange rate at \(timeFmt.string(from: payload.timestamp))"
                    
                    self?.onConversionSuccess?(converted, timeString)
                    
                case .failure:
                    self?.onConversionFailure?("Couldn’t fetch rate. Check connection")
                }
            }
        }
    }
}

