//
//  DetailViewController.swift
//  TKOOpenCage
//
//  Created by Tom Nelson on 5/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
  
  private var location: Location!
  fileprivate var webView: WKWebView!
  
  @IBOutlet fileprivate weak var mapView: UIView! { didSet {
    mapView.layer.cornerRadius = 6.5
    mapView.layer.borderWidth = 0.5
    mapView.layer.borderColor = UIColor.blue.cgColor
    mapView.clipsToBounds = true
  }}
  
  @IBOutlet fileprivate weak var answerLabel: UILabel!

  @IBOutlet fileprivate weak var activityView: UIActivityIndicatorView! { didSet {
    activityView.hidesWhenStopped = true
    activityView.stopAnimating()
  }}
  
  @IBOutlet private weak var backButton: UIButton! { didSet {
    backButton.tintColor = Palate.page1.value.withAlphaComponent(1)
  }}
  
  @IBOutlet private weak var addressLabel: UILabel! { didSet {
    addressLabel.text = location.fullAddress
  }}

  @IBOutlet private weak var tintView: UIView! { didSet {
    tintView.backgroundColor = Palate.page1.value
  }}

  @IBOutlet private weak var locationLabel: UILabel! { didSet {
    let lat = location.geolocation?.coordinate.latitude.description
    let long = location.geolocation?.coordinate.longitude.description
    locationLabel.text = "Latitude: \(lat ?? "no latitude")\nLongitude: \(long ?? "no longitude")"
  }}

  @IBAction func dismissAction(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  func setlocation(_ location: Location) {
    self.location = location
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView = WKWebView(frame: self.mapView.bounds)
    guard let url = URL(string: location.mapUrl) else { return }
    let urlRequest = URLRequest(url: url)
    self.activityView.startAnimating()

    webView.load(urlRequest)
    webView.navigationDelegate = self
    mapView.addSubview(webView)
  }

  func showConnectionProblems(_ desc: String) {
    let alertViewController = UIAlertController(title: "Error", message: desc, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel)
    alertViewController.addAction(action)
    
    self.present(alertViewController, animated: true)
  }
}

extension DetailViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    UIView.animate(withDuration: 0.3, animations: {
      self.answerLabel.alpha = 1.0
    })
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityView.stopAnimating()
  }

  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    activityView.stopAnimating()
    showConnectionProblems(error.localizedDescription)
  }
}
