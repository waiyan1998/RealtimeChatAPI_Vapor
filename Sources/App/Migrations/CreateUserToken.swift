//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent

struct CreateUserToken : AsyncMigration {
    var name: String { "CreateUserTokenTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("user_tokens")
            .id()
            .field(.value,.string,.required)
            .field(.user_id, .uuid, .references("users", "id") ,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user_tokens").delete()
    }
}
