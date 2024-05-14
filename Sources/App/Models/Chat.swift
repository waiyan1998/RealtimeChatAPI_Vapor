//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor
import Fluent

final class Chat: Model, Content {
    static var schema = "chats"

    @ID(key: .id)
    var id: UUID?

    @Field(key: .type)
    var type: ChatType

    @Parent(key: .chatID)
    var creator: User

    @ID(key: .chatID)
    var chatID: UUID

    @Pivot(.members)
    var members: [User]

    @Field(key: .messages)
    var messages: [Message] // Note: Messages are loaded separately (explained later)

    init(id: UUID? = nil, type: ChatType, creator: User.ID, chatID: UUID) {
        self.id = id
        self.type = type
        self.creatorID = creator
        self.chatID = chatID
    }
}

enum ChatType: String, Content {
    case oneOnOne
    case group
}
