//
//  APIRequestTests.swift
//  TKOUnitTest
//
//  Created by Tom Nelson on 5/29/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import XCTest

@testable import TKOMapApp

class APIRequestTests: XCTestCase {
  let originalURL = API.baseUrl
  
  override func setUp() {
    API.baseUrl = URLComponents(string: "https://unittest.com")!
    API.session = URLSession.shared
    super.setUp()
  }
  
  override func tearDown() {
    API.baseUrl = originalURL
    super.tearDown()
  }
  
  func testAPIRequestCreation() {
    var req = APIRequest(
      .post,
      path: "/hi/what",
      query: "",
      headers: [
        "one": "two",
        "three": "four"
      ]
    )
    
    req.body = "hi"
    
    XCTAssertEqual(String(data: req.object.httpBody!, encoding: .utf8), "hi")
    
    let headers = req.object.allHTTPHeaderFields
    
    XCTAssertEqual(headers?.count, 2)
    XCTAssertEqual(headers?["one"], "two")
    XCTAssertEqual(headers?["three"], "four")
    
    let url = API.baseUrl.url!
    
    XCTAssertEqual(req.object.url!, url)
  }
}
