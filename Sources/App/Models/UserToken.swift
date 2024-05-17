//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent
import Vapor



final class UserToken : Model, @unchecked Sendable {
  
    static let schema = "users"
    
        @ID(key: .id)
        var id: UUID?

        @Field(key: .value )
        var value: String

        @Parent(key: .user_id)
         var user : User
       
         init() {}

         init(id: UUID? = nil, value : String , userID : User.IDValue) {
               self.id = id
               self.value = value
               self.$user.id = userID
               
           }
    
    
    
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
