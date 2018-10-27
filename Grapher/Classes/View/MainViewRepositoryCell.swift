//
//  MainViewRepositoryCell.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import UIKit

public final class MainViewRepositoryCell: UICollectionViewCell {

  //
  // MARK: Props
  //
  @IBOutlet private var nameLabel: UILabel! {
    didSet {
      self.nameLabel.also {
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        $0.numberOfLines = 0
      }
    }
  }

  @IBOutlet private var languageLabel: UILabel! {
    didSet {
      self.languageLabel.also {
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.numberOfLines = 0
      }
    }
  }

  @IBOutlet private var stargazerLabel: UILabel! {
    didSet {
      self.stargazerLabel.also {
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textAlignment = .right
      }
    }
  }

  @IBOutlet private var separatorView: UIView! {
    didSet {
      self.separatorView.also {
        $0.backgroundColor = .parse(hex: "#DEDEDE")
        $0.isUserInteractionEnabled = false
      }
    }
  }

  @IBOutlet private var separatorWidthConstraint: NSLayoutConstraint!

  public override var isHighlighted: Bool {
    didSet {
      switch self.isHighlighted {
      case true:
        self.backgroundColor = .parse(hex: "#DEDEDE")
      case false:
        self.backgroundColor = .white
      }
    }
  }

  public var widthConstant: CGFloat {
    get {
      return self.separatorWidthConstraint.constant
    }
    set {
      self.separatorWidthConstraint.constant = newValue
    }
  }

  //
  // MARK: Bind
  //
  public func bind(_ data: Repository) {
    let decorator = MainViewRepositoryDecorator(rawValue: data)
    self.nameLabel.attributedText = decorator.name
    self.languageLabel.attributedText = decorator.language
    self.stargazerLabel.attributedText = decorator.stargazer
  }
}
