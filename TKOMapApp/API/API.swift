//
//  API.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import ReachabilitySwift

// API class and its helpers are the main network access for retreiving data.
// This class shouldn't change (except baseUrl), Endpoints is reponsible
// for tayloring the request to the REST API specifics

struct APIResponse {
  let raw: HTTPURLResponse
  let body: JSON
}

enum HTTPMethod: String {
  case get
  case post
  case put
  case delete
}

enum APIError: Error {
  case generic
  case body
  case request
  case server
  case reachability
  case badkey
  case noResults
  
  func desc() -> String {
    switch self {
    case .generic: return "Generic API Error"
    case .body: return "Error with API body Error"
    case .request: return "Error with API request Error"
    case .server: return "Server Error"
    case .reachability: return "Network is unreachable, check network settings"
    case .badkey: return "OpenCage API key problem"
    case .noResults: return "The query returned no results"
    }
  }
}

struct APIRequest {
  var object: URLRequest
  
  var body: String = "" { didSet {
    object.httpBody = body.data(using: .utf8)
    }}
  
  init(_ method: HTTPMethod, path: String, query: String, headers: [String : String] = [String: String]()) {
    API.baseUrl.path = path
    API.baseUrl.query = query
    let url = API.baseUrl.url!
    self.object = URLRequest(url: url)
    self.object.httpMethod = method.rawValue
    self.object.httpBody = body.data(using: .utf8)
    
    for (key, value) in headers {
      self.object.addValue(value, forHTTPHeaderField: key)
    }
  }
}

class API {
  static var baseUrl = URLComponents(string: "https://api.opencagedata.com")!
  
  static var apiKey = { () -> String in
    guard let fileUrl = Bundle.main.url(forResource: "APIinfo", withExtension: "plist")
      else { return "bad file" }
    let dictionary =  NSDictionary(contentsOf: fileUrl) as? [String: String]
    guard let dict = dictionary else { return "bad dictionary" }
      return dict["OpenCageAPIKey"] ?? "bad key"
  }()
  
  static var session = URLSession.shared
  
  static func fire(_ request: APIRequest) -> Promise<APIResponse> {
    guard validateKey(API.apiKey) else {
      return Promise<APIResponse> { _, reject in reject(APIError.badkey) }
    }
    guard onLine() else {
      return Promise<APIResponse> { _, reject in reject(APIError.reachability) }
    }
    
    return Promise<APIResponse> { fulfill, reject in
      
      session.dataTask(with: request.object) { data, response, error in
        
        if let error = error { return reject(error) }
        guard let data = data else { return reject(APIError.body) }
        guard let httpResponse = response as? HTTPURLResponse else { return reject(APIError.generic) }
        
        switch httpResponse.statusCode {
        case 400...499: return reject(APIError.request)
        case 500...599: return reject(APIError.server)
        default: return fulfill(APIResponse(raw: httpResponse, body: JSON(data: data)))
        }
        }.resume()
    }
  }
  
  static func validateKey(_ key: String) -> Bool {
    do {
      var regex = try NSRegularExpression(pattern: "[0-9a-f]")
      let nsString = key as NSString
      var results = regex.matches(in: key, range: NSRange(location: 0, length: nsString.length))
      // Need to validate if there are length specifics for the API key
      guard results.count > 25 else { return false }
      
      regex = try NSRegularExpression(pattern:"\\s")
      results = regex.matches(in: key, range: NSRange(location: 0, length: nsString.length))
      guard results.isEmpty else { return false }
      
      return true
      
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return false
    }
  }
  
  static func onLine() -> Bool {
    guard let reachability = Reachability() else { return false }
    return reachability.isReachable
  }
}
