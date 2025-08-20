//
//  RateService.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import Foundation

final class RateService {
    private let session = URLSession.shared
    
    private struct ConvertDTO: Decodable {
        let success: Bool?
        let date: String?
        let result: Double?
        let info: Info?
        struct Info: Decodable { let rate: Double? }
    }
    
    enum RateError: Error { case badURL, noData, decodeFailed, noResult }
    
    /// Uses https://api.exchangerate.host/convert (no API key)
    func convert(amount: Double, from: String, to: String,
                 completion: @escaping (Result<(converted: Double, rate: Double, timestamp: Date), Error>) -> Void) {
        let urlString = "https://api.exchangerate.host/convert?from=\(from)&to=\(to)&amount=\(amount)"
        guard let url = URL(string: urlString) else { return completion(.failure(RateError.badURL)) }
        
        session.dataTask(with: url) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            guard let data = data else { return completion(.failure(RateError.noData)) }
            do {
                let dto = try JSONDecoder().decode(ConvertDTO.self, from: data)
                guard let converted = dto.result else { return completion(.failure(RateError.noResult)) }
                let rate = dto.info?.rate ?? converted / max(amount, 0.000001)
                
                let date: Date = {
                    if let ds = dto.date {
                        let df = DateFormatter()
                        df.timeZone = TimeZone(secondsFromGMT: 0)
                        df.dateFormat = "yyyy-MM-dd"
                        return df.date(from: ds) ?? Date()
                    }
                    return Date()
                }()
                completion(.success((converted, rate, date)))
            } catch {
                completion(.failure(RateError.decodeFailed))
            }
        }.resume()
    }
}


