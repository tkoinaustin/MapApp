//
//  SearchResultCell.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  
  var address = "" { didSet {
    fullAddressLabel.text = address
  }}
  
  @IBOutlet private weak var fullAddressLabel: UILabel!
}
