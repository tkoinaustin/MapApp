//
//  SearchViewModel.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/26/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import RxCocoa

// This class manages the display data for SearchViewController

class SearchViewModel {
  static var waiting = false
  var places = [Location]()
  var updateUI: (() -> Void) = { }
  var showError: ((APIError) -> Void) = { _ in }
  let disposeBag = DisposeBag()
  
  init(_ searchCriteria: ControlProperty<String>) {
    searchCriteria.asObservable()
      .distinctUntilChanged()
      .subscribe(onNext: { string in
        if string.isEmpty {
          self.places.removeAll()
          self.updateUI()
        }
      })
      .addDisposableTo(disposeBag)
  }

  func load(_ searchString: String) -> Promise<Void> {
    guard !SearchViewModel.waiting else { return Promise { fulfill, _ in fulfill() } }
    SearchViewModel.waiting = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { SearchViewModel.waiting = false } )

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    return OpenCageResults.load(searchString).then { results -> Promise<Void> in
      if results.places == nil {
        self.places = [Location]()
      } else {
        self.places = results.places!
      }
      
      self.updateUI()
      if self.places.count == 0 {
        self.showError(APIError.noResults)
      }
      return Promise {fulfill, _ in
        fulfill()
      }
      }.catch { error in
        //swiftlint:disable force_cast
        self.showError(error as! APIError)
        //swiftlint:enable force_cast
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }

}
