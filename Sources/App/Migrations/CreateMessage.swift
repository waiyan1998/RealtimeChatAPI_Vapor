

import Foundation
import Fluent

struct CreateMessage : AsyncMigration {
    var name: String { "CreateMessageTable" }
    
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .id()
            .field(.content,.string,.required)
            .field(.sender_id , .uuid ,.references("users", "id") , . required)
            .field(.chat_id , .uuid ,.references("chats", "id") , . required)
            .field(.created_at,.datetime,.required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("messages").delete()
    }
}


