//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent

struct CreateUser : AsyncMigration {
    var name: String { "CreateUserTable" }

    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field(.email ,.string,.required)
            .field(.username ,.string,.required)
            .field(.passwordHash ,.string,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
