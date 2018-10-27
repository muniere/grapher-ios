//
//  MainViewRepositoryDecorator.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/28.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation
import UIKit

public final class MainViewRepositoryDecorator {

  //
  // MARK: Props
  //
  private static var starCountFormatter = NumberFormatter().also {
    $0.numberStyle = .decimal
    $0.maximumFractionDigits = 0
  }

  private let rawValue: Repository

  //
  // MARK: Init
  //
  public init(rawValue: Repository) {
    self.rawValue = rawValue
  }

  //
  // MARK: Export
  //
  public var name: NSAttributedString {
    let text = String(format: "%@ / %@", self.rawValue.owner.name, self.rawValue.name)
    return NSAttributedString(string: text)
  }

  public var language: NSAttributedString {
    let languages =  self.rawValue.languages.prefix(5).map(self.makeLanguage)
    return languages.joined(separator: NSAttributedString(string: " "))
  }

  public var stargazer: NSAttributedString {
    let countNumber = NSNumber(value: self.rawValue.starCount)
    let countText = type(of: self).starCountFormatter.string(from: countNumber) ?? "-"
    return NSAttributedString(string: String(format: "%@ Stars", countText))
  }

  //
  // MARK: Helper
  //
  private func makeLanguage(for language: Language) -> NSAttributedString {
    return NSMutableAttributedString().also {
      $0.append(self.makeLegend(for: language))
      $0.append(self.makeSpacer(for: language))
      $0.append(self.makeName(for: language))
    }
  }

  private func makeLegend(for language: Language) -> NSAttributedString {
    guard let color = language.color else {
      return NSAttributedString(string: "□")
    }

    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.parse(hex: color)
    ]

    return NSAttributedString(string: "■", attributes: attributes)
  }

  private func makeSpacer(for language: Language) -> NSAttributedString {
    return NSAttributedString(string: " ")
  }

  private func makeName(for language: Language) -> NSAttributedString {
    return NSAttributedString(string: language.name)
  }
}
