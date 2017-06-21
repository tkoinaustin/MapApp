//
//  FTUEViewController.swift
//  TKOMapApp
//
//  Created by Tom Nelson on 6/3/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController {
  @IBOutlet private var panelOne: UIView!
  @IBOutlet private var panelTwo: UIView!
  @IBOutlet private var panelThree: UIView!
  
  @IBOutlet fileprivate weak var panelsView: UIScrollView! { didSet {
    panelsView.delegate = self
    }}
  @IBOutlet fileprivate weak var pageControl: UIPageControl!
  
  @IBAction func userPaged(_ sender: UIPageControl) {

  }

  var offsetStart: CGFloat!
  var offsetFinish: CGFloat!
  
  override func viewDidLoad() {
    addPanels()
    
    super.viewDidLoad()
  }
  
  private func addPanels() {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let search = self.searchView()
    offsetStart = 2 * width
    offsetFinish = 2.5 * width + 1
    
    panelsView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    panelOne.frame = CGRect(x: 0, y: 0, width: width, height: height)
    panelTwo.frame = CGRect(x: width, y: 0, width: width, height: height)
    panelThree.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
    search.view.frame = CGRect(x: width * 3, y: 0, width: width, height: height)
    
    panelsView.addSubview(panelOne)
    panelsView.addSubview(panelTwo)
    panelsView.addSubview(panelThree)
    panelsView.addSubview(search.view)
    
    panelsView.contentSize = CGSize(
      width: width * CGFloat(pageControl.numberOfPages),
      height: height
    )
  }
 
  func searchView() -> UIViewController {
    return UIStoryboard(name: "SearchView", bundle: nil).instantiateViewController(withIdentifier: "searchView")
  }

  fileprivate func isLastPage(_ currentPage: Int) -> Bool {
    return currentPage == (pageControl.numberOfPages - 1)
  }
}

  extension FTUEViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      let width = UIScreen.main.bounds.width
      let page = floor(panelsView.contentOffset.x / width)
      pageControl.currentPage = Int(page)
      
      guard isLastPage(pageControl.currentPage) else { return }
      
      guard let navController = UIStoryboard(name: "SearchView", bundle: nil)
        .instantiateInitialViewController() else { return }
      UIApplication.shared.keyWindow?.rootViewController = navController
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      var alpha: CGFloat
      
      switch panelsView.contentOffset.x {
      case offsetFinish...CGFloat.greatestFiniteMagnitude: pageControl.alpha = 0
      case offsetStart..<offsetFinish:
        alpha = 1 - (panelsView.contentOffset.x - offsetStart) / (offsetStart / 4)
        pageControl.alpha = alpha
      default: ()
      }
    }
}
