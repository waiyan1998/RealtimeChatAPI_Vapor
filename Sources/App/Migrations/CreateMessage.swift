//
//  Message.swift
//
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent

struct CreateMessage : AsyncMigration {
    var name: String { "CreateMessageTable" }
    
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .id()
            .field(.content,.string,.required)
            .field(.chat_id, .uuid, .references("chats", "id") ,.required)
            .field(.user_id, .uuid, .references("users", "id") ,.required)
            .field(.recipient_id,.uuid , .references("users", "id"))
            .field(.created_at,.datetime,.required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("messages").delete()
    }
}

