//
//  Endpoints.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation

import PromiseKit

// Endpoints define the REST endpoints for retrieving data from the server.
// This enum is customized based on the REST service being used. Normally the
// path will have distinct endpoints based on the request.

class Endpoints {
  private enum Endpoint {
    case forward(place: String)
    case reverse(lat: String, long: String)
    
    func path() -> String {
      switch self {
      case .forward(place: _): return "/geocode/v1/json"
      case .reverse(lat: _, long: _): return "/geocode/v1/json"
      }
    }
    
    func query() -> String {
      switch self {
      case .forward(place: let place): return "q=\(Endpoints.escape(place))&key=\(API.apiKey)"
      case .reverse(lat: let lat, long: let long): return "q=\(lat)+\(long)&key=\(API.apiKey)"
      }
    }
  }
  
  static func forward(_ searchString: String) -> Promise<APIResponse> {
    let request = APIRequest(
      .get,
      path: Endpoint.forward(place: searchString).path(),
      query: Endpoint.forward(place: searchString).query())
    return API.fire(request)
  }
  
  static func reverse(lat: String, long: String) -> Promise<APIResponse> {
    let request = APIRequest(
      .get,
      path: Endpoint.reverse(lat: lat, long: long).path(),
      query: Endpoint.reverse(lat: lat, long: long).query())
    return API.fire(request)
  }
  
  static func escape(_ string: String) -> String {
    let newstring = string.replacingOccurrences(of: " ", with: "+")
    return newstring.replacingOccurrences(of: ",", with: "%2C")
  }
}
