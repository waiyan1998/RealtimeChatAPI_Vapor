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
final class Users : Model, @unchecked Sendable {
   
    
    static let schema = "todos"
    
       @ID(key: .id)
       var id: UUID?

       @Field(key: .username)
       var username: String

       @Field(key: .email)
       var email: String

       @Field(key: .passwordHash)
       var passwordHash: String
    
       @Children(for: \.$users)
        var chats: [Chat]

      

       init(id: UUID? = nil, username: String, email: String, passwordHash: String) {
           self.id = id
           self.username = username
           self.email = email
           self.passwordHash = passwordHash
       }
    
    
    func toDTO() -> UserDTO {
        .init(
            id: self.id,
            username : self.$username.value,
            email : self.$email.value
        )
    }
}
