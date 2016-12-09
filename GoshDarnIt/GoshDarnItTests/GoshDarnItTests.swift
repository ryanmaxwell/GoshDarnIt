//
//  GoshDarnItTests.swift
//  GoshDarnItTests
//
//  Created by Ryan Maxwell on 27/09/16.
//  Copyright © 2016 Cactuslab. All rights reserved.
//

import XCTest
@testable import GoshDarnIt

class GoshDarnItTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Test class extensions
    func testStringCensored() {
        
        let input = "Fuck it"
        
        let censored = input.censored([FilterType.profanity])
        
        XCTAssertEqual("**** it", censored)
    }
    
    func testStringCensor() {
        
        var input = "Fuck it"
        input.censor([FilterType.profanity])
        
        XCTAssertEqual("**** it", input)
    }
    
    func testNSString() {
        
        let input: NSString = "Fuck it"
        
        let censored = input.censored([FilterType.profanity])
        
        XCTAssertEqual("**** it", censored)
    }
    
    func testNSMutableString() {
        
        let input: NSMutableString = "Fuck it"
        input.censor([FilterType.profanity])
        
        XCTAssertEqual("**** it", input)
    }
    
    
    //MARK: Testing replacements
    
    func testSingle() {
        let input = "crap"
        
        XCTAssertEqual("****", input.censored([FilterType.profanity]))
    }
    
    func testCasing() {
        let input = "cRap"
        
        XCTAssertEqual("****", input.censored([FilterType.profanity]))
    }
    
    func testAllowSubstring() {
        let input = "I buy crepes at the crapery"
        XCTAssertEqual("I buy crepes at the crapery", input.censored([FilterType.profanity]))
    }
    
    func testMultiple() {
        
        let input = "Fucking wanker"
        
        XCTAssertEqual("******* ******", input.censored([FilterType.profanity]))
    }
    
    func testPunctuation() {
        let input = "This is shit, this testing."
        XCTAssertEqual("This is ****, this testing.", input.censored([FilterType.profanity]))
    }
    
    func testPunctuationInString() {
        let input = "This is shit-ass-fuck"
        XCTAssertEqual("This is ****-***-****", input.censored([FilterType.profanity]))
    }
    
    func testMultipleLines() {
        let input = "The first line\nshit\nand the third"
        XCTAssertEqual("The first line\n****\nand the third", input.censored([FilterType.profanity]))
    }
    
    func testEmailFilter() {
       let input = "johnSmith@gmail.com"
        XCTAssertEqual("*******************", input.censored([FilterType.emails]))
    }
    
    func testWebsiteFilter() {
        let input = "www.google.ca"
        XCTAssertEqual("*************", input.censored([FilterType.websites]))
    }
    
    func testAllFilters() {
        let input = "Fuck this www.google.ca email me at johnSmith@gmail.com"
        XCTAssertEqual("**** this ************* email me at *******************", input.censored([FilterType.emails, .profanity, .websites]))
    }
}
