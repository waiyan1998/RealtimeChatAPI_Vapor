
import Foundation
import Fluent

struct CreateChat : AsyncMigration {
    var name: String { "CreateChatTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("chats")
            .id()
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chats").delete()
    }
}
