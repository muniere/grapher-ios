//
//  ViewController.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import UIKit
import Apollo
import RxSwift

final class MainViewController: UIViewController {

  //
  // MARK: Props
  //
  private let viewModel = MainViewModel(token: Environment.token)
  private let disposeBag = DisposeBag()

  //
  // MARK: Event
  //
  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel.search(query: "language")
      .observeOn(MainScheduler.instance)
      .subscribe(
        onCompleted: { [weak self] () -> Void in
          self?.reloadData()
        },
        onError: { [weak self] (error: Error) -> Void in
          self?.alert(error: error)
        }
      )
      .disposed(by: self.disposeBag)
  }

  //
  // MARK: View
  //
  private func reloadData() {
    self.viewModel.repositories.forEach { print($0) }
  }

  private func alert(error: Error) {
    let vc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert).also {
      $0.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    self.present(vc, animated: true, completion: nil)
  }
}

