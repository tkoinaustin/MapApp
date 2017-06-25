//
//  IntroViewController.swift
//  TKOMapApp
//
//  Created by Tom Nelson on 6/3/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
  var firstTimeThrough = true

  @IBOutlet private weak var continueButton: UIButton! { didSet {
    continueButton.backgroundColor = Palate.page1Label.value
  }}

  @IBOutlet private weak var logoLabel: UILabel!
  @IBOutlet private weak var backgroundView: UIView! { didSet {
    backgroundView.backgroundColor = Palate.page1.value
  }}
  @IBOutlet private weak var continueView: UIView!
  
  @IBAction func continueAction(_ sender: UIButton) {
    startNextSegue()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let height = view.frame.height
    let transform = CGAffineTransform(translationX: 0, y: height)
    continueView.transform = transform
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let height = view.frame.height
    
    let transform = CGAffineTransform(translationX: 0, y: -height)
    UIView.animate(withDuration: 1.5, animations: {
      self.continueView.transform = CGAffineTransform.identity
      self.logoLabel.transform = transform
    }, completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        self.startNextSegue()
      })
    })
  }
  
  private func startNextSegue() {
    guard firstTimeThrough else { return }
    firstTimeThrough = false
    if needFTUE() {
      performSegue(withIdentifier: "FTUESegue", sender: self)
    } else {
      performSegue(withIdentifier: "searchSegue", sender: nil)
    }
  }

  private func needFTUE() -> Bool {
    guard UserDefaults.standard.value(forKey: "FTUE") != nil else {
      return true
    }
    return false
  }

}
