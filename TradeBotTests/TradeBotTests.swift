//
//  TradeBotTests.swift
//  TradeBotTests
//
//  Created by Darren Hurst on 2021-09-17.
//

import XCTest
@testable import TradeBot

class TradeBotTests: XCTestCase {
    let quoteActor = QuoteInteractor.init(symbol: "GOOG")
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //Test Sample One
        XCTAssertEqual(quoteActor.symbol, "GOOG")
        // AC Requirement, user may update the quoteActor to display a different symbol
        try? await quoteActor.load(symbol: "IBM")
        XCTAssertEqual(quoteActor.quote.symbol, "IBM") // the returned quote
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
