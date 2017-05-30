//
//  APITests.swift
//  TKOUnitTest
//
//  Created by Tom Nelson on 5/29/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import TKOMapApp

class APITests: XCTestCase {
  var smokeRequest: APIRequest { return APIRequest(.get, path: "/smoke", query: "") }
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
  
  func testAPIFireSuccess200() {
    let async = expectation(description: "async")
    
    stub(condition: isPath("/smoke")) { _ in
      let obj = ["status": "ok"]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
    }
    
    _ = API.fire(smokeRequest).then { response -> Void in
      XCTAssertEqual(response.body["status"], "ok")
      async.fulfill()
    }
    
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testAPIFireFailure401() {
    let async = expectation(description: "async")
    
    stub(condition: isPath("/smoke")) { _ in
      let obj = ["status": "notok"]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 401, headers: nil)
    }
    
    API.fire(smokeRequest).then { _ -> Void in
      }.catch { error in
        XCTAssertEqual(error as? APIError, APIError.request)
        async.fulfill()
    }
    
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testAPIFireFailure503() {
    let async = expectation(description: "async")
    
    stub(condition: isPath("/smoke")) { _ in
      let obj = ["status": "notok"]
      return OHHTTPStubsResponse(jsonObject: obj, statusCode: 503, headers: nil)
    }
    
    API.fire(smokeRequest).then { _ -> Void in
      }.catch { error in
        XCTAssertEqual(error as? APIError, APIError.server)
        async.fulfill()
    }
    
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testAPIFireFailure() {
    let async = expectation(description: "async")
    
    stub(condition: isPath("/smoke")) { _ in
      return OHHTTPStubsResponse(error: APIError.generic)
    }
    
    API.fire(smokeRequest).then { _ -> Void in
      }.catch { error in
        XCTAssertEqual(error as? APIError, APIError.generic)
        async.fulfill()
    }
    
    waitForExpectations(timeout: 2, handler: nil)
  }
}
