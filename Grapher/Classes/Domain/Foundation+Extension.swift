//
//  Extensions.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/28.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation

public extension Collection where Self.Element == NSAttributedString {

  public func joined(separator: NSAttributedString) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    let lastIndex = self.count - 1

    self.enumerated().forEach { (index: Int, element: NSAttributedString) in
      result.append(element)
      if index != lastIndex {
        result.append(separator)
      }
    }

    return result
  }
}
