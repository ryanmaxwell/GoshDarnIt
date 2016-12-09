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

- (void)testEmailFilter {
    
    NSString *input = @"johnSmith@gmail.com";
    NSDictionary *censorDict = @{ @"emails": @TRUE };
    NSString *censored = [input censored: censorDict];
    
    XCTAssertEqualObjects(@"*******************", censored);
}

- (void)testWebsiteFilter {
    NSString *input = @"www.google.ca";
    NSDictionary *censorDict = @{ @"websites": @TRUE };
    NSString *censored = [input censored:censorDict];
   
    XCTAssertEqualObjects(@"*************", censored);
}

- (void)testNSMutableStringForEmailsFilter {
    NSMutableString *input = [NSMutableString stringWithString:@"johnSmith@gmail.com"];
    NSDictionary *censorDict = @{ @"emails": @TRUE };
    [input censor:censorDict];
    XCTAssertEqualObjects(@"*******************", input);
}

- (void)testNSMutableStringForWebsitesFilter {
    NSMutableString *input = [NSMutableString stringWithString:@"www.google.ca"];
    NSDictionary *censorDict = @{ @"websites": @TRUE };
    [input censor:censorDict];
    XCTAssertEqualObjects(@"*************", input);
}

- (void)testNSMutableStringForAllFilters {
    NSMutableString *input = [NSMutableString stringWithString:@"Fuck this www.google.ca email me at johnSmith@gmail.com"];
    NSDictionary *censorDict = @{
                                 @"websites": @TRUE,
                                 @"profanity": @TRUE,
                                 @"emails": @TRUE
                                 };
    [input censor:censorDict];
    NSLog(@"%@",input);
    XCTAssertEqualObjects(@"**** this ************* email me at *******************", input);
}

- (void)testAllFilters {
    NSString *input = @"Fuck this www.google.ca email me at johnSmith@gmail.com";
    NSDictionary *censorDict = @{
                                 @"websites": @TRUE,
                                 @"profanity": @TRUE,
                                 @"emails": @TRUE
                                 };
    NSString *censored = [input censored: censorDict];
    XCTAssertEqualObjects(@"**** this ************* email me at *******************", censored);
}

@end
