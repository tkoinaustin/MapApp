//
//  SearchViewController.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/26/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  fileprivate lazy var viewModel: SearchViewModel = {
    return SearchViewModel(searchCriteria: self.searchBar.rx.text.orEmpty.asObservable(),
                           searchClick: self.searchBar.rx.searchButtonClicked.asObservable(),
                           cancelClick: self.searchBar.rx.cancelButtonClicked.asObservable())
  }()
  
  @IBOutlet private weak var imageView: UIImageView! { didSet {
    imageView.backgroundColor = UIColor.red //Palate.page1.value.withAlphaComponent(1)
  }}
  
  @IBOutlet fileprivate weak var searchBar: UISearchBar! { didSet {
    searchBar.barTintColor = Palate.page1Label.value
    let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject],
                                                        for: UIControlState.normal)
  }}

  @IBOutlet private weak var tableView: UITableView! { didSet {
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorColor = Palate.page1.value.withAlphaComponent(1)
    
    let resultCell = String(describing: SearchResultCell.self)
    tableView.register(UINib(nibName: resultCell, bundle: Bundle.main),
                       forCellReuseIdentifier: SearchResultCell.Identifier)
    
    viewModel.places.asObservable()
      .bind(to: self.tableView
        .rx
        .items(cellIdentifier: SearchResultCell.Identifier,
               cellType: SearchResultCell.self)) { _, place, cell in
                cell.load(place)
      }
      .addDisposableTo(disposeBag)

    tableView
    .rx
    .modelSelected(Location.self)
      .subscribe(onNext: { place in
        self.searchBar.endEditing(true)
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
        
        self.performSegue(withIdentifier: "detailViewSegue", sender: place)
      })
    .addDisposableTo(disposeBag)
  }}

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    viewModel.showError = showConnectionProblems
    
    viewModel.endEditing
      .drive(onNext: { [weak self] _ in
        self?.searchBar.endEditing(true)
      })
    .addDisposableTo(disposeBag)
  }
  
  func showConnectionProblems(_ error: APIError) {
    let desc = error.desc()
    let alertViewController = UIAlertController(title: "Error", message: desc, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel)
    alertViewController.addAction(action)
    
    self.searchBar.endEditing(true)
    self.present(alertViewController, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let detailViewController = segue.destination as? DetailViewController else { return }
    guard let location = sender as? Location else { return }
    detailViewController.setlocation(location)
  }
}
