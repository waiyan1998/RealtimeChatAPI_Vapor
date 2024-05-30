//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 30/05/2024.
//

import Foundation
import Fluent

struct CreatePresence : AsyncMigration {
    var name: String { "CreatePresencehatTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("presence")
            .id()
            .field(.user_id, .uuid, .references("users", "id") ,.required)
            .field(.status ,.string ,.required)
            .field(.last_seen ,.datetime ,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("presence").delete()
    }
}
