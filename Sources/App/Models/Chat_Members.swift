//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Fluent
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class ChatMember : Model, @unchecked Sendable {
    
    static let schema = "chat_members"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .chat_id)
    var chat : Chat
    
    @Parent(key: .user_id)
    var user : User

  

    init() { }

    init(id: UUID? = nil,  ChatID : Chat.IDValue , UserID : User.IDValue) {
        self.id = id
        self.$chat.id = ChatID
        self.$user.id = UserID
    }
    
    
}
