//
//  RepositorySearchResult.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RepositorySearchResult {
    let totalCount: Int
    let items: [Repository]
}

extension RepositorySearchResult: Decodable {
    init() {
        self.totalCount = -1
        self.items = [Repository]()
    }
    init(data: Any) throws {
        let jsonData = JSON(data)
        self.totalCount = jsonData["total_count"].intValue
        self.items = try jsonData["items"].arrayValue.map { try Repository(jsonData: $0) }
    }
}
