//
//  SearchResultCell.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  static let Identifier = "SearchResultCell"

  var address = "" { didSet {
    fullAddressLabel.text = address
  }}
  
  @IBOutlet private weak var fullAddressLabel: UILabel!
  
  func load(_ place: Location) {
    self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    self.address = place.fullAddress
    self.accessoryType = .disclosureIndicator
  }
}
