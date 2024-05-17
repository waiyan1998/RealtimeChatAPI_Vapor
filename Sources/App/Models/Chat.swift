//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor
import Fluent

final class Chat: Model , @unchecked Sendable  {
    
    static let schema = "chats"

    @ID(key: .id)
    var id: UUID?

    @Field(key: .type)
    var type: ChatType

    @Parent(key: .createdByuser_id)
    var createdByuser_id : User

    @Siblings(through: ChatMember.self , from: \.$chat , to: \.$user)
    var members : [User]
    
    init() {}
    init(id: UUID? = nil, type: ChatType, userID : User.IDValue ) {
        self.id = id
        self.type = type
        self.$createdByuser_id.id = userID
        
    }
}

enum ChatType: String, Content {
    case oneOnOne
    case group
}
