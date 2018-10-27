//
//  GraphClient.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation
import Apollo
import RxSwift

public final class GraphClient {

  //
  // MARK: Error
  //
  public enum APIError: Swift.Error {
    case errors([GraphQLError])
  }

  //
  // MARK: Props
  //
  private lazy var delegate = self.makeDelegate()

  private let token: String

  //
  // MARK: Init
  //
  public init(token: String) {
    self.token = token
  }

  //
  // MARK: Request
  //
  public func fetch<T: GraphQLQuery>(query: T) -> Single<T.Data> {
    return Single.create { (emitter: @escaping (SingleEvent<T.Data>) -> ()) -> Disposable in
      let c = self.delegate.fetch(query: query) { (result: GraphQLResult<T.Data>?, error: Error?) in
        if let error = error {
          emitter(.error(error))
          return
        }
        if let result = result, let data = result.data {
          emitter(.success(data))
          return
        }
        if let result = result, let errors = result.errors {
          emitter(.error(APIError.errors(errors)))
        }
      }
      return Disposables.create {
        c.cancel()
      }
    }
  }

  //
  // MARK: Helper
  //
  private func makeDelegate() -> ApolloClient {
    let url = URL(string: "https://api.github.com/graphql")!

    let configuration = URLSessionConfiguration.default.also {
      $0.httpAdditionalHeaders = ["Authorization": "Bearer \(self.token)"]
    }

    return ApolloClient(
      networkTransport: HTTPNetworkTransport(url: url, configuration: configuration)
    )
  }
}
