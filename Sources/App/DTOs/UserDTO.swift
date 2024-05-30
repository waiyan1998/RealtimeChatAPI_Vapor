//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor
import Fluent 

struct  UserDTO : Content , @unchecked  Sendable {
    
    var user_id : UUID?
    var username : String?
    var email : String?
    var createAt : String?
    var updateAt : String?
    
    var model  : User {
        let model = User()
        
        if let id = self.user_id {
            model.id  = id
        }
        if let username =  self.username {
            model.username = username
        }
        if let email =  self.email {
            model.email = email
        }
        if let createdAt = model.createdAt  {
            model.createdAt = createdAt
        }
        if let updatedAt = model.updatedAt{
            model.updatedAt = updatedAt
        }
        return model
    }
    
}
