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
    return SearchViewModel(self.searchBar.rx.text.orEmpty)
  }()
  
  let provider = SearchDataProvider()
  
  @IBOutlet fileprivate weak var searchBar: UISearchBar! { didSet {
    let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject],
                                                        for: UIControlState.normal)
  }}

  @IBOutlet private weak var tableView: UITableView! { didSet {
    tableView.dataSource = provider
    tableView.delegate = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
  }}

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    viewModel.updateUI = { self.tableView.reloadData() }
    viewModel.showError = showConnectionProblems
    provider.viewModel = viewModel
    provider.registerCells(for: self.tableView)

    searchBar.rx.cancelButtonClicked.asObservable()
      .subscribe(onNext: { _ in
        self.searchBar.endEditing(true)
      })
    .addDisposableTo(disposeBag)
    
    searchBar.rx.searchButtonClicked
      .subscribe(onNext: { _ in
        _ = self.viewModel.load(self.searchBar.text!)
        self.searchBar.endEditing(true)
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

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.searchBar.endEditing(true)
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: "detailViewSegue", sender: self.viewModel.places[indexPath.row])
    }
  }
}
