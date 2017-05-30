//
//  SearchDataProvider.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class SearchDataProvider: NSObject, UITableViewDataSource {
  private let cellIdentifier = "SearchResultCell"
  weak var viewModel: SearchViewModel!
  
  func registerCells(for tableView: UITableView) {
    let resultsCell = String(describing: SearchResultCell.self)
    tableView.register(UINib(nibName: resultsCell, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("viewModel.places.count = \(viewModel.places.count)")
    return viewModel.places.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                             for: indexPath)
    
        if let cell = cell as? SearchResultCell {
          let place = viewModel.places[indexPath.row]
          cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
          cell.fullAddressLabel.text = place.fullAddress
          cell.accessoryType = .disclosureIndicator
        }
    cell.selectionStyle = .none
    
    return cell
  }
}