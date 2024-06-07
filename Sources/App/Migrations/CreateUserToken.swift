
import Foundation
import Fluent

struct CreateUserToken : AsyncMigration {
    var name: String { "CreateUserTokenTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("user_tokens")
            .id()
            .field(.value,.string,.required).unique(on: .value)
            .field(.user_id, .uuid, .references("users", "id") ,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user_tokens").delete()
    }
}
