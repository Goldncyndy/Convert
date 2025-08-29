//
//  RateService.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import Foundation
import Alamofire

final class RateService {
    
    enum RateError: Error {
        case badURL, noData, decodeFailed, noResult
    }
    
    // Fixer.io API key
    private let apiKey = "05e59b88446881a5375e57f3fc19588b"
    // base URL for API call
    private let baseURL = "https://data.fixer.io/api/latest"
    
    /// Convert an amount from one currency to another using Fixer.io
    func convert(amount: Double, from: String, to: String,
                 completion: @escaping (Result<(converted: Double, rate: Double, timestamp: Date), Error>) -> Void) {
        
        let urlString = "\(baseURL)?access_key=\(apiKey)&symbols=\(from),\(to)"
        
        AF.request(urlString).validate().responseDecodable(of: FixerResponse.self) { response in
            switch response.result {
            case .success(let dto):
                if dto.success {
                    // Fixer free plan: all rates are relative to EUR
                    guard let fromRate = dto.rates[from],
                          let toRate = dto.rates[to] else {
                        completion(.failure(RateError.noResult))
                        return
                    }
                    
                    // Cross rate calculation
                    let eurToFrom = fromRate
                    let eurToTo = toRate
                    let rate = eurToTo / eurToFrom
                    let converted = amount * rate
                    
                    completion(.success((converted, rate, Date(timeIntervalSince1970: TimeInterval(dto.timestamp)))))
                } else {
                    completion(.failure(RateError.noResult))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

