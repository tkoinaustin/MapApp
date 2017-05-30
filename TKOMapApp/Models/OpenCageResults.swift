//
//  OpenCageResults.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

enum ModelError: Error {
  case invalidData
}

// This class is responsible for loading the data into the results class. The 
// class also loads the array of location results using SwiftyJSONs arrayValue.
// Once the class is full formed, it is returned in a promise to SearchViewModel. 

class OpenCageResults {
  let data: JSON
  let places: [Location]?
  
  var remaining: Int { return data["rate"]["remaining"].intValue }
  
  required init?(from data: JSON) {
    guard data.dictionary != nil else { return nil }
    
    self.data = data
    
    var locations = [Location]()
    for location in self.data["results"].arrayValue {
      if let place = Location(from: location) {
        locations.append(place)
      }
    }
    self.places = locations
  }

  static func load(_ location: String) -> Promise<OpenCageResults> {
    return Endpoints.forward(location).then(on: DispatchQueue.global(qos: .background)) { response in
      return Promise<OpenCageResults> { fulfill, reject in
        guard let openCageResults = OpenCageResults(from: response.body) else { return reject(ModelError.invalidData) }
        return fulfill(openCageResults)
      }
    }
  }
}
