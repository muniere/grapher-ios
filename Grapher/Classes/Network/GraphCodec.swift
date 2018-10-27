//
//  Codec.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation

public enum GraphCodec {

  public typealias AsRepository = SearchRepositoryQuery.Data.Search.Edge.Node.AsRepository
  public typealias AsLanguages = AsRepository.Language
  public typealias AsLanguage = AsLanguages.Edge.Node
  public typealias AsOwner = AsRepository.Owner

  public static func encode(_ data: SearchRepositoryQuery.Data) -> [Repository] {
    return (data.search.edges ?? []).compactMap { $0?.node?.asRepository }.map(self.encode)
  }

  public static func encode(_ data: AsRepository) -> Repository {
    return Repository(
      id: data.id,
      url: URL(string: data.url)!,
      name: data.name,
      owner: self.encode(data.owner),
      languages: data.languages.map(self.encode) ?? [],
      starCount: data.stargazers.totalCount
    )
  }

  public static func encode(_ data: AsOwner) -> Owner {
    return Owner(
      id: data.id,
      name: data.login,
      avatar: URL(string: data.avatarUrl)!
    )
  }

  public static func encode(_ data: AsLanguages) -> [Language] {
    return (data.edges ?? []).compactMap { $0?.node }.map(self.encode)
  }

  public static func encode(_ data: AsLanguage) -> Language {
    return Language(
      id: data.id,
      name: data.name,
      color: data.color
    )
  }
}
