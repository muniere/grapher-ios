//
//  UIKit+Extension.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/28.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {

  public static func parse(hex: String) -> UIColor {
    let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var i = UInt32()
    Scanner(string: s).scanHexInt32(&i)

    let (a, r, g, b): (UInt32, UInt32, UInt32, UInt32) = {
      switch s.count {
      case 3: // RGB (12-bit)
        return (255, (i >> 8) * 17, (i >> 4 & 0xF) * 17, (i & 0xF) * 17)
      case 6: // RGB (24-bit)
        return (255, i >> 16, i >> 8 & 0xFF, i & 0xFF)
      case 8: // ARGB (32-bit)
        return (i >> 24, i >> 16 & 0xFF, i >> 8 & 0xFF, i & 0xFF)
      default:
        return (255, 0, 0, 0)
      }
    }()

    return UIColor(
      red: CGFloat(r) / 255,
      green: CGFloat(g) / 255,
      blue: CGFloat(b) / 255,
      alpha: CGFloat(a) / 255
    )
  }
}

public extension UICollectionView {

  public func registerNib<T: UICollectionViewCell>(forClass: T.Type) {
    self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
  }

  public func dequeueReusableCell<T: UICollectionViewCell>(withClass clazz: T.Type, for indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
  }
}
