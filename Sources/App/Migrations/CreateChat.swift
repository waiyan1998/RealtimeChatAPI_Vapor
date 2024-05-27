//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent

struct CreateChat : AsyncMigration {
    var name: String { "CreateChatTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("chats")
            .id()
            .field(.type,.string,.required)
            .field(.createdByuser_id, .uuid, .references("users", "id") ,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chats").delete()
    }
}
