//
//  Repository.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Repository {
    let id: String
    let name: String
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String
    let createdAt: Date
    let updatedAt: Date
    let owner: User
}

extension Repository: Decodable {
    init(data: Any) throws {
        try self.init(jsonData: JSON(data))
    }
    init(jsonData: JSON) throws {
        self.id = jsonData["id"].stringValue
        self.name = jsonData["name"].stringValue
        self.watchersCount = jsonData["watchers_count"].intValue
        self.forksCount = jsonData["forks_count"].intValue
        self.openIssuesCount = jsonData["open_issues_count"].intValue
        self.language = jsonData["language"].stringValue
        self.createdAt = try jsonData["created_at"].dateOrThrow()
        self.updatedAt = try jsonData["updated_at"].dateOrThrow()
        self.owner = try User(jsonData: jsonData["owner"])
    }
}
