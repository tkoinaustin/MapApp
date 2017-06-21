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

  @IBOutlet private weak var continueButton: UIButton!
  @IBOutlet private weak var logoLabel: UILabel!
  
  @IBAction func continueAction(_ sender: UIButton) {
    startNextSegue()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let height = view.frame.height
    let transform = CGAffineTransform(translationX: 0, y: height)
    continueButton.transform = transform
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let height = view.frame.height
    
    let transform = CGAffineTransform(translationX: 0, y: -height)
    UIView.animate(withDuration: 1.5, animations: {
      self.continueButton.transform = CGAffineTransform.identity
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
      UserDefaults.standard.set(false, forKey: "FTUE")
      performSegue(withIdentifier: "FTUESegue", sender: self)
    } else {
      performSegue(withIdentifier: "searchSegue", sender: nil)
    }
  }

  private func needFTUE() -> Bool {
    guard UserDefaults.standard.value(forKey: "FTUE") != nil else { return true }
    return false
  }

}
