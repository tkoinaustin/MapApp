//
//  EndpointTest.swift
//  TKOUnitTest
//
//  Created by Tom Nelson on 5/29/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import TKOMapApp

class EndpointTests: XCTestCase {
  let originalURL = API.baseUrl
  
  override func setUp() {
    API.baseUrl = URLComponents(string: "https://example.com")!
    API.session = URLSession.shared
    super.setUp()
  }
  
  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    API.baseUrl = originalURL
    super.tearDown()
  }
  
  func testForward() {
    let async = expectation(description: "async")
    
    stub(condition: isPath("/geocode/v1/json")) { _ in
      let path = OHPathForFileInBundle("forward-200.response", Bundle(for: type(of: self)))!
      let raw = try? String(contentsOfFile: path)
      return OHHTTPStubsResponse(httpMessageData: raw!.data(using: .utf8)!)
    }
    
    Endpoints.forward("Buda").then { response -> Void in
      XCTAssertNotNil(response.body.dictionary)
      async.fulfill()
      }.catch { _ in }
    
    waitForExpectations(timeout: 200, handler: nil)
  }
}
