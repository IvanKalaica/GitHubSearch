//
//  User.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let id: String
    let username: String
    let name: String
    let avatarUrl: String
    let createdAt: Date?
    let company: String?
    let email: String?
}

extension User: Decodable {
    init(data: Any) throws {
        try self.init(jsonData: JSON(data))
    }
    init(jsonData: JSON) throws {
        self.id = jsonData["id"].stringValue
        self.username = jsonData["login"].stringValue
        self.name = jsonData["name"].stringValue
        self.avatarUrl = jsonData["avatar_url"].stringValue
        self.createdAt = try jsonData["created_at"].dateOptionalOrThrow()
        self.company = jsonData["company"].string
        self.email = jsonData["email"].string
    }
}
