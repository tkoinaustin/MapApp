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
  private var panelFour: UIView!

  @IBOutlet private weak var panelOneLabel: UILabel!
  @IBOutlet private weak var panelOneView: UIView!
  @IBOutlet private weak var panelTwoLabel: UILabel!
  @IBOutlet private weak var panelThreeLabel: UILabel!
  
  @IBOutlet fileprivate weak var panelsView: UIScrollView! { didSet {
    panelsView.delegate = self
    }}
  @IBOutlet fileprivate weak var pageControl: UIPageControl!
  
  @IBAction func userPaged(_ sender: UIPageControl) {

  }

  var panelWidth: CGFloat!
  var page1Offset: CGFloat!
  var page2Offset: CGFloat!
  var page3Offset: CGFloat!
  var page4Offset: CGFloat!
  var pageControlDone: CGFloat!
  
  override func viewDidLoad() {
    panelFour = searchView().view
    setSizes()
    addPanels()
    
    super.viewDidLoad()
  }
  
  private func setSizes() {
    let height = UIScreen.main.bounds.height

    panelWidth = UIScreen.main.bounds.width
    page2Offset = panelWidth
    page3Offset = 2 * panelWidth
    page4Offset = 3 * panelWidth
    pageControlDone = 2.5 * panelWidth + 1

    panelsView.frame = CGRect(x: 0, y: 0, width: panelWidth, height: height)
    panelOne.frame = CGRect(x: 0, y: 0, width: panelWidth, height: height)
    panelTwo.frame = CGRect(x: page2Offset, y: 0, width: panelWidth, height: height)
    panelThree.frame = CGRect(x: page3Offset, y: 0, width: panelWidth, height: height)
    panelFour.frame = CGRect(x: page4Offset, y: 0, width: panelWidth, height: height)
}
  
  private func addPanels() {
    let height = UIScreen.main.bounds.height
    
    panelsView.addSubview(panelOne)
    panelOneLabel.backgroundColor = Palate.page1Label.color.value
    panelsView.addSubview(panelTwo)
    panelTwoLabel.backgroundColor = Palate.page2Label.color.value
    panelsView.addSubview(panelThree)
    panelThreeLabel.backgroundColor = Palate.page3Label.color.value
    panelsView.addSubview(panelFour)
    
    panelsView.contentSize = CGSize(
      width: panelWidth * CGFloat(pageControl.numberOfPages),
      height: height
    )
    
    panelsView.backgroundColor = Palate.page1Label.color.value
  }
 
  func searchView() -> UIViewController {
    return UIStoryboard(name: "SearchView", bundle: nil).instantiateViewController(withIdentifier: "searchView")
  }

  fileprivate func isLastPage(_ currentPage: Int) -> Bool {
    return currentPage == (pageControl.numberOfPages - 1)
  }
  
  func blend(_ to: Color, into from: Color, amount: CGFloat) -> UIColor {
    let red = from.red * (1 - amount) + to.red * amount
    let green = from.green * (1 - amount) + to.green * amount
    let blue = from.blue * (1 - amount) + to.blue * amount
    let alpha = from.alpha * (1 - amount) + to.alpha * amount
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
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
      
      UserDefaults.standard.set(false, forKey: "FTUE")
      UIApplication.shared.keyWindow?.rootViewController = navController
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      var alpha: CGFloat
      let offset = panelsView.contentOffset.x
      print ("offset is \(offset), page is \(pageControl.currentPage)")
      
      switch panelsView.contentOffset.x {
      case -CGFloat.greatestFiniteMagnitude..<0: ()
        
      case 0..<page2Offset:
        let color = self.blend(Palate.page2.color, into: Palate.page1.color, amount: (offset / panelWidth))
        panelsView.backgroundColor = color
        
      case page2Offset..<page3Offset:
        let color = self.blend(Palate.page3.color,
                               into: Palate.page2.color,
                               amount: ((offset - panelWidth) / panelWidth))
        panelsView.backgroundColor = color
        
      case pageControlDone...CGFloat.greatestFiniteMagnitude: pageControl.alpha = 0
        
      case page3Offset..<pageControlDone:
        alpha = 1 - (panelsView.contentOffset.x - page3Offset) / (panelWidth / 2)
        print ("alpha is \(Int(100 * alpha))")
        pageControl.alpha = alpha
        
      default: ()
      }
    }
}
