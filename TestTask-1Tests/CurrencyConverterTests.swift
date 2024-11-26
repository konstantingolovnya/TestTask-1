//
//  CurrencyConverterTests.swift
//  TestTask-1Tests
//
//  Created by Konstantin on 13.11.2024.
//

import XCTest
@testable import TestTask_1

final class CurrencyConverterTests: XCTestCase {
    
    private var currencyConverter: CurrencyConverter!
    
    override func setUpWithError() throws {
        currencyConverter = .init()
    }
    
    override func tearDownWithError() throws {
        currencyConverter = nil
    }
    
    func testDirectConversion() throws {
        let rates = [CurrencyRate(from: "USD", to: "GBP", rate: 2)]
                
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "GBP", rates: rates))
        XCTAssertEqual(result, 200)
    }
    
    func testInderectConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
                
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "JPY", rates: rates))
        XCTAssertEqual(result, 600)
    }
    
    func testSameCurrencyConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
        
        currencyConverter = CurrencyConverter()
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "USD", rates: rates))
        XCTAssertEqual(result, 100)
    }
    
    func testConversionWithNotrate() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
        
        let result = currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "BTC", rates: rates)
        XCTAssertNil(result)
    }
    
    func testMultipleConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3),
            CurrencyRate(from: "JPY", to: "EUR", rate: 4)
        ]
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "EUR", rates: rates))
        XCTAssertEqual(result, 2400)
    }
}
