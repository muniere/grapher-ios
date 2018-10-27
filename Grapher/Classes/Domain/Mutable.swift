//
//  Mutable.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation

//
// MARK: For swift classes
//
public protocol Mutable: class {

  /**
   Use scoped closure and evaluate it

   - parameter f: Closure to evaluate

   - throws: Errors

   - returns: Evaluated object
   */
  func also(_ f: (Self) throws -> Void) rethrows -> Self
}

public extension Mutable {

  @discardableResult
  func also(_ f: (Self) throws -> Void) rethrows -> Self {
    try f(self)
    return self
  }
}

//
// MARK: For Foundation classes
//
public extension NSObjectProtocol {

  @discardableResult
  public func also(f: (Self) throws -> Void) rethrows -> Self {
    try f(self)
    return self
  }
}
