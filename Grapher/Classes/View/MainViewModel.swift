//
//  MainViewModel.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation
import Apollo
import RxSwift

public final class MainViewModel {

  //
  // MARK: Props
  //
  public private(set) var repositories: [Repository] = []

  private let client: GraphClient

  //
  // MARK: Init
  //
  public init(token: String) {
    self.client = GraphClient(token: token)
  }

  //
  // MARK: Network
  //
  public func search(query: String) -> Completable {
    return self.client
      .fetch(query: SearchRepositoryQuery(query: query))
      .do(onSuccess: { [weak self] in
        guard let self = self else { return }
        self.repositories = GraphCodec.encode($0)
      })
      .asCompletable()
  }
}
