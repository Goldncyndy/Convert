//
//  RateService.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import Foundation
import Alamofire

final class RateService {
    
    private struct ERARatesResponse: Decodable {
        let result: String
        let base_code: String
        let rates: [String: Double]
    }
    
    enum RateError: Error { case badURL, noData, decodeFailed, noResult }
    
    /// Uses https://open.er-api.com/v6/latest (no API key required)
    func convert(amount: Double, from: String, to: String,
                 completion: @escaping (Result<(converted: Double, rate: Double, timestamp: Date), Error>) -> Void) {
        
        let urlString = "https://open.er-api.com/v6/latest/\(from)"
        
        AF.request(urlString).validate().responseDecodable(of: ERARatesResponse.self) { response in
            switch response.result {
            case .success(let dto):
                if dto.result.lowercased() == "success",
                   let rate = dto.rates[to] {
                    let converted = amount * rate
                    completion(.success((converted, rate, Date())))
                } else {
                    completion(.failure(RateError.noResult))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//import Foundation
//
//final class RateService {
//    private let session = URLSession.shared
//    
//    private struct ERARatesResponse: Decodable {
//        let result: String
//        let base_code: String
//        let rates: [String: Double]
//    }
//    
//    enum RateError: Error { case badURL, noData, decodeFailed, noResult }
//    
//    /// Uses https://open.er-api.com/v6/latest (no API key required)
//    func convert(amount: Double, from: String, to: String,
//                 completion: @escaping (Result<(converted: Double, rate: Double, timestamp: Date), Error>) -> Void) {
//        
//        let urlString = "https://open.er-api.com/v6/latest/\(from)"
//        guard let url = URL(string: urlString) else {
//            return completion(.failure(RateError.badURL))
//        }
//        
//        session.dataTask(with: url) { data, _, error in
//            if let error = error { return completion(.failure(error)) }
//            guard let data = data else { return completion(.failure(RateError.noData)) }
//            
//            do {
//                let dto = try JSONDecoder().decode(ERARatesResponse.self, from: data)
//                
//                if dto.result.lowercased() == "success",
//                   let rate = dto.rates[to] {
//                    let converted = amount * rate
//                    completion(.success((converted, rate, Date())))
//                } else {
//                    completion(.failure(RateError.noResult))
//                }
//            } catch {
//                completion(.failure(RateError.decodeFailed))
//            }
//        }.resume()
//    }
//}
