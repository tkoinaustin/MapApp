//
//  Color.swift
//  TKOMapApp
//
//  Created by Tom Nelson on 6/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

struct Color {
  var red: CGFloat = 1
  var green: CGFloat = 1
  var blue: CGFloat = 1
  var alpha: CGFloat = 1
  
  var value: UIColor {
    return UIColor.init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
  }
}

enum Palate {
  case page1, page2, page3, page1Label, page2Label, page3Label
  
  var value: UIColor {
    switch self {
    case .page1: return Palate.page1.color.value
    case .page2: return Palate.page2.color.value
    case .page3: return Palate.page3.color.value
    case .page1Label: return Palate.page1Label.color.value
    case .page2Label: return Palate.page2Label.color.value
    case .page3Label: return Palate.page3Label.color.value
    }
  }
  
  var color: Color {
    switch self {
    case .page1: return Color(red: 148 / 255, green: 183 / 255, blue: 224 / 255, alpha: 0.15)
    case .page2: return Color(red: 210 / 255, green: 177 / 255, blue: 224 / 255, alpha: 0.15)
    case .page3: return Color(red: 235 / 255, green: 157 / 255, blue: 112 / 255, alpha: 0.1)
    case .page1Label: return Color(red: 148 / 255, green: 183 / 255, blue: 224 / 255, alpha: 0.25)
    case .page2Label: return Color(red: 210 / 255, green: 177 / 255, blue: 224 / 255, alpha: 0.25)
    case .page3Label: return Color(red: 235 / 255, green: 157 / 255, blue: 112 / 255, alpha: 0.2)
    }
  }
}
