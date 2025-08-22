//
//  CurrencyCalculatorTests.swift
//  CurrencyCalculatorTests
//  Unit tests for conversion logic in CurrencyCalculator
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import XCTest
@testable import CurrencyCalculator

final class CurrencyCalculatorTests: XCTestCase {
    
    
    func testSuccessfulConversionUpdatesUI() {
        // Given
        let viewModel = ConversionViewModel()
        let expectation = XCTestExpectation(description: "Conversion callback should be called")
        
        // When
        viewModel.onConversionSuccess = { converted, timeString in
            XCTAssertFalse(converted.isEmpty, "Converted amount should not be empty")
            XCTAssertTrue(timeString.contains("UTC") || !timeString.isEmpty, "Time string should be returned")
            expectation.fulfill()
        }
        
        // Trigger conversion
        viewModel.convert(amountText: "100", fromCode: "USD", toCode: "NGN")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFailedConversionUpdatesError() {
        // Given
        let viewModel = ConversionViewModel()
        let expectation = XCTestExpectation(description: "Conversion failure callback should be called")
        
        viewModel.onConversionFailure = { errorMessage in
            XCTAssertFalse(errorMessage.isEmpty, "Error message should not be empty")
            expectation.fulfill()
        }
        
        // Invalid input (not a number)
        viewModel.convert(amountText: "INVALID", fromCode: "USD", toCode: "EUR")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }

}
