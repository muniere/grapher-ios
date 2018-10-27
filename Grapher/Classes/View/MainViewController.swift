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

public final class MainViewController: UIViewController {

  //
  // MARK: Props
  //
  private lazy var collectionView = self.makeCollectionView()
  private lazy var activityIndicator = self.makeActivityIndicator()

  private let viewModel = MainViewModel(token: Environment.token)
  private let disposeBag = DisposeBag()

  //
  // MARK: Event
  //
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.bootstrapViews()
    self.bootstrapData()
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    self.collectionView.collectionViewLayout.invalidateLayout()
  }

  //
  // MARK: Bootstrap
  //
  private func bootstrapViews() {
    self.title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    
    self.view.addSubview(self.collectionView)
    self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    self.view.addSubview(self.activityIndicator)
    self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
  }

  private func bootstrapData() {
    self.activityIndicator.startAnimating()

    self.viewModel
      .search(query: "language")
      .observeOn(MainScheduler.instance)
      .do(
        onError: { [weak self] _ in
          self?.activityIndicator.stopAnimating()
        },
        onCompleted: { [weak self] in
          self?.activityIndicator.stopAnimating()
        }
      )
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
  // MARK: Factory
  //
  private func makeCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout().also {
      $0.scrollDirection = UICollectionView.ScrollDirection.vertical
      $0.itemSize = UICollectionViewFlowLayout.automaticSize
      $0.estimatedItemSize = CGSize(width: self.view.bounds.width, height: 44.0)
      $0.minimumLineSpacing = 0.0
      $0.minimumInteritemSpacing = 0.0
    }

    return UICollectionView(frame: self.view.bounds, collectionViewLayout: layout).also {
      $0.delegate = self
      $0.dataSource = self
      $0.backgroundColor = UIColor.clear
      $0.registerNib(forClass: MainViewRepositoryCell.self)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }

  private func makeActivityIndicator() -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: .gray).also {
      $0.hidesWhenStopped = true
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
    }
  }

  //
  // MARK: View
  //
  private func reloadData() {
    self.collectionView.reloadData()
  }

  private func alert(error: Error) {
    let vc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert).also {
      $0.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    self.present(vc, animated: true, completion: nil)
  }
}

//
// MARK: - UICollectionViewDataSource
//
extension MainViewController: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.viewModel.repositories.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withClass: MainViewRepositoryCell.self, for: indexPath).also {
      $0.bind(self.viewModel.repositories[indexPath.item])
    }
  }
}

//
// MARK: - UICollectionViewDelegate
//
extension MainViewController: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch cell {
    case let cell as MainViewRepositoryCell:
      cell.widthConstant = collectionView.bounds.width
    default:
      break
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let repository = self.viewModel.repositories[indexPath.item]

    UIApplication.shared.open(repository.url, options: [:], completionHandler: nil)
  }
}
