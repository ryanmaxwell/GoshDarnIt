//
//  GoshDarnItObjCTests.m
//  GoshDarnItObjCTests
//
//  Created by Ryan Maxwell on 30/09/16.
//  Copyright © 2016 Cactuslab. All rights reserved.
//

#import <XCTest/XCTest.h>

@import GoshDarnIt;

@interface GoshDarnItObjCTests : XCTestCase

@end

@implementation GoshDarnItObjCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSString {
    
    NSString *input = @"Fuck it";
    NSString *censored = [input censored];
    
    XCTAssertEqualObjects(@"**** it", censored);
}

- (void)testNSMutableString {
    
    NSMutableString *input = [NSMutableString stringWithString:@"Fuck it"];
    [input censor];
    
    XCTAssertEqualObjects(@"**** it", input);
}

@end
