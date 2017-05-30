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

class SearchViewModel {
  var places = [Location]()
  var updateUI: (() -> Void) = { }
  var showError: ((APIError) -> Void) = { _ in }
  let disposeBag = DisposeBag()
  
  init(_ searchCriteria: ControlProperty<String>) {
    searchCriteria.asObservable()
      .debounce(0.8, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { string in
        if string.isEmpty {
          self.places.removeAll()
          self.updateUI()
        } else {
          _ = self.load(string)
        }
      })
      .addDisposableTo(disposeBag)
  }

  func load(_ searchString: String) -> Promise<Void> {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    return OpenCageResults.load(searchString).then { results -> Promise<Void> in
      print(results)
      if results.places == nil {
        self.places = [Location]()
      } else {
        self.places = results.places!
      }
      
      self.updateUI()
      return Promise {fulfill, _ in
        fulfill()
      }
      }.catch { error in
        print("load error: \(error)")
        //swiftlint:disable force_cast
        self.showError(error as! APIError)
        //swiftlint:enable force_cast
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }

}
