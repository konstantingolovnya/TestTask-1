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
        
    }
    
    override func tearDownWithError() throws {
        currencyConverter = nil
    }
    
    func testDirectConversion() throws {
        let rates = [CurrencyRate(from: "USD", to: "GBP", rate: 2)]
        
        let currencyConverter = CurrencyConverter(rates: rates)
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "GBP"))
        XCTAssertEqual(result, 200)
    }
    
    func testInderectConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
        
        let currencyConverter = CurrencyConverter(rates: rates)
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "JPY"))
        XCTAssertEqual(result, 600)
    }
    
    func testSameCurrencyConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
        
        let currencyConverter = CurrencyConverter(rates: rates)
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "USD"))
        XCTAssertEqual(result, 100)
    }
    
    func testConversionWithNotrate() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3)
        ]
        
        let currencyConverter = CurrencyConverter(rates: rates)
        
        let result = currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "BTC")
        XCTAssertNil(result)
    }
    
    func testMultipleConversion() throws {
        let rates = [
            CurrencyRate(from: "USD", to: "GBP", rate: 2),
            CurrencyRate(from: "GBP", to: "JPY", rate: 3),
            CurrencyRate(from: "JPY", to: "EUR", rate: 4)
        ]
        
        let currencyConverter = CurrencyConverter(rates: rates)
        
        let result = try XCTUnwrap(currencyConverter.convert(amount: 100, fromCurrency: "USD", toCurrency: "EUR"))
        XCTAssertEqual(result, 2400)
    }
}
