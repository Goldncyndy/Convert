//
//  CurrencyCalculatorUITests.swift
//  CurrencyCalculatorUITests
//
//  Created by Cynthia D'Phoenix on 8/20/25.
//

import XCTest

final class CurrencyCalculatorUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testDropdownSelectionAndConversion() throws {
            // Tap the FromCurrency view to show dropdown
            app.otherElements["fromCodeView"].tap()
            
            // Select "EUR" from dropdown
            let eurCell = app.tables.cells.staticTexts["EUR"]
            XCTAssertTrue(eurCell.waitForExistence(timeout: 2), "EUR option should appear in dropdown")
            eurCell.tap()
            
            // Verify that textfield updated
            XCTAssertEqual(app.textFields["fromCurrencyCodeTextField"].value as? String, "EUR")
            
            // Enter an amount
            let amountField = app.textFields["fromCurrencyAmounntTextField"]
            amountField.tap()
            amountField.typeText("50")
            
            // Tap Convert button
            app.buttons["convertButton"].tap()
            
            // Verify result label/field is updated
            let resultField = app.textFields["toCurrencyAmountTextField"]
            XCTAssertFalse((resultField.value as? String ?? "").isEmpty, "Result field should not be empty after conversion")
        }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
