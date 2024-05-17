//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent


struct CreateChatMember : AsyncMigration {
    var name: String { "CreateChatMemberTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("chat_members")
            .id()
            .field(.content,.string,.required)
            .field(.chat_id, .uuid, .references("chats", "id") ,.required)
            .field(.user_id, .uuid, .references("users", "id") ,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chat_members").delete()
    }
}
