//
//  Repository.swift
//  Grapher
//
//  Created by Hiromune Ito on 2018/10/27.
//  Copyright © 2018 Hiromune Ito. All rights reserved.
//

import Foundation

public struct Repository {
  public let id: String
  public let url: URL
  public let name: String
  public let owner: Owner
  public let languages: [Language]
  public let starCount: Int
}
