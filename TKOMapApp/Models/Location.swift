//
//  Location.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

// This class provides a structure for holding location data for the Open Cage results
// data set. Using SwiftyJSON, we just plop the data into a JSON data blob and extract 
//  the elements we need by keying into the data

class Location {
  let data: JSON
  
  required init? (from data: JSON) {
    guard data.dictionary != nil else { return nil }
    
    self.data = data
  }
  
  var mapUrl: String { return data["annotations"]["OSM"]["url"].stringValue }
  var fullAddress: String { return data["formatted"].stringValue }
  var geolocation: CLLocation? {
    guard let lat =  data["geometry"]["lat"].double  else { return nil }
    guard let long = data["geometry"]["lng"].double else { return nil }
    
    return CLLocation(latitude: lat, longitude: long)
  }
}
