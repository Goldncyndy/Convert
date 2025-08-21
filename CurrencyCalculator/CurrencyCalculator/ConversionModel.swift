//
//  ConversionModel.swift
//  CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import Foundation

struct ConvertDTO: Decodable {
    let result: Double?
    let info: Info?
    struct Info: Decodable { let rate: Double? }
}
